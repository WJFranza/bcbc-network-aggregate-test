#!/usr/bin/env bash
set -euo pipefail

STAMP="$(date +%Y-%m-%d-%H%M%S)"
OUT="dist"
NAME="bcbc-network-aggregate-test-results-${STAMP}.zip"

mkdir -p "$OUT"
zip -r "$OUT/$NAME" results sanitized docs examples README.md CHANGELOG.md   -x "dist/*"   -x ".git/*"

echo "Created: $OUT/$NAME"
