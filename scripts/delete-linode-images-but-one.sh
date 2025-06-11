#!/usr/bin/env bash

# **1) Configuration**
# Replace with your actual API token:
TOKEN=${LINODE_TOKEN}
API_URL="https://api.linode.com/v4"

# **2) Fetch & sort private images by creation date**
#    - `is_public==false` filters out Linode-supplied/public images
IMAGE_IDS=$(curl -s \
    -H "Authorization: Bearer $TOKEN" \
    "$API_URL/images?page_size=100" \
  | jq -r '
      .data
      | map(select(.is_public == false))
      | sort_by(.created)
      | .[].id
    ')

# :contentReference[oaicite:0]{index=0}

# **3) Identify the latest image**
LATEST_ID=$(echo "$IMAGE_IDS" | tail -n1)
echo "Keeping latest image: $LATEST_ID"

# **4) Loop over the others and delete them**
echo "$IMAGE_IDS" \
  | grep -v "^$LATEST_ID\$" \
  | while read -r IMG; do
      echo "Deleting image $IMG…"
      curl -s -X DELETE \
           -H "Authorization: Bearer $TOKEN" \
           "$API_URL/images/$IMG"
      echo " → deleted $IMG"
    done
# :contentReference[oaicite:1]{index=1}
