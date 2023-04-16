![ ](https://img.shields.io/github/v/tag/agpsn/sabnzbd-develop?color=00CCFF&label=:develop&style=plastic&logo=%20) 
 

```
docker run -d \
  --name=sabnzbd \
  -e PUID=99 \
  -e PGID=100 \
  -e TZ=UTC \ #optional
  -e UMASK=022 \  #optional
  -p <hostport>:8080 \
  -v <hostconfigpath>:/config \
  -v <hostmediapath>:/data \ #optional
  --restart unless-stopped \  #optional
  ghcr.io/agpsn/docker-sabnzbd:develop
```
