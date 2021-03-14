#!/bin/bash
#####################################################################
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#####################################################################

# verify-ofbiz-release.sh
# Apache OFBiz release verification tool.
# Downloads and checks the given release zip file for correct md5/SHA checksums 
# and signing certificate (see https://www.apache.org/dev/release-signing.html).
# If selected, can also automatically unpack the release, init the Gradle warapper
# and perform the integration tests.
#
# Usage: $0  [-h] [-d] [-v] [-t] [-a] [apache-ofbiz-xx.xx.xx]
# Options
# -h print help and exit
# -d download release files
# -v verify release files
# -t run integration tests
# -a all of the above
#
# to log the output to a file, do something like
# ./verify-ofbiz-release.sh -a apache-ofbiz-17.12.06  2>&1 | tee verify.log

# configuration
VERSION=0.2
URL='https://dist.apache.org/repos/dist/dev/ofbiz'

# color definitions for output
RED='\033[0;31m'
GRN='\033[0;32m'
NC='\033[0m' # No Color

# Preserve original language and set en_EN
TEMPLANG=$LANG
LANG=en_EN.UTF-8

printHelp () {
cat <<EOF
Apache OFBiz release verification tool v$VERSION.

Usage: $0  [-h] [-d] [-v] [-t] [-a] [apache-ofbiz-xx.xx.xx]

Options:
   -h  print help and exit
   -d  download release files
   -v  verify release files
   -t  run integration tests
   -a  all of the above

To log the output to a file, use something like
./verify-ofbiz-release.sh -a apache-ofbiz-17.12.06  2>&1 | tee verify.log
EOF
}

# np parameters at all - print help and exit
if [[ $# -eq 0 ]] ; then
    printHelp
    exit 1
fi

# initialize switches
download=false
verify=false
runtests=false

# get options and strip from commandline
while getopts "hdvta" option
do
  case $option in
    h) printHelp; exit 0 ;;
    d) download=true ;;
    v) verify=true ;;
    t) runtests=true ;;
    a) download=true; verify=true; runtests=true ;;
    ?) echo "Error: option -$OPTARG is not implemented."; exit 1;;
  esac
done

shift $(( OPTIND - 1 ))

# no remaining argument with the release name - print help and exit
if [[ $1 -eq 0 ]] ; then
    printHelp
    exit 1
fi

# remaining (last) parameter is the release name
RELEASE=$1
ZIP=$RELEASE.zip

printHelp () {
    echo "Usage: $0  [-h] [-d] [-v] [-t] [-a] [apache-ofbiz-xx.xx.xx]"
    echo "Options:"
    echo "-h print help and exit"
    echo "-d download release files"
    echo "-v verify release files"
    echo "-t run integration tests"
    echo "-a all of the above"
}

downloadFiles () {
    echo "Downloading files for $ZIP..."

    wget $URL/KEYS
    wget $URL/$ZIP
    wget $URL/$ZIP.asc
    wget $URL/$ZIP.sha512

    echo 'Done!'
}

verifyFiles () {
    echo "Verifying files..."

    if [ ! -f $ZIP.sha512 ];
    then
        echo -e "${RED}skipping sha check!${NC} (sha checksum file $ZIP.sha512 not found)\n"
    else
        checkSHA $ZIP
    fi

    if [ ! -f $ZIP.asc ];
    then
        echo -e "${RED}skipping signature check!${NC} (signature file $ZIP.asc not found)"
    else
        echo "GPG verification output"
        LC_MESSAGES=en_EN.UTF-8 gpg --verify $ZIP.asc $ZIP
    fi
}

checkSHA () {
    file1=`gpg --print-md SHA512 $ZIP`
    file2=`cut -d* -f1 $ZIP.sha512`

    echo "sha check of file: $ZIP"
    echo "Using sha file: $ZIP.sha512"
    echo $file1
    echo $file2

    if [ "$file1" != "$file2" ]
    then
        echo -e "${RED}sha sums mismatch!${NC}"
    else
        echo -e "${GRN}sha checksum OK${NC}"
    fi

    echo ""
}

runTests () {
    if [ ! -d $RELEASE ];
    then
        echo "Unpacking release file archive $ZIP..."
        unzip $ZIP
    fi
    cd $RELEASE

    echo "Initializing Gradle wrapper..."
    ./gradle/init-gradle-wrapper.sh

    echo "Running tests..."
    ./gradlew cleanAll loadAll testIntegration

    cd ..
}

echo "Processing files for release: $RELEASE..."

# downlad release files
if [ "$download" = true ]
then
    downloadFiles
fi

# verify release files
if [ "$verify" = true ]
then
    verifyFiles
fi

# unpack, init Gradle wrapper and run integration tests
if [ "$runtests" = true ]
then
    runTests
fi

# reset original language
LANG=$TEMPLANG

echo "Done processing files for release $RELEASE"

exit 0
