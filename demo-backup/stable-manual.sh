#!/bin/bash

echo This cant be used alone, see OFBIZ-10287. You need for now to use all-manual-nicely.sh

. ~/.sdkman/bin/sdkman-init.sh
sdk use java 11.0.4-tem

cd /home/ofbizDemo/branch18.12

# checkout patched files before patching them, else git pull would not work
git checkout framework/webapp/config/url.properties
git checkout framework/webapp/config/fop.xconf
git pull
patch -p0 < /home/ofbizDemo/branch18.12/url.properties.patch
patch -p0 < /home/ofbizDemo/branch18.12/fop.xconf.patch

# We don't want *.jks, we use "Let's encrypt"
rm /home/ofbizDemo/branch18.12/framework/base/config/*.jks


./gradlew --no-daemon pullAllPluginsSource
# Here no need to check out, it's not a repo. So patching is OK
cd /home/ofbizDemo/branch18.12/plugins
patch -p0 < /home/ofbizDemo/branch18.12/solr.config.patch
patch -p0 < /home/ofbizDemo/trunk/birt.patch
cd ..

./gradlew --no-daemon "ofbiz --shutdown --portoffset 10000"
./gradlew --no-daemon cleanAll
./gradlew --no-daemon loadAll
./gradlew --no-daemon gitInfoFooter
./gradlew --no-daemon "ofbizBackground --start --portoffset 10000"

