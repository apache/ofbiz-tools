#!/usr/bin/env bash
# Script to pull and redeploy OFBiz container images to docker-compose applications.

set -x
set -e

cd /home/ofbizdocker

for appDir in demo-stable demo-trunk demo-next exp1 exp2 exp3; do
    echo "Restarting $appDir docker-compose application with latest container images."
    pushd "$appDir"
    docker compose pull
    docker compose down --volumes
    docker compose up --detach
    popd
    echo "$appDir docker-compose application restarted."
done
