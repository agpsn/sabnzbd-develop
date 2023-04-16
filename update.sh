#!/bin/bash
clear
set -eu
echo $(cat ~/.ghcr-token) | docker login ghcr.io -u $(cat ~/.ghcr-user) --password-stdin &>/dev/null
BASE="/mnt/user/system/agpsn-github"


#LVERSION=$(curl -sL "https://lidarr.servarr.com/v1/update/develop/changes?runtime=netcore&os=linuxmusl" | jq -r '.[0].version')
#RVERSION=$(curl -sL "https://radarr.servarr.com/v1/update/develop/changes?runtime=netcore&os=linuxmusl" | jq -r '.[0].version')
#SVERSION=$(curl -sL https://services.sonarr.tv/v1/releases | jq -r "first(.[] | select(.branch==\"develop\") | .version)")
NVERSION=$(curl -sL "https://api.github.com/repos/sabnzbd/sabnzbd/releases/latest" | awk '/tag_name/{print $4;exit}' FS='[""]')

APP=sabnzbd
#PVERSION=$(curl -sL "https://prowlarr.servarr.com/v1/update/develop/changes?runtime=netcore&os=linuxmusl" | jq -r '.[0].version')

#if [ $GBRANCH != "develop" ]; then git checkout develop; fi
cd $BASE/sabnzbd-develop

echo "Building and Pushing 'ghcr.io/agpsn/docker-$APP:$NVERSION'"
docker build --quiet  --force-rm --rm --tag ghcr.io/agpsn/docker-$APP:develop --tag ghcr.io/agpsn/docker-$APP:$NVERSION -f ./Dockerfile.develop .
docker push --quiet ghcr.io/agpsn/docker-$APP:develop; docker push --quiet ghcr.io/agpsn/docker-$APP:$NVERSION && docker image rm -f ghcr.io/agpsn/docker-$APP:$NVERSION
git tag -f $NVERSION && git push origin $NVERSION -f --tags
#echo ""
git add . && git commit -m "Updated" && git push --quiet
