#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

status=0
output=$(./replay examples/eventops/require-source.sql 2>&1) || status=$?
printf '%s\n' "$output"
[[ "$status" == 1 ]]
grep -Fq 'fresh PASS | existing registrations: 0' <<< "$output"
grep -Fq 'upgrade FAIL | existing registrations: 1 | migration' <<< "$output"
grep -Eq '23502:.*registration_source.*contains null values' <<< "$output"
