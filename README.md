## weavc-nginx

[![Docker](https://img.shields.io/badge/docker-releases-blue?logo=docker)](https://github.com/weavc/weavc-nginx/packages?ecosystem=docker)

A helpful wrapper around the nginx docker container. Helps with creating reverse proxies to other containers and enforcing SSL connections. It is based off of [`linuxserver/docker-swag`](https://github.com/linuxserver/docker-swag), but aims to provide a lighterweight alternative that can be used more effectively as a docker service with replicas.

### Usage

All of the config is done by a variety of different volumes, allowing a user to pass through certificates and site/proxy configurations. By default the container will generate a self-signed certificate which can be useful in dev environments, but you can also provide the container with a pre-generated certificate by creating bind mounts to `/certs/fullchain.pem` and `/certs/privkey.pem`, perhaps created by `certbot` or another source. 

```
docker create \
    -v /etc/letsencrypt/live/weav.ovh/fullchain.pem:/certs/fullchain.pem \
    -v /etc/letsencrypt/live/weav.ovh/privkey.pem:/certs/privkey.pem \
    ...
    docker.pkg.github.com/weavc/weavc-nginx/weavc-nginx:latest
```

The container will also generate a `default.conf` file in `/sites` which will serve the site at `/usr/share/nginx/html` but this can be altered to a reverse proxy to another container, or a volume can be mounted to `/usr/share/nginx/html` to serve your own site. Alongside the `default.conf` file a sample proxy file will also be generated to show how to create a reverse proxy to another container. Create a volume or bind mount to setup your own configurations and proxies!

```
docker create \
    -v /mnt/volumes/weavc-nginx/sites:/sites \
    ...
    docker.pkg.github.com/weavc/weavc-nginx/weavc-nginx:latest
```

### Quickstart

Standalone:
```
docker run \
    -d -it \
    -v <path-to-certs>/fullchain.pem:/certs/fullchain.pem \
    -v <path-to-certs>/privkey.pem:/certs/privkey.pem \
    -v <path-to-site-defs>:/sites \
    -p 80:80 \
    -p 443:443 \
    --name weavc-nginx \
    --network=<network> \
    docker.pkg.github.com/weavc/weavc-nginx/weavc-nginx:latest
```

Service:
```
docker service create \
    --mount type=bind,src=<path-to-certs>/fullchain.pem,dst=/certs/fullchain.pem,ro \
    --mount type=bind,src=<path-to-certs>/privkey.pem,dst=/certs/privkey.pem,ro \
    --mount type=bind,src=<path-to-site-defs>,dst=/sites \
    --publish 80:80 \
    --publish 443:443 \
    --replicas 3 \
    --name weavc-nginx \
    --network=<network> \
    docker.pkg.github.com/weavc/weavc-nginx/weavc-nginx:latest
```

