#!/bin/sh
set -e

WEBROOT="/var/www/certbot"
# If STAGING is non-empty (e.g. "--staging"), include it here:
STAGING_FLAG=${STAGING}

while true; do
  echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] Running certbot renew ${STAGING_FLAG} --webroot -w ${WEBROOT} …"
  certbot renew ${STAGING_FLAG} \
    --webroot -w "$WEBROOT" \
    --quiet
  echo "[`date '+%Y-%m-%d %H:%M:%S'`] [INFO] Renewal check complete; sleeping 12 h…"
  sleep 43200
done
