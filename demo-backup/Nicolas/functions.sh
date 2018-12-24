#!/usr/bin/env bash

resetSvn() {
    cd $1

    #reset user file modification
    svn revert -R *

    #remove user adding file not versionned
    IFS=$'\n'
    for i in $(svn st | grep ^? |cut -c 9-); do rm -fr "$i"; done;
    if [ -n "$(svn st | grep ^?)" ]; then
        # this to remove all unsupported file name like C:/ created and not cover by previous command
        for i in $(svn st | grep ^? |cut -c 9-); do
            rename_file = "$(echo $i| sed s/[:\\\ ]/_/g)";
            mv "$i" "$rename_file";
            rm "$rename_file";
        done;
    fi
}

#remove unecessary config for demo
removeUneededFiles() {
    cd $1

    if [ -n "$(ls $OFBIZ_DIR/framework/base/config/*)" ]; then
        rm $OFBIZ_DIR/framework/base/config/*.jks
    fi
    if [ -r "$OFBIZ_DIR/framework/base/config/jesse.properties" ]; then
        rm $OFBIZ_DIR/framework/base/config/jesse.properties
    fi
}