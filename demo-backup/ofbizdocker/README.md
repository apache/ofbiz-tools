# Experimenting with docker builds and deployments of OFBiz

As part of OFBIZ-12757, docker builds and deployments are being carried out using VM ofbiz-vm1.apache.org.

Files in this subdirectory of the ofbiz-tools repository reflect files which should be created on the root filesystem of ofbiz-vm1.apache.org with the following additions and/or settings:
* /etc/cron.d/ofbizdocker
  * Owned by root with permissions 0644
* /home/ofbizdocker/pull-rebuild-restart.sh
  * Owned by ofbizdocker user with permissions 0775
* /home/ofbizdocker/ofbiz-framework
  * Git clone of https://github.com/apache/ofbiz-framework with the experimental-docker branch checked otu.


## How do the Docker builds and deployments work

At 02:35h each day, the cronttab defined by `/etc/cron.d/ofbizdocker` will execute script `pull-rebuild-restart.sh`. 

The `pull-rebuild-restart.sh` script does the following:
1. Run `git pull` in the `/home/ofbizdocker/ofbiz-framework` directory.
1. Build an OFBiz docker image based on sources in `/home/ofbizdocker/ofbiz-framework` with demo data preloaded.
1. Build a second OFBiz docker image, but with no data preloaded.
1. Recreate the docker compose application defined in the `exp1` directory, making use of the new container image with preloaded demo data.
1. Recreate the docker compose application defined in the `exp2` directory, making use of the new container image without preloaded data. This docker compose application is configured to load seed data on its first run.

The `exp1` application listens on AJP port 38009. The `exp2` application listens on AJP port 48009. The Apache server on ofbiz-vm1.apache.org has been configured to reverse-proxy to these applications for hostnames exp1.ofbiz.apache.org and exp2.ofbiz.apache.org.
