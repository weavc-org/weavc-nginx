FROM nginx:1.19.2

WORKDIR /etc/nginx

# generate dhparam
# helps protects requests if someone was to get ahold of the private key
# by adding another layer of encryption
RUN openssl dhparam -out dhparam.pem 2048

# setup imaged
RUN \
mkdir -p /certs /sites /defaults && \
rm -f /etc/nginx/conf.d/default.conf

# copy scripts and set to executable in docker-entrypoint.d
# nginx image will run scripts in this dir just before starting the nginx server
COPY weavc-nginx-setup.sh /docker-entrypoint.d/weavc-nginx-setup.sh
RUN chmod ugo+x /docker-entrypoint.d/weavc-nginx-setup.sh

# copy over defaults
COPY defaults/* /defaults/

# copy base configs to /etc/nginx
COPY *.conf ./

VOLUME /sites

