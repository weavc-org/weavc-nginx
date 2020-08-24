### weavc-nginx

A helpful wrapper around the nginx docker container. Helps with creating reverse proxies to other containers and enforcing SSL connections. It is based off of [`linuxserver/docker-swag`](https://github.com/linuxserver/docker-swag), but aims to provide a lighterweight alternative that can be used more effectively as a docker service.

#### Usage

##### Quickstart:
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
