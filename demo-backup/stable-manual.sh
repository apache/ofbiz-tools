#!/bin/sh

echo This cant be used alone, see OFBIZ-10287. You need for now to use all-manual-nicely.sh
cd /home/ofbizDemo/branch18.12
git pull
rm /home/ofbizDemo/branch18.12/framework/base/config/*.jks

# I have decided to apply patches once for all. The reason is else they are 
# applied once and not later. So it's easier like that. 
# If we need to change the patches they will be reverted and applied again. 
# Hopefully only when changing stable and old.

#patch -p0 < /home/ofbizDemo/branch18.12/url.properties.patch
#patch -p0 < /home/ofbizDemo/branch18.12/fop.xconf.patch


#the ones under plugins must be applied  each time 
# because pullAllPluginsSource removes the plugins dir

./gradlew --no-daemon pullAllPluginsSource
cd /home/ofbizDemo/branch18.12/plugins
patch -p0 < /home/ofbizDemo/branch18.12/solr.config.patch
cd ..

./gradlew --no-daemon "ofbiz --shutdown --portoffset 10000"
./gradlew --no-daemon cleanAll
./gradlew --no-daemon loadAll
./gradlew --no-daemon gitInfoFooter
./gradlew --no-daemon "ofbizBackground --start --portoffset 10000"
