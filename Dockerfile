FROM nginx:1.19.2
WORKDIR /etc/nginx

# setup imaged
RUN \
mkdir -p /certs /sites /defaults && \
rm -f /etc/nginx/conf.d/default.conf

# copy scripts and set to executable in docker-entrypoint.d/
# nginx image will run scripts in this dir just before starting the nginx server
COPY weavc-nginx-setup.sh /docker-entrypoint.d/weavc-nginx-setup.sh
RUN chmod ugo+x /docker-entrypoint.d/weavc-nginx-setup.sh

# copy the defaults to image
COPY defaults/ /defaults/
COPY defaults/ /

# copy base configs to /etc/nginx
COPY *.conf ./

VOLUME /sites

