#!/bin/bash

# create an array from all images in the User Pictures subfolders

IFS=$'\n' read -rd '' -a pictures <<< "$(find '/Library/User Pictures/Fun' -name *.tif -print )"

# since the paths may contain spaces, use this to safely read a value
dsclread() { # $1: recordpath $2: attributename
  /usr/libexec/PlistBuddy -c "print :dsAttrTypeStandard\:$2:0" /dev/stdin <<< $(dscl -plist . read "$1" "$2")
}

# for testing you can pass a user name as an argument, otherwise use current user
# then the script has to run as root
if [[ -z $1 ]]; then
    # since we don't need to connect to the UI, using $USER is ok
    user=$USER
else
    user=$1
    if [[ ! $user == $USER && ! $EUID -eq 0 ]]; then
        echo "to change another user's record, this script needs to run as root"
        exit 1
    fi
fi

# get first letter of user name
initial=${user:0:1}

if [[ ! $initial =~ [a-zA-Z] ]]; then
    echo "username '$user' does not start with a letter, exiting..."
    exit 1
fi

# get image starting with same letter as username
IFS=$'\n' read -rd '' -a pictures <<< "$(find '/Library/User Pictures' -iname "$initial"*.tif -print )"

count=${#pictures[@]}
if [[ $count -eq 0 ]]; then
    echo "no picture found for initial '$initial', exiting..."
    exit 1
fi

# get a random index
index=$(( RANDOM % ${#pictures[@]} ))

newpic=${pictures[$index]}

# delete JPEGPhoto
dscl . delete "/Users/$user" JPEGPhoto

# get old picture value
oldpic=$(dsclread "/Users/$user" Picture )

# update path in picture
dscl . change "/Users/$user" Picture "$oldpic" "$newpic"

echo "set user picture for $user to $newpic"
