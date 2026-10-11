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

## Arsene Jupyter

`jupyter.idc.brownrook.com` is a CNAME to the dynamic site anchor. The existing
Route 53 workflow applies this alias on merge to main. Host Jupyter, Nginx,
TLS routing and the internal Unbound override are managed by the
`brownrook-infra` Ansible Jupyter playbook. The internal override resolves
the same hostname to proxy `192.168.2.210`; external DNS uses the public site
address. No credentials or notebook data are stored in this repository.
