#!/bin/bash
set -eu

NVERSION=$(curl -sL "https://api.github.com/repos/sabnzbd/sabnzbd/releases/latest" | awk '/tag_name/{print $4;exit}' FS='[""]')

echo $(cat ../.token) | docker login ghcr.io -u $(cat ../.user) --password-stdin &>/dev/null

echo "Updating Sabnzbd: v$NVERSION"
docker build --force-rm --rm --tag ghcr.io/agpsn/docker-sabnzbd:develop --tag ghcr.io/agpsn/docker-sabnzbd:$NVERSION -f ./Dockerfile.develop .
git tag -f $NVERSION && git push --quiet origin $NVERSION -f --tags
git add . && git commit -m "Updated" && git push --quiet
docker push --quiet ghcr.io/agpsn/docker-sabnzbd:develop; docker push --quiet ghcr.io/agpsn/docker-sabnzbd:$NVERSION && docker image rm -f ghcr.io/agpsn/docker-sabnzbd:$NVERSION
echo ""
