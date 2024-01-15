# General description
Three instances of OFBiz run on the OFBiz demo VM at https://ofbiz-vm1.apache.org.

* trunk: the trunk version
* stable: the last stable version (currently 18.12)
* next: the next stable version (currently 22.01)

This is the 3rd instance of VM we use hence the 3 in its hostname.
The root of https://ofbiz-vm1.apache.org is the so called bigfiles directory which is actually at /var/www/ofbiz/big-files.

We own 6 hostnames on the ofbiz subdomain.

* https://demo-trunk.ofbiz.apache.org
* https://demo-stable.ofbiz.apache.org
* https://demo-next.ofbiz.apache.org
* https://exp1.ofbiz.apache.org
* https://exp2.ofbiz.apache.org
* https://exp3.ofbiz.apache.org

The first 3 hostnames are used to host the OFBiz demo sites.

The last 3 hostnames are used for experiemental hosting from time to time.

The Puppet configuration is at
https://github.com/apache/infrastructure-p6/blob/production/data/nodes/ofbiz-vm1.apache.org.yaml
It's currently impossible to directly modify, it's a private Github repo.
Just create an Infra Jira asking for the wanted change...and be patient ;)

# Accessing the demo host
SSH to *ofbiz-vm1.apache.org* server (a VM actualy), then follow the below procedure.
You will need to use OTP (One Time Password). For documentation on how to use OPIE (One time Passwords In Everything), see [this page](https://cwiki.apache.org/confluence/display/INFRA/OPIE "OTP doc").

# Open a shell as the _ofbizdocker_ user

>_Note_: **Only run the ofbiz demos using the 'ofbizdocker' user, never run as root.**

    You need to be registered as a sudoer (ask Infra).

    Then sudo to the ofbizdocker user:

    sudo -s -u ofbizdocker -H

    Sudo uses OTP. Use a tool like https://selfserve.apache.org/otp-md5.html to generate the OTP
    You can then start/stop as required.
    
    Type 'exit' to exit the ofbizdocker user and return to your username.

# Updates to the demo sites

A cron job, defined by [/etc/cron.d/ofbizdocker](ofbizdocker/etc/cron.d/ofbizdocker), is executed daily at 02:35 UTC.  This cron job calls script [pull-and-restart.sh](ofbizdocker/home/ofbizdocker/pull-and-restart.sh) to pull the latest version of each demo's sites container image tag and then restart their docker compose application.

For more information about the use of docker to host the OFBiz demo sites, see the  [ofbizdocker README.md](ofbizdocker/README.md) file.

## Letsencrypt certificate update
It was a time when every 3 months we needed to manually update our Letsencrypt certificate. It was automated before, it's now again, so no worries. Anyway, if necessary it's quite easy to do so. Simply connect to the demo VM and run

    sudo certbot renew

I got this message today (2020-04-17):

    Processing /etc/letsencrypt/renewal/ofbiz-vm1.apache.org.conf
    - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    Cert not yet due for renewal
    - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    The following certs are not due for renewal yet:
      /etc/letsencrypt/live/ofbiz-vm1.apache.org/fullchain.pem expires on 2020-06-08 (skipped)
    No renewals were attempted.
    - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

and always since: it's OK. Nothing to do, it's automated. :)
In case you get an issue, simply restart the VM and restart the demos. That happened once: https://issues.apache.org/jira/browse/INFRA-23637
