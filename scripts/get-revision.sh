#!/usr/bin/env bash

set -euo pipefail

rev="$(jq -r '.rev' pkgs/freecad/version.json)"

echo "${rev:0:7}"
