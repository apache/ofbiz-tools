#!/bin/sh

echo This cant be used alone, see OFBIZ-10287. You need for now to use all-manual-nicely.sh
cd /home/ofbizDemo/branch17.12
git pull
rm /home/ofbizDemo/branch17.12/framework/base/config/*.jks

./gradlew --no-daemon pullAllPluginsSource
./gradlew --no-daemon "ofbiz --shutdown --portoffset 10000"
./gradlew --no-daemon cleanAll
./gradlew --no-daemon loadAll
./gradlew --no-daemon gitInfoFooter
./gradlew --no-daemon "ofbizBackground --start --portoffset 10000"
