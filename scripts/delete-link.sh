#!/usr/bin/env bash

set -euo pipefail

if [ $# -ne 1 ]; then
  echo "Usage: $0 <id>"
  exit 1
fi

ID="$1"
LINKS_FILE="links.json"

if ! [ -f "$LINKS_FILE" ]; then
  echo "Error: $LINKS_FILE not found"
  exit 1
fi

if ! jq -e --arg id "$ID" 'has($id)' "$LINKS_FILE" > /dev/null; then
  echo "Warning: Link with id '$ID' does not exist. Nothing to delete."
  exit 0
fi

jq --arg id "$ID" 'del(.[$id])' "$LINKS_FILE" > "${LINKS_FILE}.tmp"

mv "${LINKS_FILE}.tmp" "$LINKS_FILE"

echo "Successfully deleted link: $ID"
