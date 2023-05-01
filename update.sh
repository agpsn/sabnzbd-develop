#!/bin/bash
set -eu

[ ! -d "/mnt/user/system/agpsn-github/sabnzbd-develop" ] && echo "No repo!" && exit 1
cd "/mnt/user/system/agpsn-github/sabnzbd-develop"

echo $(cat ~/.ghcr-token) | docker login ghcr.io -u $(cat ~/.ghcr-user) --password-stdin &>/dev/null

NVERSION=$(curl -sL "https://api.github.com/repos/sabnzbd/sabnzbd/releases/latest" | awk '/tag_name/{print $4;exit}' FS='[""]')

echo "Building and Pushing 'ghcr.io/agpsn/docker-sabnzbd:$NVERSION'"
docker build --quiet  --force-rm --rm --tag ghcr.io/agpsn/docker-sabnzbd:develop --tag ghcr.io/agpsn/docker-sabnzbd:$NVERSION -f ./Dockerfile.develop .
docker push --quiet ghcr.io/agpsn/docker-sabnzbd:develop; docker push --quiet ghcr.io/agpsn/docker-sabnzbd:$NVERSION && docker image rm -f ghcr.io/agpsn/docker-sabnzbd:$NVERSION
git tag -f $NVERSION && git push --quiet origin $NVERSION -f --tags
git add . && git commit -m "Updated" && git push --quiet
echo ""
