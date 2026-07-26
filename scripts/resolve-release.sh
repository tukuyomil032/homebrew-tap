#!/usr/bin/env bash
set -euo pipefail

usage() {
  if [ "$#" -gt 0 ]; then
    printf 'error: %s\n' "$*" >&2
  fi
  cat >&2 <<'EOF'
usage: resolve-release.sh --repo <owner/name> --channel <stable|beta>
                         --asset-template <template>
EOF
  exit 1
}

repo=''
channel=''
asset_template=''
while [ "$#" -gt 0 ]; do
  case "$1" in
    --repo) [ "$#" -ge 2 ] || usage; repo="$2"; shift 2 ;;
    --channel) [ "$#" -ge 2 ] || usage; channel="$2"; shift 2 ;;
    --asset-template) [ "$#" -ge 2 ] || usage; asset_template="$2"; shift 2 ;;
    -h|--help) usage ;;
    *) usage "unknown argument: $1" ;;
  esac
done
[ -n "$repo" ] || usage '--repo is required'
[ -n "$channel" ] || usage '--channel is required'
[ -n "$asset_template" ] || usage '--asset-template is required'

exec nu "$(cd "$(dirname "$0")" && pwd)/resolve-release.nu" "$repo" "$channel" "$asset_template"
