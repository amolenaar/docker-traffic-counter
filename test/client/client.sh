#!/bin/sh
set -e

echo "Will query URL $URL"

while true;
do
  sleep 1
  curl -H 'Host: otherservice.local' "$URL" >/dev/null
done
