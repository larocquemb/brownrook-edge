#!/usr/bin/env bash
set -euo pipefail

HOSTED_ZONE_ID="Z04891073LFEUB14MX3A6"
SNAPSHOT_FILE="docs/snapshots/route53-change-batch-upsert.json"
AWS_PROFILE="default"

echo "=========================================="
echo " Route53 Rollback Script"
echo "=========================================="
echo "Hosted Zone: $HOSTED_ZONE_ID"
echo "Snapshot:    $SNAPSHOT_FILE"
echo "Profile:     $AWS_PROFILE"
echo "=========================================="

if [ ! -f "$SNAPSHOT_FILE" ]; then
  echo "ERROR: Snapshot file not found: $SNAPSHOT_FILE"
  exit 1
fi

echo "Applying DNS rollback..."
CHANGE_ID=$(
  aws route53 change-resource-record-sets \
    --hosted-zone-id "$HOSTED_ZONE_ID" \
    --change-batch "file://$SNAPSHOT_FILE" \
    --profile "$AWS_PROFILE" \
    --query 'ChangeInfo.Id' \
    --output text
)

echo "Rollback submitted. Change ID: $CHANGE_ID"
echo "Waiting for INSYNC..."

aws route53 wait resource-record-sets-changed \
  --id "$CHANGE_ID" \
  --profile "$AWS_PROFILE"

echo "INSYNC ✅"
echo ""
echo "Verify:"
echo "aws route53 list-resource-record-sets --hosted-zone-id $HOSTED_ZONE_ID --profile $AWS_PROFILE"
