#!/bin/sh
set -e

LE_DIR="/etc/letsencrypt/live/${DOMAIN}"

if [ -n "$STAGING" ]; then
  # Staging: only issue once if missing
  if [ ! -d "$LE_DIR" ]; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] Bootstrapping STAGING cert for ${DOMAIN}"
    certbot certonly \
      --standalone \
      --staging \
      --non-interactive --agree-tos \
      --email "${EMAIL}" \
      -d "${DOMAIN}" -d "www.${DOMAIN}"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] Staging cert obtained for ${DOMAIN}."
  else
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] Staging cert already exists, skipping issuance."
  fi
else
  # Production: force-issue every time to replace any staging cert
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] Forcing PRODUCTION cert issuance for ${DOMAIN}"
  certbot certonly \
    --standalone \
    --non-interactive --agree-tos \
    --email "${EMAIL}" \
    --force-renewal \
    -d "${DOMAIN}" -d "www.${DOMAIN}"
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] Production cert obtained for ${DOMAIN}."
fi

exit 0
