#!/bin/sh

cd /home/ofbizDemo/trunk
git pull
rm /home/ofbizDemo/trunk/framework/base/config/*.jks

./gradlew --no-daemon pullAllPluginsSource
./gradlew --no-daemon terminateOfbiz
./gradlew --no-daemon cleanAll
./gradlew --no-daemon loadAll
./gradlew --no-daemon gitInfoFooter
./gradlew --no-daemon ofbizBackground
