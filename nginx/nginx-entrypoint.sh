#!/bin/sh
set -e

# DOMAIN must be passed in as an env var
CERT_DIR="/etc/letsencrypt/live/${DOMAIN}"

echo "[$(date '+%Y-%m-%d %H:%M:%S')] [entrypoint] waiting for initial certificates in ${CERT_DIR}"
# 0) Block until certbot-init has dropped both files
while [ ! -f "${CERT_DIR}/fullchain.pem" ] || [ ! -f "${CERT_DIR}/privkey.pem" ]; do
  sleep 2
done

echo "[$(date '+%Y-%m-%d %H:%M:%S')] [entrypoint] certificates found, starting nginx…"

# 1) Launch nginx in the foreground
nginx -g 'daemon off;' &
NGINX_PID=$!

# 2) In the background, watch for renewals and reload on change
inotifywait -m -e close_write \
  "${CERT_DIR}/fullchain.pem" \
  "${CERT_DIR}/privkey.pem" |
while read -r _path _event file; do
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] [watcher] Detected new $file, reloading nginx"
  nginx -s reload
done &

# 3) Wait on the main nginx process
wait $NGINX_PID
