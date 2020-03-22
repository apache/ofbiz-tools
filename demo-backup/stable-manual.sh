#!/bin/sh

cd /home/ofbizDemo/branch17.12
git pull
rm /home/ofbizDemo/branch17.12/framework/base/config/*.jks

./gradlew --no-daemon pullAllPluginsSource
./gradlew --no-daemon "ofbiz --shutdown --portoffset 10000"
./gradlew --no-daemon cleanAll
./gradlew --no-daemon loadAll
./gradlew --no-daemon gitInfoFooter
./gradlew --no-daemon "ofbizBackground --start --portoffset 10000"
