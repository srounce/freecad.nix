#!/usr/bin/env bash

set -euo pipefail

prefetchJson=$(nix-prefetch-github --json --fetch-submodules FreeCAD FreeCAD)

jq '{ rev: .rev, hash: .hash }' <<< "$prefetchJson" > pkgs/freecad/version.json
