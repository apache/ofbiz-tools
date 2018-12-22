#!/bin/sh

cd /home/ofbizDemo/branch13.7
svn up
rm /home/ofbizDemo/branch13.7/framework/base/config/*.jks
rm /home/ofbizDemo/branch13.7/framework/base/config/jesse.properties
./ant stop -Dportoffset=20000
./ant clean-all
./ant load-demo
./ant svninfo
./ant start-batch-secure -Dportoffset=20000
