#!/usr/bin/env bash
set -euo pipefail

# BCBC Network Aggregate Test
#
# Purpose:
#   Run an iperf3 test from this client to a target server and write a timestamped log.
#
# Usage:
#   ./scripts/bcbc-aggregate-trunk-test.sh SERVER_IP_OR_NAME [parallel_streams] [seconds]
#
# Example:
#   ./scripts/bcbc-aggregate-trunk-test.sh 192.168.0.225 4 30
#
# Run this script at roughly the same time from multiple clients to test aggregate throughput.

SERVER="${1:-}"
PARALLEL="${2:-4}"
SECONDS="${3:-30}"

if [[ -z "$SERVER" ]]; then
  echo "Usage: $0 SERVER_IP_OR_NAME [parallel_streams] [seconds]"
  exit 1
fi

if ! command -v iperf3 >/dev/null 2>&1; then
  echo "iperf3 is required. Install with: sudo apt install -y iperf3"
  exit 1
fi

HOST="$(hostname)"
STAMP="$(date +%Y-%m-%d-%H%M%S)"
OUTDIR="results/${STAMP}-${HOST}-to-${SERVER}"
mkdir -p "$OUTDIR"

{
  echo "BCBC Network Aggregate Test"
  echo "Timestamp: $STAMP"
  echo "Client: $HOST"
  echo "Server: $SERVER"
  echo "Parallel streams: $PARALLEL"
  echo "Duration seconds: $SECONDS"
  echo
  echo "Client identity:"
  hostnamectl || true
  echo
  echo "Client network:"
  ip -br addr || true
  echo
  echo "Route to server:"
  ip route get "$SERVER" || true
  echo
  echo "iperf3 output:"
  iperf3 -c "$SERVER" -P "$PARALLEL" -t "$SECONDS"
} | tee "$OUTDIR/iperf3-${HOST}-to-${SERVER}.log"

echo
echo "Saved result:"
echo "$OUTDIR/iperf3-${HOST}-to-${SERVER}.log"
