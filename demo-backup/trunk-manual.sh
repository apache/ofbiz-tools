#!/bin/sh

cd /home/ofbizDemo/trunk
svn up
./gradlew pullAllPluginsSource
./gradlew "ofbiz --shutdown"
./gradlew cleanAll
./gradlew loadAll
./gradlew svnInfoFooter
./gradlew ofbizBackground
