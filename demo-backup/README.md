# General description
Three instances of OFBiz run on the OFBiz demo VM3 at https://ofbiz-vm3.apache.org.

* trunk: the trunk version
* stable: the last stable version (currently 16.11)
* old: the previous stable version (currently 13.07)
 
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

## Letsencrypt certificate update
Every 3 months we need to manually update our Letsencrypt certificate. It was automated before, it's maybe again but I had no news about it. Anyway, it's quite easy to do so. Simply connect to the demo VM and run

    sudo certbot renew

Done so today 2020-04-12 so next time will be few days before 2020-07-12, etc.


# Current restriction 
~~If you want to restart only a single instance you can respectively use
trunk-manual-nicely.sh
stable-manual-nicely.sh
old-manual-nicely.sh~~
This does not work, at least for instances using Gradle (currently trunk and stable, ie R16).
See why at https://issues.apache.org/jira/browse/OFBIZ-10287 
Hence currently R13.07 is not affected you can use *old-manual-nicely.sh* to only restart the old demo.
And you need for now to use *all-manual-nicely.sh* when trunk or/and stable are affected.

 
