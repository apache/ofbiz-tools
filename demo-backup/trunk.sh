#!/bin/sh

echo This cant be used alone, see OFBIZ-10287. You need for now to use all-manual-nicely.sh

cd /home/ofbizDemo/trunk
// checkout patched files before patching them, else git pull would not work
git checkout framework/webapp/config/url.properties
git checkout framework/webapp/config/fop.xconf
git pull
patch -p0 < /home/ofbizDemo/trunk/url.properties.patch
patch -p0 < /home/ofbizDemo/trunk/fop.xconf.patch

// We don't want *.jks, we use "Let's encrypt"
rm /home/ofbizDemo/trunk/framework/base/config/*.jks


./gradlew --no-daemon pullAllPluginsSource
// Here no need to check out, it's not a repo. So patching is OK
cd /home/ofbizDemo/trunk/plugins
patch -p0 < /home/ofbizDemo/trunk/solr.config.patch
cd ..

./gradlew --no-daemon terminateOfbiz
./gradlew --no-daemon cleanAll
./gradlew --no-daemon loadAll
./gradlew --no-daemon gitInfoFooter
./gradlew --no-daemon ofbizBackground
