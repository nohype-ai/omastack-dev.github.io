#!/bin/bash
# Install or replace ~/.local/bin/omack. Does not need a git checkout.
# ~/.config/omastack/config.toml is created if missing and is never overwritten.
# Package lists live in the stack folder, not in this config folder.
#
#   curl -fsSL https://omastack.dev/install.sh | bash
#
#   ./install.sh --dev
#     Install omack from the sibling ../OmaStack repo instead of GitHub.
set -euo pipefail

if [[ "${1:-}" == "--dev" ]]; then
  DEV=1
elif [[ -n "${1:-}" ]]; then
  echo "usage: install.sh [--dev]" >&2
  exit 1
else
  DEV=0
fi

REPO="${OMACK_REPO:-nohype-ai/OmaStack}"
REF="${OMACK_REF:-main}"
URL="${OMACK_URL:-https://raw.githubusercontent.com/${REPO}/${REF}/omack}"
DEST="${HOME}/.local/bin/omack"
DIR="${XDG_CONFIG_HOME:-$HOME/.config}/omastack"
HERE="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" 2>/dev/null && pwd || true)"

echo "OmaStack installer"
echo "  dest  $DEST"

src=""
if [[ "$DEV" -eq 1 ]]; then
  if [[ -z "${HERE:-}" ]]; then
    echo "error: --dev must be run as a file from the website repo" >&2
    exit 1
  fi
  src="$(cd "$HERE/../OmaStack" && pwd)/omack"
  if [[ ! -f "$src" ]]; then
    echo "error: missing $src" >&2
    exit 1
  fi
  echo "  from  $src (--dev)"
elif [[ -n "${HERE:-}" && -f "$HERE/omack" && -z "${OMACK_URL:-}" ]]; then
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

mkdir -p "$DIR"
if [[ ! -e "$DIR/config.toml" ]]; then
  printf '%s\n' '# omack writes stack_path here.' > "$DIR/config.toml"
  echo "  config $DIR/config.toml"
else
  echo "  keep  $DIR/config.toml"
fi

echo "  ok    $($DEST version)"
