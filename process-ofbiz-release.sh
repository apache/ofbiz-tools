#!/bin/bash
# Script to help the release creation 
# we consider that you execute this on a directory with the source code from git present on two directory ofbiz-framework and ofbiz-plugins
# Just run like this $. ${scriptPath}/process-ofbiz-release.sh 24.09.01

# color definitions for output
RED='\033[0;31m'
GRN='\033[0;32m'
NC='\033[0m' # No Color

if [[ $# -eq 0 ]] ; then
    echo -e "Usage: $0 ${RED}[version]${NC}"
    exit 1
fi

mkdir -p apache-ofbiz-$1/
mkdir -p apache-ofbiz-$1/plugins/
set -o pipefail
curl -fsSL https://github.com/apache/ofbiz-framework/archive/refs/tags/release$1.tar.gz | tar -xz -C apache-ofbiz-$1/ --strip-components=1
curl -fsSL https://github.com/apache/ofbiz-plugins/archive/refs/tags/release$1.tar.gz | tar -xz -C apache-ofbiz-$1/plugins/ --strip-components=1

# Remove unwanted file
rm apache-ofbiz-$1/plugins/LICENSE \
   apache-ofbiz-$1/plugins/VERSION \
   apache-ofbiz-$1/plugins/.project \
   apache-ofbiz-$1/.pre-commit-config.yaml
rm -r apache-ofbiz-$1/.github \
      apache-ofbiz-$1/plugins/.github \

# Put stable tag
sed -i -e 's/orange.svg/green.svg/g' apache-ofbiz-$1/README.adoc

# Set the version
echo "$1" > apache-ofbiz-$1/VERSION

# Zip
zip  apache-ofbiz-$1.zip -r -T apache-ofbiz-$1/*

# Sign
gpg --armor --detach-sig --output apache-ofbiz-$1.zip.asc apache-ofbiz-$1.zip
gpg --print-md SHA512 apache-ofbiz-$1.zip > apache-ofbiz-$1.zip.sha512

# To finish
echo -e "## ${GRN}Done${NC}, You can check the generated archive ${GRN}apache-ofbiz-$1.zip${NC}"
echo -e "## If it's validate ${RED}don't forget to push the tag${NC} on ofbiz-framework and ofbiz-plugins"
echo -e "## -> git push origin tag release$1"
