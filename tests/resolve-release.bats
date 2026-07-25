#!/usr/bin/env bats
#
# Unit tests for scripts/resolve-release.sh.
#
# Every scenario is a self-contained fake GitHub API under
# tests/fixtures/api/<scenario>, served by tests/helpers/api_server.py, so the
# script runs against a real curl and real HTTP status codes instead of a stub.
#
# Both pre-release tag forms exercised here exist upstream in Perch: the
# hyphenated ones (1.3.0-beta-5) were tagged by hand under the old release flow,
# the dotted ones (1.3.1-beta.6) are what the current workflow generates. The
# script must resolve either without special-casing them.

# `run --separate-stderr` is what keeps the stdout contract testable.
bats_require_minimum_version 1.5.0

load 'helpers/api_server'

RESOLVE="${BATS_TEST_DIRNAME}/../scripts/resolve-release.sh"
REPO='acme/widget'
TEMPLATE='widget-{version}.dmg'

teardown() {
  stop_api_server
}

# resolve <scenario> [args...] — run the script against a fixture scenario.
resolve() {
  local scenario="$1"
  shift
  start_api_server "${BATS_TEST_DIRNAME}/fixtures/api/${scenario}"
  run --separate-stderr "$RESOLVE" --repo "$REPO" --asset-template "$TEMPLATE" "$@"
}

# assert_line_emitted <exact line> — stdout must contain the line verbatim.
assert_line_emitted() {
  local expected="$1" line
  while IFS= read -r line; do
    if [ "$line" = "$expected" ]; then
      return 0
    fi
  done <<<"$output"

  printf 'expected stdout to contain:\n  %s\nactual stdout:\n%s\n' \
    "$expected" "$output" >&2
  return 1
}

# --- stable channel ---

@test "stable: resolves the latest release that is not a pre-release" {
  resolve stable-present --channel stable

  [ "$status" -eq 0 ]
  assert_line_emitted 'skip=false'
  assert_line_emitted 'tag=v1.2.0'
  assert_line_emitted 'version=1.2.0'
  assert_line_emitted 'asset_name=widget-1.2.0.dmg'
  assert_line_emitted 'asset_url=https://example.invalid/acme/widget/releases/download/v1.2.0/widget-1.2.0.dmg'
}

@test "stable: skips with exit 0 when no stable release has been published" {
  resolve stable-missing --channel stable

  [ "$status" -eq 0 ]
  assert_line_emitted 'skip=true'
  assert_line_emitted 'skip_reason=no stable release published for acme/widget'
}

@test "stable: skips when the release carries no matching asset" {
  resolve stable-asset-missing --channel stable

  [ "$status" -eq 0 ]
  assert_line_emitted 'skip=true'
  assert_line_emitted 'skip_reason=release v1.2.0 of acme/widget has no asset named widget-1.2.0.dmg'
}

@test "stable: fails on an unexpected HTTP status" {
  resolve stable-server-error --channel stable

  [ "$status" -eq 1 ]
  [ -z "$output" ]
  [[ "$stderr" == *'returned HTTP 500'* ]]
}

# --- beta channel ---

@test "beta: resolves the newest pre-release" {
  resolve beta-prerelease-only --channel beta

  [ "$status" -eq 0 ]
  assert_line_emitted 'skip=false'
  assert_line_emitted 'tag=v1.3.0-beta.2'
  assert_line_emitted 'version=1.3.0-beta.2'
  assert_line_emitted 'asset_name=widget-1.3.0-beta.2.dmg'
}

@test "beta: ignores drafts even when they are the newest release" {
  resolve beta-with-draft --channel beta

  [ "$status" -eq 0 ]
  assert_line_emitted 'tag=v1.3.0-beta.2'
}

@test "beta: picks a stable release when it is newer than every pre-release" {
  resolve beta-stable-newer --channel beta

  [ "$status" -eq 0 ]
  assert_line_emitted 'tag=v1.3.0'
  assert_line_emitted 'asset_name=widget-1.3.0.dmg'
}

