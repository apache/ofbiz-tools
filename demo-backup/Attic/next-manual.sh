#!/bin/bash

echo This cant be used alone, see OFBIZ-10287. You need for now to use all-manual-nicely.sh

. ~/.sdkman/bin/sdkman-init.sh
sdk use java 17.0.2-tem

cd /home/ofbizDemo/branch22.01

# checkout patched files before patching them, else git pull would not work
git checkout framework/webapp/config/url.properties
git checkout framework/webapp/config/fop.xconf
git pull
patch -p0 < /home/ofbizDemo/branch22.01/url.properties.patch
patch -p0 < /home/ofbizDemo/branch22.01/fop.xconf.patch

# We don't want *.jks, we use "Let's encrypt"
rm /home/ofbizDemo/branch22.01/framework/base/config/*.jks


./gradlew --no-daemon pullAllPluginsSource
# Here no need to check out, it's not a repo. So patching is OK
cd /home/ofbizDemo/branch22.01/plugins
patch -p0 < /home/ofbizDemo/branch22.01/solr.config.patch
cd ..

./gradlew --no-daemon "ofbiz --shutdown --portoffset 20000"
./gradlew --no-daemon cleanAll
./gradlew --no-daemon loadAll
./gradlew --no-daemon gitInfoFooter
./gradlew --no-daemon "ofbizBackground --start --portoffset 20000"
