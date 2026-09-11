#!/bin/bash
# Install or replace ~/.local/bin/omack. Does not need a git checkout.
# Lists in ~/.config/omack/ are never overwritten.
#
#   curl -fsSL https://omastack.dev/install.sh | bash
set -euo pipefail

REPO="${OMACK_REPO:-nohype-ai/OmaStack}"
REF="${OMACK_REF:-main}"
URL="${OMACK_URL:-https://raw.githubusercontent.com/${REPO}/${REF}/omack}"
DEST="${HOME}/.local/bin/omack"
DIR="${XDG_CONFIG_HOME:-$HOME/.config}/omack"
HERE="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" 2>/dev/null && pwd || true)"

echo "OmaStack installer"
echo "  dest  $DEST"

src=""
if [[ -n "${HERE:-}" && -f "$HERE/omack" && -z "${OMACK_URL:-}" ]]; then
  src="$HERE/omack"
  echo "  from  $src (checkout)"
else
  echo "  from  $URL"
  src="$(mktemp)"
  trap 'rm -f "$src"' EXIT
  curl -fsSL "$URL" -o "$src"
  chmod 755 "$src"
fi

mkdir -p "$(dirname "$DEST")"
install -D -m 755 "$src" "$DEST"

if [[ ! -e "$DIR/wanted.txt" && ! -e "$DIR/unwanted.txt" ]]; then
  echo "  init  $DEST init"
  "$DEST" init
else
  echo "  keep  $DIR (lists unchanged)"
fi

echo "  ok    $($DEST version)"
