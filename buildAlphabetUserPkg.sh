#!/bin/bash

export PATH=/usr/bin:/bin:/usr/sbin:/sbin

pkgname="AlphabetUserPictures"
version="1.0"
identifier="com.scriptingosx.${pkgname}"
install_location="/"

projectfolder=$(dirname "$0")

pkgpath="${projectfolder}/${pkgname}-${version}.pkg"

pkgbuild --root "${projectfolder}/payload" \
         --identifier "${identifier}" \
         --version "${version}" \
         --install-location "${install_location}" \
         "${pkgpath}"
