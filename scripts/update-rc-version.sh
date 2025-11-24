#!/usr/bin/env bash

set -euo pipefail

latestRC=$(curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $GITHUB_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/freecad/freecad/branches/releases/FreeCAD-1-1 | jq -r '.commit.sha')

echo $latestRC

prefetchJson=$(nix-prefetch-github --json --fetch-submodules --rev $latestRC FreeCAD FreeCAD)

jq '{ rev: .rev, hash: .hash, version: "1.1" }' <<< "$prefetchJson" > packages/freecad_1-1/version.json
