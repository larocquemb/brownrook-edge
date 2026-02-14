#!/usr/bin/env bash
set -e

ZONE_ID="Z04891073LFEUB14MX3A6"
NAME="idc.brownrook.com."
TTL=60

IP=$(curl -s https://checkip.amazonaws.com | tr -d '\n')

aws route53 change-resource-record-sets \
  --hosted-zone-id "$ZONE_ID" \
  --change-batch "{
    \"Changes\": [{
      \"Action\": \"UPSERT\",
      \"ResourceRecordSet\": {
        \"Name\": \"$NAME\",
        \"Type\": \"A\",
        \"TTL\": $TTL,
        \"ResourceRecords\": [{\"Value\": \"$IP\"}]
      }
    }]
  }"

curl -fsS https://checkip.amazonaws.com
dig +short idc.brownrook.com @1.1.1.1
