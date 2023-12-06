#!/bin/bash

# Run in android emulator
# Emulator must be running first

set -eux -o pipefail

godot --export-debug Android test.apk
adb install test.apk
