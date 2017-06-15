#!/bin/sh

cd /home/ofbizDemo/trunk
svn up
./gradlew pullAllPluginsSource
./gradlew terminateOfbiz
./gradlew cleanAll
./gradlew loadAll
./gradlew svnInfoFooter
./gradlew ofbizBackground
