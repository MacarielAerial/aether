#!/bin/bash

MANIFEST_FILE="${1:-packer/manifest.json}"

if [ ! -f "$MANIFEST_FILE" ]; then
    echo '{"error": "Manifest file not found"}' >&2
    exit 1
fi

ARTIFACT_ID=$(jq -r '.builds[-1].artifact_id' "$MANIFEST_FILE")

if [ -z "$ARTIFACT_ID" ] || [ "$ARTIFACT_ID" == "null" ]; then
    echo '{"error": "No artifact ID found in manifest"}' >&2
    exit 1
fi

echo "{\"artifact_id\": \"$ARTIFACT_ID\"}"
