## weavc-nginx

[![Docker](https://img.shields.io/badge/docker-releases-blue?logo=docker)](https://github.com/weavc/weavc-nginx/packages?ecosystem=docker)

A helpful wrapper around the nginx docker container for with creating reverse proxies to other containers and enforcing SSL connections. It is based off of [`linuxserver/docker-swag`](https://github.com/linuxserver/docker-swag), but aims to provide a slightly more stateless alternative that can be used more effectively as a docker service with replicas.

### Configuration

The configuration for the container should be handled via the following mount points:

- `/sites` directory containing nginx configuration, including reverse proxies and also the default website at default.conf. See `defaults/sites/` for examples
- `/run/secrets/fullchain.pem` for fullchain certificate file
- `/run/secrets/privkey.pem` for the matching private key file
- `/run/secrets/dhparams.pem` for dhparams file

A default `dhparams.pem` file is supplied and you can generate new ssl certificates using `SSL_GENERATE=yes` environment variable at runtime, but this is only recommended in a local dev environment.

The contents of the `defaults/` directory is copied into the root directory of the container at runtime, so if you are building the image yourself files added in there will be pulled through and used by the container if no other file is supplied.

When using this as a docker service, configuration should be handled via docker secrets and docker config, this makes the container stateless while also not having to build it for one specific usage case.

### Usage

Standalone:
```
docker run \
    -d -it \
    -v <path-to-certs>/fullchain.pem:/run/secrets/fullchain.pem \
    -v <path-to-certs>/privkey.pem:/run/secrets/privkey.pem \
    -v <path-to-site-defs>:/sites \
    -p 80:80 \
    -p 443:443 \
    --name weavc-nginx \
    --network=<network> \
    ghcr.io/weavc/weavc-nginx:latest
```

Service:
```
docker secret create fullchain.pem <path/to/fullchain.pem>
docker secret create privkey.pem <path/to/privkey.pem>
docker secret create dhparam.pem <path/to/dhparam.pem>
docker config create default.conf <path/to/default.conf>

docker service create \
    --secret fullchain.pem \
    --secret privkey.pem \
    --secret dhparam.pem \
    --config source=default.conf,target=/sites/default.conf \
    --publish 80:80 \
    --publish 443:443 \
    --replicas 3 \
    --name weavc-nginx \
    --network=<network> \
    ghcr.io/weavc/weavc-nginx:latest
```

Compose:
```
services:

  weavc-nginx:
    image: ghcr.io/weavc/weavc-nginx:latest
    ports:
      - "80:80"
      - "443:443"
    deploy:
      mode: replicated
      replicas: 3
    networks: 
      - frontend
    configs:
      - source: default.conf
        target: /sites/default.conf
      - source: logger.subdomain.conf
        target: /sites/logger.subdomain.conf
    secrets:
      - fullchain.pem
      - privkey.pem
      - dhparam.pem

...

configs:
  default.conf:
    file: ./configs/sites/default.conf
  logger.subdomain.conf:
    file: ./configs/sites/logger.subdomain.conf

secrets:
  fullchain.pem:
    file: ./secrets/fullchain.pem
  privkey.pem:
    file: ./secrets/privkey.pem
  dhparam.pem:
    file: ./secrets/dhparam.pem
```