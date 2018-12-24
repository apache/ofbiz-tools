#!/bin/bash
. "functions.sh"

OFBIZ_DIR="/home/ofbizDemo/branch13.7"
cd $OFBIZ_DIR

#Stop and clean OFBiz
./ant stop -Dportoffset=20000
./ant clean-all

#update source code
resetSvn $OFBIZ_DIR
svn up

removeUneededFiles $OFBIZ_DIR

#check if contrast-rO0.jar is present and apply
if [ ! -r "contrast-rO0.jar" ]; then
    wget -q https://svn.apache.org/repos/asf/ofbiz/branches/release15.12/tools/demo-backup/contrast-rO0.jar
fi
if [ ! -r "branch13.7-demo.patch" ]; then
    wget https://svn.apache.org/repos/asf/ofbiz/tools/demo-backup/branch13.7-demo.patch
    patch -p0 < branch13.7-demo.patch
fi

#Load Data and run OFBiz
./ant load-demo
./ant svninfo
./ant start-batch-secure -Dportoffset=20000

