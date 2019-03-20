#! /usr/bin/env bash

set -e

NGINX_HTTP_CONF_FILE=$1
NGINX_CONF_DIR=`mktemp -d`

# Copy all /etc/nginx content, except for conf.d, to temporary location.
cp -rp `find /etc/nginx ! -path "/etc/nginx/conf.d*"` "$NGINX_CONF_DIR"
mkdir -p "$NGINX_CONF_DIR"/conf.d

# Modify 
sed -i "s@/etc/nginx@$NGINX_CONF_DIR@g" "$NGINX_CONF_DIR"/nginx.conf

cp -Tp "$NGINX_HTTP_CONF_FILE" "$NGINX_CONF_DIR"/conf.d/$(basename "$NGINX_HTTP_CONF_FILE").conf

set +e

nginx -t -c "$NGINX_CONF_DIR"/nginx.conf

RETCODE=$?

set -e

rm -rf "$NGINX_CONF_DIR"
exit $RETCODE
