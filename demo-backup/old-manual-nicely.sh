#!/bin/sh

echo This does not work, see OFBIZ-10287. You need for now to use all-manual-nicely.sh

# nohup nice -n 19 ionice -c2 -n7 ./old-manual.sh &