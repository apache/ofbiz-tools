#!/usr/bin/env bash
# Script to pull and redeploy OFBiz container images to docker-compose applications.

set -x
set -e

cd /home/ofbizdocker

echo Restarting exp1 docker-compose application with latest container images.
pushd exp1
docker compose down --volumes
docker compose pull
docker compose up --detach
popd
echo Exp1 docker-compose application restarted.

echo Restarting exp2 docker-compose application with latest container images.
pushd exp2
docker compose down --volumes
docker compose pull
docker compose up --detach
popd
echo Exp2 docker-compose application restarted.
