#!/bin/bash

# verify-ofbiz-release.sh
# checks the given release zip file for correct md5/SHA checksums and signing certificate
# see https://www.apache.org/dev/release-signing.html

# color definitions for output
RED='\033[0;31m'
GRN='\033[0;32m'
NC='\033[0m' # No Color

# use english gpg output
LC_MESSAGES=en_EN.UTF-8

if [[ $# -eq 0 ]] ; then
    echo "Usage: $0 [apache-ofbiz-xx.xx.xx.zip]"
    exit 1
fi

checkSHA () {
    file1=`gpg --print-md SHA512 $1`
    file2=`cut -d* -f1 $1.sha512`

    echo "sha check of file: $1"
    echo "Using sha file: $1.sha512"
    echo $file1
    echo $file2

    if [ "$file1" != "$file2" ]
    then
        echo -e "${RED}sha sums mismatch!${NC}"
    else
        echo -e "${GRN}sha checksum OK${NC}"
    fi

    echo ""

    return 0
}

if [ ! -f $1.sha512 ];
then
    echo -e "${RED}skipping sha check!${NC} (sha checksum file $1.sha512 not found)\n"
else
    checkSHA $1
fi

if [ ! -f $1.asc ];
then
    echo -e "${RED}skipping signature check!${NC} (signature file $1.asc not found)"
else
    echo "GPG verification output"
    gpg --verify $1.asc $1
fi
