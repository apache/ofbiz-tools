#!/bin/sh

cd /home/ofbizDemo/branch16.11
svn up
./gradlew "ofbiz --shutdown --portoffset 10000"
./gradlew cleanAll
./gradlew "ofbiz --load-data"
./gradlew svnInfoFooter
./gradlew "ofbizBackground --start --portoffset 10000"
