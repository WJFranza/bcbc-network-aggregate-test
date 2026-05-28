# BCBC Network Aggregate Test

A small Linux network test project for checking whether a bonded/trunked server link improves aggregate throughput when multiple 1G clients send traffic at the same time.

## Purpose

This test helps answer:

> Does a bonded/LACP/trunked server connection provide more than 1G aggregate throughput, or is it only acting as redundancy/failover?

## Generic test layout

```text
CONTROL_HOST
├── CLIENT_A  ──┐
├── CLIENT_B  ──┤──> SERVER_A bonded/trunked interface
└── CLIENT_C  ──┘
```

The goal is not just to prove one client can hit 1G. The goal is to prove whether multiple clients can push more than 1G aggregate traffic into the server at the same time.

## What this repo includes

- A basic `iperf3`-based aggregate test runner
- A simple results directory structure
- Notes for sanitizing hostnames/IPs before publishing
- Example result format
- A repo-ready README and docs structure

## Required packages

On Debian/Ubuntu systems:

```bash
sudo apt update
sudo apt install -y iperf3
```

## Quick test

On the server:

```bash
iperf3 -s
```

On a client:

```bash
iperf3 -c SERVER_IP -P 4 -t 30
```

For aggregate testing, run simultaneous tests from multiple clients to the same server.

## Repo layout

```text
bcbc-network-aggregate-test/
  README.md
  LICENSE
  CHANGELOG.md
  scripts/
    bcbc-aggregate-trunk-test.sh
  docs/
    test-plan.md
    topology.md
    interpreting-results.md
    sanitizing-results.md
  examples/
    sample-results.md
  results/
    .gitkeep
  sanitized/
    .gitkeep
  logs/
    .gitkeep
  tools/
    package-results.sh
```

## Credits

Ideas, design, and concepts: William J. Franza, assisted by ChatGPT.

BCBC / AI-related project work: Mikey_LikesIT and ChatGPT.
