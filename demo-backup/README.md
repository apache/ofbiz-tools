# General description
Three instances of OFBiz run on the OFBiz demo VM3 at https://ofbiz-vm3.apache.org.

* trunk: the trunk version
* stable: the last stable version (currently 18.12)
* old: the previous stable version (currently 17.12)
 
This is the 3rd instance of VM we use hence the 3 in its domain name.
The root of https://ofbiz-vm3.apache.org is the so called bigfiles directory which is actually at /var/www/ofbiz/big-files.

We own 3 Apache sub domains

* https://demo-trunk.ofbiz.apache.org
* https://demo-stable.ofbiz.apache.org
* https://demo-old.ofbiz.apache.org

The Puppet configuration is at 
https://github.com/apache/infrastructure-p6/blob/production/data/nodes/ofbiz-vm3.apache.org.yaml
It's currently impossible to directly modify, it's a private Github repo.
Just create an Infra Jira asking for the wanted change...and be patient ;)

# Actions on demos
SSH to *ofbiz-vm3.apache.org* server (a VM actualy), then follow the below procedure. 
You will need to use OTP (One Time Password). For documentation on how to use OPIE (One time Passwords In Everything), see [this page](https://cwiki.apache.org/confluence/display/INFRA/OPIE "OTP doc").

>_Note_: **Only run the ofbiz demos using the 'ofbizDemo' user, never run as root.** 
    
    You need to be registered as a sudoer (ask Infra).
    
    Then sudo to the ofbizDemo user:

    sudo -s -u ofbizDemo -H
      
    Sudo uses OTP. Use a tool like https://selfserve.apache.org/otp-md5.html to generate the OTP
    You can then start/stop as required.

    To check if the demos are being run as the ofbizDemo user:

    ps aux | grep ofbizDemo

    The first column on the left tell you the username the demo is
    being run as - it should say ofbizDemo (UID).

    Type 'exit' to exit the ofbizDemo user and return to your username.

Also note that the demos are usually updated and started/stopped automatically using the check-svn-update.sh script in this directory. It is run by an ofbizDemo cron job every 24 hours at 3 AM. You should therefore only need to start/stop manually if there is a problem.

## Upgrade stable and old demos

You need first to create a branchAA.mm directory under the ofbizDemo directory and to clone the related releaseAA.mm in this new directory. Then to copy and apply the patches contained in the old-manual.sh and  stable-manual.sh files, read the comments in these files for details.

Looking at the Puppet configuration (see above) you will see that you only need to change the old-manual.sh and  stable-manual.sh files to upgrade stable and old demos. Because they are defined in the Puppet configuration by respectively 

    stable: ProxyPass / ajp://localhost:18009/  
    old   : ProxyPass / ajp://localhost:28009/ 
    
Finally you need to kill the current stable and old processes before running again the demos using 

    ./all-manual-nicely.sh 


## Letsencrypt certificate update
It was a time when every 3 months we needed to manually update our Letsencrypt certificate. It was automated before, it's now again, so no worries. Anyway, if necessary it's quite easy to do so. Simply connect to the demo VM and run

    sudo certbot renew

I got this message today (2020-04-17):

    Processing /etc/letsencrypt/renewal/ofbiz-vm3.apache.org.conf
    - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    Cert not yet due for renewal
    - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    The following certs are not due for renewal yet:
      /etc/letsencrypt/live/ofbiz-vm3.apache.org/fullchain.pem expires on 2020-06-08 (skipped)
    No renewals were attempted.
    - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

and always since: it's OK. Nothing to do, it's automated. :)

# Current restriction 
~~If you want to restart only a single instance you can respectively use
trunk-manual-nicely.sh
stable-manual-nicely.sh
old-manual-nicely.sh~~
This does not work.See why at https://issues.apache.org/jira/browse/OFBIZ-10287
So you need to use  ./all-manual-nicely.sh from ofbizDemo
From time to time (every months?) better to delete nohup.out.

# Keep the VM clean
From time to time (I'd say when it's hundreds of MB) we need to delete the nohup.out file. It's used when you manually start the demos and acts as an issues history. Then simply sign in as ofbizDemo user and delete the file.

Also, it's OK for months but at some point I had to clean the Gradle cache. For now just verify with "df" command that we are not graping too much memory, around 50% on /dev/xvda1 is OK


