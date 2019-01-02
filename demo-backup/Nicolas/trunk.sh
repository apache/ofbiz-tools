#!/bin/bash
. "functions.sh"

OFBIZ_DIR="/home/ofbizDemo/trunk"
cd $OFBIZ_DIR

#Stop OFBiz
./gradlew --no-daemon terminateOfbiz
./gradlew --no-daemon cleanAll

#update source code
resetSvn $OFBIZ_DIR
svn up

./gradlew --no-daemon pullAllPluginsSource

removeUneededFiles $OFBIZ_DIR

applyPatches $OFBIZ_DIR ~/patch/trunk

# run OFBiz
./gradlew --no-daemon loadAll
./gradlew --no-daemon svnInfoFooter
./gradlew --no-daemon ofbizBackground

