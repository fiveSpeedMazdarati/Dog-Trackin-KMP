#!/usr/bin/env bash
# Prints the UDID of an available simulator for the given platform ("iOS" or "tvOS"),
# preferring the newest runtime. Used by CI so we don't hard-code device names that
# change with every Xcode release.
set -euo pipefail
platform="${1:-iOS}"
xcrun simctl list devices available -j | python3 -c '
import json, sys
platform = sys.argv[1]
family = "iPhone" if platform == "iOS" else "Apple TV"
data = json.load(sys.stdin)["devices"]
runtimes = sorted((r for r in data if f".{platform}-" in r), reverse=True)
for runtime in runtimes:
    for device in data[runtime]:
        if device["name"].startswith(family):
            print(device["udid"]); sys.exit(0)
sys.exit(f"No available {platform} simulator found")
' "$platform"
