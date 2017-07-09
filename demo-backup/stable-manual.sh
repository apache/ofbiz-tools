#!/bin/sh

cd /home/ofbizDemo/branch16.11
svn up
./gradlew --no-daemon "ofbiz --shutdown --portoffset 10000"
./gradlew --no-daemon cleanAll
./gradlew --no-daemon loadAll
./gradlew --no-daemon svnInfoFooter
./gradlew --no-daemon "ofbizBackground --start --portoffset 10000"
