#!/usr/bin/env bash
set -euo pipefail

# BCBC Network Aggregate Test
# Edit these values for your own lab.
KEY="${KEY:-$HOME/.ssh/id_ed25519}"
USER_NAME="${USER_NAME:-your_user}"
SERVER_A="${SERVER_A:-192.168.10.10}"
CLIENT_A="${CLIENT_A:-192.168.10.20}"
CLIENT_B="${CLIENT_B:-192.168.10.30}"

DURATION="${DURATION:-30}"
START_DELAY="${START_DELAY:-45}"

STAMP="$(date +%Y%m%d-%H%M%S)"
OUTDIR="${OUTDIR:-$HOME/bcbc-net-tests/$STAMP}"
mkdir -p "$OUTDIR"

START_EPOCH=$(( $(date +%s) + START_DELAY ))

echo "BCBC Network Aggregate Test"
echo "Output: $OUTDIR"
echo "Scheduled start epoch: $START_EPOCH"
echo

SSH=(ssh -i "$KEY")

echo "[1/6] Checking clocks..."
"${SSH[@]}" "$USER_NAME@$CLIENT_A" "date -Is; timedatectl show -p NTPSynchronized --value 2>/dev/null || true"
"${SSH[@]}" "$USER_NAME@$CLIENT_B" "date -Is; timedatectl show -p NTPSynchronized --value 2>/dev/null || true"
"${SSH[@]}" "$USER_NAME@$SERVER_A" "date -Is; timedatectl show -p NTPSynchronized --value 2>/dev/null || true"

echo
echo "[2/6] Starting iperf3 servers on SERVER_A..."
"${SSH[@]}" "$USER_NAME@$SERVER_A" "pkill iperf3 2>/dev/null || true; nohup iperf3 -s -p 5201 >/tmp/iperf3-5201.log 2>&1 & nohup iperf3 -s -p 5202 >/tmp/iperf3-5202.log 2>&1 & echo SERVER_A iperf3 servers started"
sleep 3

echo "[3/6] Arming CLIENT_A test on port 5201..."
"${SSH[@]}" "$USER_NAME@$CLIENT_A" "
  NOW=\$(date +%s)
  WAIT=\$(( $START_EPOCH - NOW ))
  [ \$WAIT -lt 0 ] && WAIT=0
  echo CLIENT_A waiting \$WAIT seconds
  sleep \$WAIT
  iperf3 -c $SERVER_A -p 5201 -t $DURATION
" > "$OUTDIR/client-a-to-server-a.log" 2>&1 &
PID_A=$!

echo "[4/6] Arming CLIENT_B test on port 5202..."
"${SSH[@]}" "$USER_NAME@$CLIENT_B" "
  NOW=\$(date +%s)
  WAIT=\$(( $START_EPOCH - NOW ))
  [ \$WAIT -lt 0 ] && WAIT=0
  echo CLIENT_B waiting \$WAIT seconds
  sleep \$WAIT
  iperf3 -c $SERVER_A -p 5202 -t $DURATION
" > "$OUTDIR/client-b-to-server-a.log" 2>&1 &
PID_B=$!

echo "[5/6] Waiting for scheduled tests..."
wait "$PID_A" || true
wait "$PID_B" || true

echo "[6/6] Stopping iperf3 servers on SERVER_A..."
"${SSH[@]}" "$USER_NAME@$SERVER_A" "pkill iperf3 2>/dev/null || true"

echo
echo "===== CLIENT_A summary ====="
grep -E "waiting|sender|receiver|error|failed|refused" "$OUTDIR/client-a-to-server-a.log" | tail -10 || cat "$OUTDIR/client-a-to-server-a.log"

echo
echo "===== CLIENT_B summary ====="
grep -E "waiting|sender|receiver|error|failed|refused" "$OUTDIR/client-b-to-server-a.log" | tail -10 || cat "$OUTDIR/client-b-to-server-a.log"

echo
echo "Logs saved in:"
echo "$OUTDIR"
