#!/bin/sh

cd /home/ofbizDemo/branch16.11
svn up
rm /home/ofbizDemo/branch16.11/framework/base/config/*.jks
rm /home/ofbizDemo/branch16.11/framework/base/config/jesse.properties
./gradlew --no-daemon "ofbiz --shutdown --portoffset 10000"
./gradlew --no-daemon cleanAll
./gradlew --no-daemon "ofbiz --load-data"
./gradlew --no-daemon svnInfoFooter
./gradlew --no-daemon "ofbizBackground --start --portoffset 10000"

