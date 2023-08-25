#!/usr/bin/env bash

set -euo pipefail
cd "$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &>/dev/null && pwd )/../app"
love .
