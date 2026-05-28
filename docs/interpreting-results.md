# Interpreting Results

## Single client near 940 Mbps

Normal for a 1G Ethernet client.

## Two clients total above 1G

Good sign. The server-side aggregate link is working for multiple flows/clients.

## Two clients total still around 1G

Possible causes:

- Bond/trunk not configured correctly
- Switch port-channel not configured correctly
- Traffic hash puts both flows on the same physical link
- Only one server NIC is actually active
- Cabling or negotiation issue
- Server/service bottleneck

## Important note about LACP hashing

A single TCP flow usually does not split across multiple physical links in a traditional LACP bond.

Aggregate gain usually appears when multiple clients or multiple flows exist.
