#!/usr/bin/env bash

set -euo pipefail
echo "$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &>/dev/null && pwd )/.."
source .venv/bin/activate
cd app
python server/server.py
