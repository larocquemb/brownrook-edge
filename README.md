# BrownRook Edge Infrastructure

## Sites
- idc = Île-des-Chênes (primary residence)

## DNS Anchors
- idc.brownrook.com (dynamic A record)

## Update Mechanism
Route53 UPSERT via cron on Proxmox

## Service aliases

Service CNAMEs are GitOps-managed independently of the dynamic anchor. Pull
requests validate `infra/route53/idc-service-cnames.json`; merges to `main`
apply the batch and wait for Route 53 to report `INSYNC`.

The workflow reads the existing Route 53 identity through these GitHub Actions
repository secrets:

- `AWS_ROUTE53_ACCESS_KEY_ID`
- `AWS_ROUTE53_SECRET_ACCESS_KEY`

For an explicitly requested manual recovery, apply the same reviewed batch
from a trusted workstation:

```sh
aws route53 change-resource-record-sets \
  --hosted-zone-id Z04891073LFEUB14MX3A6 \
  --change-batch file://infra/route53/idc-service-cnames.json
```

`telemetry.idc.brownrook.com` follows the same public alias pattern as Argo CD
and resolves through `idc.brownrook.com` to the current dynamic site address.

The workflow deliberately does not manage the dynamic `idc.brownrook.com` A
record; Proxmox continues updating that record when the site's public IP
changes.
