#!/bin/sh

cd /home/ofbizDemo/trunk
svn up
./gradlew --no-daemon pullAllPluginsSource
./gradlew --no-daemon ofbiz terminateOfbiz
./gradlew --no-daemon cleanAll
./gradlew --no-daemon loadAll
./gradlew --no-daemon svnInfoFooter
./gradlew --no-daemon ofbizBackground
