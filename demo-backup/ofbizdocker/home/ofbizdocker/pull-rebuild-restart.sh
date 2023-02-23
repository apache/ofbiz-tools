#!/usr/bin/env bash
# Script to pull OFBiz sources, rebuild container images and redeploy those container images to docker-compose applications.

set -x
set -e

cd /home/ofbizdocker

echo Pulling OFBiz sources.
pushd ofbiz-framework
git pull
popd
echo OFBiz sources updated.

echo Building OFBiz docker image, preloaded with demo data.
pushd ofbiz-framework
DOCKER_BUILDKIT=1 docker build --progress plain --target demo --tag ofbiz-docker-preloaded-demo .
popd
echo Built image ofbiz-docker-preloaded-demo.

echo Building OFBiz docker image without preloaded data.
pushd ofbiz-framework
DOCKER_BUILDKIT=1 docker build --progress plain --tag ofbiz-docker .
popd
echo Built image ofbiz-docker.

echo Restarting exp1 docker-compose application with latest container images.
pushd exp1
docker compose down --volumes
docker compose up --detach
popd
echo Exp1 docker-compose application restarted.

echo Restarting exp2 docker-compose application with latest container images.
pushd exp2
docker compose down --volumes
docker compose up --detach
popd
echo Exp2 docker-compose application restarted.
