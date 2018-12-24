#!/bin/bash
. "functions.sh"

OFBIZ_DIR = "/home/ofbizDemo/branch16.11"
echo "This can't be used alone, see OFBIZ-10287. You need for now to use all-manual-nicely.sh";

cd $OFBIZ_DIR

# Stop, clean and run OFBiz
./gradlew --no-daemon "ofbiz --shutdown --portoffset 10000"
./gradlew --no-daemon cleanAll

#update source code
resetSvn $OFBIZ_DIR
svn up

removeUneededFiles $OFBIZ_DIR

# run OFBiz
./gradlew --no-daemon "ofbiz --load-data"
./gradlew --no-daemon svnInfoFooter
./gradlew --no-daemon "ofbizBackground --start --portoffset 10000"

