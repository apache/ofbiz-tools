#!/bin/sh

echo "### --------------- ###"
echo "### Run OFBiz trunk ###"
echo "### --------------- ###"
./trunk.sh

echo "### ---------------- ###"
echo "### Run OFBiz stable ###"
echo "### ---------------- ###"
./stable-manual.sh

echo "### ------------- ###"
echo "### Run OFBiz old ###"
echo "### ------------- ###"
./old-manual.sh

cd /home/ofbizDemo
