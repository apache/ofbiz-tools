#!/bin/sh

# Restart each morning at 3
# for ofbizDemo user
# crontab -e
# add : 0 3 * * * nice -n 19 ionice -c2 -n7 /home/ofbizDemo/check-svn-update.sh > /home/ofbizDemo/cronlog-svn-update.log 2>&1
# to test:  */10 * * * * ....

./all-manual.sh
