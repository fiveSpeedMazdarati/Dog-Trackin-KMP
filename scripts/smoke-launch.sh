#!/usr/bin/env bash
# Smoke test: install the built app on a simulator, launch it, check it's still
# running (didn't crash on launch), and take light + dark screenshots.
#
# Usage: smoke-launch.sh <path/to/DogTrackin.app> <bundle-id> <device-family> <out-dir>
#   device-family: name prefix, e.g. "iPhone" or "iPad"
set -euo pipefail
app="$1"; bundle_id="$2"; family="$3"; out="$4"
here="$(cd "$(dirname "$0")" && pwd)"
mkdir -p "$out"

sim=$("$here/pick-simulator.sh" iOS "$family")
name=$(xcrun simctl list devices -j | python3 -c '
import json, sys
for devices in json.load(sys.stdin)["devices"].values():
    for d in devices:
        if d["udid"] == sys.argv[1]: print(d["name"])
' "$sim")
slug=$(echo "$family" | tr '[:upper:]' '[:lower:]')
echo "Using $name ($sim)"

xcrun simctl boot "$sim" 2>/dev/null || true
xcrun simctl bootstatus "$sim" -b
xcrun simctl install "$sim" "$app"

for appearance in light dark; do
  xcrun simctl ui "$sim" appearance "$appearance"
  xcrun simctl launch --terminate-running-process "$sim" "$bundle_id"
  sleep 8   # let SwiftUI render the first screen
  if ! xcrun simctl spawn "$sim" launchctl list | grep -q "$bundle_id"; then
    echo "::error::$bundle_id is not running on $name ($appearance) — it probably crashed on launch."
    xcrun simctl spawn "$sim" log show --last 2m --style compact \
      --predicate "process == \"DogTrackin\"" | tail -n 80 || true
    exit 1
  fi
  xcrun simctl io "$sim" screenshot "$out/${slug}-${appearance}.png"
  echo "Saved $out/${slug}-${appearance}.png"
done

xcrun simctl shutdown "$sim" || true
