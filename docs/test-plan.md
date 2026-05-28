# Test Plan

## Goal

Determine whether the server-side bonded/trunked interface provides more than 1G aggregate throughput when multiple 1G clients send traffic at the same time.

## Basic steps

1. Confirm server bond/trunk state.
2. Start `iperf3 -s` on the server.
3. Run one client test to establish baseline.
4. Run two or more client tests at the same time.
5. Compare total throughput across all clients.
6. Record switch/interface counters if available.

## Success condition

If multiple 1G clients can simultaneously push traffic and the combined total exceeds roughly 940 Mbps, the server link is providing aggregate benefit.

## Failure/limited condition

If the combined total stays around one single 1G link, the bond/trunk may be:

- Misconfigured
- Not using LACP
- Hashing all test flows onto one physical link
- Limited by switch configuration
- Limited by client/server CPU/disk/network stack
