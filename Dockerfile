# Base image to start the build process
FROM debian:buster

# Adds metadata to image
LABEL maintainer="ducnguyen96"

#################################################
## Building NGINX from srouce & Adding modules ##
#################################################

# Update apt-get
RUN apt-get update -y
RUN apt-get upgrade -y
RUN apt-get install wget -y

# Download building tools
RUN apt-get install build-essential libpcre3 \
  libpcre3-dev zlib1g zlib1g-dev libssl-dev -y

RUN mkdir /home/nginx
WORKDIR /home/nginx

# Download nginx
RUN wget http://nginx.org/download/nginx-1.21.0.tar.gz
RUN tar -zxvf nginx-1.21.0.tar.gz

# Configure Nginx

WORKDIR /home/nginx/nginx-1.21.0

RUN sh configure --sbin-path=/usr/bin/nginx \
  --conf-path=/etc/nginx/nginx.conf \
  --error-log-path=/var/log/nginx/error.log \
  --http-log-path=/var/log/nginx/access.log \
  --with-pcre --pid-path=/var/run/nginx.pid \
  --with-http_ssl_module \
  --modules-path=/etc/nginx/modules --with-http_v2_module

# Compile nginx
RUN make

# Install nginx
RUN make install

# Remove nginx source
WORKDIR /home
RUN rm -rf nginx

# Testing nginx
RUN nginx -V