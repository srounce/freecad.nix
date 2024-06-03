#!/usr/bin/env bash

set -euo pipefail

nix develop -c bash -c "$(printf " %q" "${@}")"
