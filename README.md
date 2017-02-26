# Docker Traffic Counter

docker run -ti -v /var/run/docker.sock:/var/run/docker.sock --net=host -p 9100:9100 

**TODO: Add description**

    docker ps -q | xargs docker inspect --format '{{ .Id }} {{ .Config.Image }} {{ .NetworkSettings.IPAddress }}'
