# BCBC Network Aggregate Test

A small Linux network test project for checking whether a bonded/trunked server link improves aggregate throughput when multiple 1G clients send traffic at the same time.

## Purpose

This test helps answer:

> Does a bonded/LACP/trunked server connection provide more than 1G aggregate throughput, or is it only acting as redundancy/failover?

## Generic Test Layout

```text
CONTROL_HOST
├── CLIENT_A  ──┐
├── CLIENT_B  ──┤──> SERVER_A bonded/trunked interface
└── runs scheduler/log collector


## Infrastructure Support

Special thank you to **ClouDNS** for supporting reliable DNS infrastructure for BCBC projects.


<img width="96" height="48" alt="cloudns-logo-crop" src="https://github.com/user-attachments/assets/3d379a71-292a-4dec-9703-635c809c22e5" />

---
