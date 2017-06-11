#!/bin/sh

cd /home/ofbizDemo/trunk
svn up
./gradlew pullAllPluginsSource
./gradlew "ofbizBackground --shutdown"
./gradlew cleanAll
./gradlew loadDefault
./gradlew svnInfoFooter
./gradlew ofbizBackground
