#!/bin/sh

cd /home/ofbizDemo/branch13.7
svn up

#check if contrast-rO0.jar is present and apply
if [ ! -r "contrast-rO0.jar" ]; then
    wget -q https://svn.apache.org/repos/asf/ofbiz/branches/release15.12/tools/demo-backup/contrast-rO0.jar
fi
if [ ! -r "branch13.7-demo.patch" ]; then
    wget https://svn.apache.org/repos/asf/ofbiz/tools/demo-backup/branch13.7-demo.patch
    patch -p0 < branch13.7-demo.patch
fi

rm /home/ofbizDemo/branch13.7/framework/base/config/*.jks
rm /home/ofbizDemo/branch13.7/framework/base/config/jesse.properties
./ant stop -Dportoffset=20000
./ant clean-all
./ant load-demo
./ant svninfo
./ant start-batch-secure -Dportoffset=20000
