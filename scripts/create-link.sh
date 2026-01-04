#!/usr/bin/env bash

set -euo pipefail

if [ $# -ne 2 ]; then
  echo "Usage: $0 <id> <url>"
  exit 1
fi

ID="$1"
URL="$2"
LINKS_FILE="links.json"

if ! [ -f "$LINKS_FILE" ]; then
  echo "Error: $LINKS_FILE not found"
  exit 1
fi

if jq -e --arg id "$ID" 'has($id)' "$LINKS_FILE" > /dev/null; then
  echo "Link with id '$ID' already exists. Skipping."
  exit 0
fi

jq --arg id "$ID" --arg url "$URL" \
  '. + {($id): $url}' "$LINKS_FILE" > "${LINKS_FILE}.tmp"

mv "${LINKS_FILE}.tmp" "$LINKS_FILE"

echo "Successfully added link: $ID -> $URL"
