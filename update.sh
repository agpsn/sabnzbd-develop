#!/bin/bash
clear
set -eu
echo $(cat ~/.ghcr-token) | docker login ghcr.io -u $(cat ~/.ghcr-user) --password-stdin &>/dev/null
BASE="/mnt/user/system/agpsn-github"


LVERSION=$(curl -sL "https://lidarr.servarr.com/v1/update/develop/changes?runtime=netcore&os=linuxmusl" | jq -r '.[0].version')
RVERSION=$(curl -sL "https://radarr.servarr.com/v1/update/develop/changes?runtime=netcore&os=linuxmusl" | jq -r '.[0].version')
SVERSION=$(curl -sL https://services.sonarr.tv/v1/releases | jq -r "first(.[] | select(.branch==\"develop\") | .version)")
NVERSION=$(curl -sL "https://api.github.com/repos/sabnzbd/sabnzbd/releases/latest" | awk '/tag_name/{print $4;exit}' FS='[""]')

#CHECKS
	[ ! -d "$BASE/lidarr-develop/.git" ] && echo "Lidarr Repo Missing!" && exit 1
	LBRANCH=$(cd "$BASE/lidarr-develop" && git branch | grep "*" | rev | cut -f1 -d" " | rev)
	[ $LBRANCH != "develop" ] && echo "Lidarr wrong branch!" && exit 1

	[ ! -d "$BASE/radarr-develop/.git" ] && echo "Radarr Repo Missing!" && exit 1
	PBRANCH=$(cd "$BASE/radarr-develop" && git branch | grep "*" | rev | cut -f1 -d" " | rev)
	[ $PBRANCH != "develop" ] && echo "Radarr wrong branch!" && exit 1

	[ ! -d "$BASE/sonarr-develop/.git" ] && echo "Sonarr Repo Missing!" && exit 1
	PBRANCH=$(cd "$BASE/sonarr-develop" && git branch | grep "*" | rev | cut -f1 -d" " | rev)
	[ $PBRANCH != "develop" ] && echo "Sonarr wrong branch!" && exit 1

	[ ! -d "$BASE/prowlarr-develop/.git" ] && echo "Prowlarr Repo Missing!" && exit 1
	PBRANCH=$(cd "$BASE/prowlarr-develop" && git branch | grep "*" | rev | cut -f1 -d" " | rev)
	[ $PBRANCH != "develop" ] && echo "Prowlarr wrong branch!" && exit 1

	[ ! -d "$BASE/sabnzbd-develop/.git" ] && echo "Sabnzbd Repo Missing!" && exit 1
	PBRANCH=$(cd "$BASE/sabnzbdw-develop" && git branch | grep "*" | rev | cut -f1 -d" " | rev)
	[ $PBRANCH != "develop" ] && echo "Sabnzbd wrong branch!" && exit 1


echo "LVERSION: "$LVERSION
echo "RVERSION: "$RVERSION
echo "SVERSION: "$SVERSION
echo "PVERSION: "$PVERSION
echo "NVERSION: "$NVERSION
echo ""
echo "LBRANCH: "$LBRANCH
echo "RBRANCH: "$RBRANCH
echo "SBRANCH: "$SBRANCH
echo "PBRANCH: "$PBRANCH
echo "NBRANCH: "$NBRANCH


#APP=prowlarr
#PVERSION=$(curl -sL "https://prowlarr.servarr.com/v1/update/develop/changes?runtime=netcore&os=linuxmusl" | jq -r '.[0].version')

#if [ $GBRANCH != "develop" ]; then git checkout develop; fi
#echo "Building and Pushing 'ghcr.io/agpsn/docker-$APP:$PVERSION'"
#docker build --quiet  --force-rm --rm --tag ghcr.io/agpsn/docker-$APP:develop --tag ghcr.io/agpsn/docker-$APP:$PVERSION -f ./Dockerfile.develop .
#docker push --quiet ghcr.io/agpsn/docker-$APP:develop; docker push --quiet ghcr.io/agpsn/docker-orowlarr:$PVERSION && docker image rm -f ghcr.io/agpsn/docker-$APP:$PVERSION
#git tag -f $PVERSION && git push origin $PVERSION -f --tags
#echo ""
#git add . && git commit -m "Updated" && git push --quiet
