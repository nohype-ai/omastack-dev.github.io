#!/bin/bash
# Public entry point. The installer lives in nohype-ai/OmaStack.
#
#   curl -fsSL https://omastack.dev/install.sh | bash
set -euo pipefail

REPO="${OMACK_REPO:-nohype-ai/OmaStack}"
REF="${OMACK_REF:-main}"
URL="${OMACK_INSTALL_URL:-https://raw.githubusercontent.com/${REPO}/${REF}/install.sh}"

curl -fsSL "$URL" | bash -s -- "$@"
