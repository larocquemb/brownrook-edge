# DNS Naming Conventions (BrownRook)

## Namespace layers

- `brownrook.com` / `www.brownrook.com`: Public HA web presence (CloudFront/S3)
- `idc.brownrook.com`: Site anchor (single dynamic A record)
- `*.idc.brownrook.com`: Site services (can be offline)

## Service prefixes

- `vpn.*`  : ingress for remote access (VPN endpoint)
- `web.*`  : HTTP(S) services (reverse-proxied)
- `admin.*`: administration interfaces; intended to be reachable only via VPN

## Exposure intent

Hostnames should make exposure obvious:
- Public web: `www.brownrook.com`
- Site-bound services: `*.idc.brownrook.com`
- Admin surfaces: `admin.*` (VPN-only)
