#!/usr/bin/env bash

set -euo pipefail

latestWeekly=$(curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $GITHUB_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/freecad/freecad/git/refs/tags | jq -r '[.[].ref | select(match("weekly-"))] | sort | last | split("/") | last')

prefetchJson=$(nix-prefetch-github --json --fetch-submodules --rev $latestWeekly FreeCAD FreeCAD)

jq '{ rev: .rev, hash: .hash }' <<< "$prefetchJson" > packages/freecad/version.json
