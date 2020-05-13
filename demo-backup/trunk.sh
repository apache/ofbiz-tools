#!/bin/sh

cd /home/ofbizDemo/trunk
git pull
rm /home/ofbizDemo/trunk/framework/base/config/*.jks

# I have decided to apply patches once for all. The reason is else they are 
# applied once and not later. So it's easier like that. 
# If we need to change the patches they will be reverted and applied again. 
# Hopefully only when changing stable and old.

#patch -p0 < /home/ofbizDemo/trunk/url.properties.patch
#patch -p0 < /home/ofbizDemo/trunk/fop.xconf.patch

#the ones under plugins must be applied  each time 
# because pullAllPluginsSource removes the plugins dir

./gradlew --no-daemon pullAllPluginsSource
cd /home/ofbizDemo/trunk/plugins
patch -p0 < /home/ofbizDemo/trunk/solr.config.patch
cd ..

./gradlew --no-daemon terminateOfbiz
./gradlew --no-daemon cleanAll
./gradlew --no-daemon loadAll
./gradlew --no-daemon gitInfoFooter
./gradlew --no-daemon ofbizBackground
