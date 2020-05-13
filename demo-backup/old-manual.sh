#!/bin/sh

echo This cant be used alone, see OFBIZ-10287. You need for now to use all-manual-nicely.sh

cd /home/ofbizDemo/branch16.11
svn up
rm /home/ofbizDemo/branch16.11/framework/base/config/*.jks

# I have decided to apply patches once for all. The reason is else they are 
# applied once and not later. So it's easier like that. 
# If we need to change the patches they will be reverted and applied again. 
# Hopefully only when changing stable and old.


#patch -p0 < /home/ofbizDemo/branch16.11/url.properties.patch
#patch -p0 < /home/ofbizDemo/branch16.11/fop.xconf.patch

#cd /home/ofbizDemo/branch16.11/specialpurpose
#patch -p0 < /home/ofbizDemo/branch16.11/solr.config.patch
#cd ..


./gradlew --no-daemon "ofbiz --shutdown --portoffset 20000"
./gradlew --no-daemon cleanAll
./gradlew --no-daemon "ofbiz --load-data"
./gradlew --no-daemon svnInfoFooter
./gradlew --no-daemon "ofbizBackground --start --portoffset 20000"