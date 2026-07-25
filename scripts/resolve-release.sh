#!/usr/bin/env bash
#
# Resolve which GitHub release a cask channel should track.
#
# stdout: machine-readable `key=value` lines, safe to append to $GITHUB_OUTPUT.
#         Always includes `skip`; on skip it adds `skip_reason`, otherwise
#         `tag`, `version`, `asset_name` and `asset_url`.
# stderr: human-readable progress log.
#
# Exit status: 0 when a release was resolved AND when the channel is
# legitimately empty (skip), so a repository without a stable release does not
# fail the calling workflow. 1 on usage errors, unexpected HTTP statuses and
# unparseable responses.
#
# Set GH_API_BASE to point at a different API host (used by the bats tests).

set -euo pipefail

GH_API_BASE="${GH_API_BASE:-https://api.github.com}"

log() { printf '%s\n' "$*" >&2; }
emit() { printf '%s=%s\n' "$1" "$2"; }

die() {
  log "error: $*"
  exit 1
}

skip() {
  emit skip true
  emit skip_reason "$1"
  log "SKIP: $1"
  exit 0
}

usage() {
  if [ $# -gt 0 ]; then
    log "error: $*"
  fi
  cat >&2 <<'EOS'
usage: resolve-release.sh --repo <owner/name> --channel <stable|beta>
                         --asset-template <template>

  --channel stable   track the latest release that is not a pre-release
  --channel beta     track the newest release, pre-releases included

The asset template names the release asset to look for. Every occurrence of
{version} expands to the tag name without its leading "v", so the template
'perch-{version}.dmg' resolves tag v1.2.3 to perch-1.2.3.dmg.
EOS
  exit 1
}

repo=''
channel=''
asset_template=''

while [ $# -gt 0 ]; do
  case "$1" in
    --repo)
      [ $# -ge 2 ] || usage
      repo="$2"
      shift 2
      ;;
    --channel)
      [ $# -ge 2 ] || usage
      channel="$2"
      shift 2
      ;;
    --asset-template)
      [ $# -ge 2 ] || usage
      asset_template="$2"
      shift 2
      ;;
    -h | --help)
      usage
      ;;
    *)
      usage "unknown argument: $1"
      ;;
  esac
done

[ -n "$repo" ] || usage '--repo is required'
[ -n "$channel" ] || usage '--channel is required'
[ -n "$asset_template" ] || usage '--asset-template is required'

tmp_dir=$(mktemp -d)
trap 'rm -rf "$tmp_dir"' EXIT

http_status=''
http_body=''

# Fetch a path from the GitHub API into $http_status and $http_body.
#
# curl -f is deliberately not used: a 404 is a meaningful answer here rather
# than a transport failure, and -f would abort the whole script through
# `set -e` before the status could be inspected.
api_get() {
  local path="$1" body_file="${tmp_dir}/response.json"
  local -a args=(
    --silent --show-error --location
    -H 'Accept: application/vnd.github+json'
    -H 'X-GitHub-Api-Version: 2022-11-28'
  )

  if [ -n "${GITHUB_TOKEN:-}" ]; then
    args+=(-H "Authorization: Bearer ${GITHUB_TOKEN}")
  fi

  : >"$body_file"
  if ! http_status=$(curl "${args[@]}" -o "$body_file" -w '%{http_code}' "${GH_API_BASE}${path}"); then
    http_status='000'
  fi
  http_body=$(<"$body_file")
}

release=''

case "$channel" in
  stable)
    log "Looking up the latest stable release of ${repo}..."
    api_get "/repos/${repo}/releases/latest"
    case "$http_status" in
      200)
        release="$http_body"
        ;;
      404)
        # /releases/latest excludes pre-releases, so a 404 means the repository
        # has only ever published pre-releases, or nothing at all.
        skip "no stable release published for ${repo}"
        ;;
      *)
        die "GET /repos/${repo}/releases/latest returned HTTP ${http_status}"
        ;;
    esac
    ;;
  beta)
    log "Looking up the newest release of ${repo}, pre-releases included..."
    api_get "/repos/${repo}/releases?per_page=100"
    [ "$http_status" = 200 ] ||
      die "GET /repos/${repo}/releases returned HTTP ${http_status}"
    # Drafts are unpublished and carry no downloadable assets; pre-releases are
    # exactly what this channel exists for. The API happens to answer in
    # descending order, but that is not documented, so sort explicitly.
    release=$(jq -c '
      [.[] | select(.draft != true)]
      | sort_by(.published_at // .created_at)
      | reverse
      | .[0] // empty' <<<"$http_body") ||
      die "failed to parse the release list of ${repo}"
    [ -n "$release" ] || skip "no published release found for ${repo}"
    ;;
  *)
    usage "unknown channel: ${channel}"
    ;;
esac

tag=$(jq -r '.tag_name // ""' <<<"$release") ||
  die "failed to parse the resolved release of ${repo}"
[ -n "$tag" ] || die "the resolved release of ${repo} has no tag_name"

version="${tag#v}"
asset_name="${asset_template//\{version\}/$version}"
asset_url=$(jq -r --arg name "$asset_name" '
  first(.assets[]? | select(.name == $name) | .browser_download_url) // ""' <<<"$release") ||
  die "failed to parse the assets of ${tag}"

if [ -z "$asset_url" ]; then
  # A tag can exist without a usable download: the upstream release workflow
  # rolls tags back when a later step fails, and tags predating the current
  # naming scheme carry differently named assets.
  skip "release ${tag} of ${repo} has no asset named ${asset_name}"
fi

log "Resolved the ${channel} channel of ${repo} to ${tag} (${asset_name})"

emit skip false
emit tag "$tag"
emit version "$version"
emit asset_name "$asset_name"
emit asset_url "$asset_url"