@test "beta: handles hyphenated pre-release tags" {
  resolve beta-hyphen-form --channel beta

  [ "$status" -eq 0 ]
  assert_line_emitted 'version=1.3.0-beta-5'
  assert_line_emitted 'asset_name=widget-1.3.0-beta-5.dmg'
}

@test "beta: handles dotted pre-release tags" {
  resolve beta-dot-form --channel beta

  [ "$status" -eq 0 ]
  assert_line_emitted 'version=1.3.1-beta.6'
  assert_line_emitted 'asset_name=widget-1.3.1-beta.6.dmg'
}

@test "beta: sorts by published_at rather than trusting the array order" {
  resolve beta-mixed-order --channel beta

  [ "$status" -eq 0 ]
  assert_line_emitted 'tag=v1.3.0-beta.3'
}

@test "beta: falls back to created_at when published_at is null" {
  resolve beta-null-published-at --channel beta

  [ "$status" -eq 0 ]
  assert_line_emitted 'tag=v1.3.0-beta.9'
}

@test "beta: skips with exit 0 when the repository has no releases" {
  resolve beta-empty --channel beta

  [ "$status" -eq 0 ]
  assert_line_emitted 'skip=true'
  assert_line_emitted 'skip_reason=no published release found for acme/widget'
}

@test "beta: skips when the release carries no matching asset" {
  resolve beta-asset-missing --channel beta

  [ "$status" -eq 0 ]
  assert_line_emitted 'skip=true'
  assert_line_emitted 'skip_reason=release v1.3.0-beta.2 of acme/widget has no asset named widget-1.3.0-beta.2.dmg'
}

@test "beta: fails on an unexpected HTTP status" {
  resolve beta-server-error --channel beta

  [ "$status" -eq 1 ]
  [ -z "$output" ]
  [[ "$stderr" == *'returned HTTP 500'* ]]
}

# --- transport and usage errors ---

@test "fails when the API host is unreachable" {
  export GH_API_BASE='http://127.0.0.1:1'
  run --separate-stderr "$RESOLVE" \
    --repo "$REPO" --channel stable --asset-template "$TEMPLATE"

  [ "$status" -eq 1 ]
  [ -z "$output" ]
  [[ "$stderr" == *'HTTP 000'* ]]
}

@test "fails on an unknown channel without writing to stdout" {
  run --separate-stderr "$RESOLVE" \
    --repo "$REPO" --channel nightly --asset-template "$TEMPLATE"

  [ "$status" -eq 1 ]
  [ -z "$output" ]
  [[ "$stderr" == *'unknown channel: nightly'* ]]
}

@test "fails when --repo is missing" {
  run --separate-stderr "$RESOLVE" --channel stable --asset-template "$TEMPLATE"

  [ "$status" -eq 1 ]
  [ -z "$output" ]
  [[ "$stderr" == *'--repo is required'* ]]
}

@test "fails when --asset-template is missing" {
  run --separate-stderr "$RESOLVE" --repo "$REPO" --channel stable

  [ "$status" -eq 1 ]
  [ -z "$output" ]
  [[ "$stderr" == *'--asset-template is required'* ]]
}

@test "fails on an unknown argument" {
  run --separate-stderr "$RESOLVE" \
    --repo "$REPO" --channel stable --asset-template "$TEMPLATE" --force

  [ "$status" -eq 1 ]
  [ -z "$output" ]
  [[ "$stderr" == *'unknown argument: --force'* ]]
}

# --- output contract ---

@test "stdout carries nothing but key=value lines" {
  resolve stable-present --channel stable

  [ "$status" -eq 0 ]

  local line
  while IFS= read -r line; do
    if [[ ! "$line" =~ ^[a-z_]+=.*$ ]]; then
      printf 'unexpected stdout line: %s\nfull stdout:\n%s\n' "$line" "$output" >&2
      return 1
    fi
  done <<<"$output"
}
