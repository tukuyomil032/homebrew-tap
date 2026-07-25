#!/usr/bin/env bash
# Start and stop the fake GitHub API used by the resolve-release.sh tests.

API_SERVER_PID=''

# start_api_server <fixture-root>
#
# Boots api_server.py on an ephemeral port and exports GH_API_BASE so
# resolve-release.sh talks to it instead of api.github.com.
start_api_server() {
  local root="$1"
  local port_file="${BATS_TEST_TMPDIR}/api_server.port"
  local log_file="${BATS_TEST_TMPDIR}/api_server.log"
  local port=''

  python3 "${BATS_TEST_DIRNAME}/helpers/api_server.py" "$root" \
    >"$port_file" 2>"$log_file" &
  API_SERVER_PID=$!

  # The port is printed as soon as the socket is listening, so polling for the
  # first line is enough — no fixed sleep, no request retry loop.
  for _ in $(seq 1 50); do
    port=$(head -n 1 "$port_file")
    if [ -n "$port" ]; then
      break
    fi
    sleep 0.1
  done

  if [ -z "$port" ]; then
    printf 'api_server.py did not report a port. Its log:\n' >&2
    cat "$log_file" >&2
    return 1
  fi

  export GH_API_BASE="http://127.0.0.1:${port}"
}

stop_api_server() {
  if [ -z "$API_SERVER_PID" ]; then
    return 0
  fi
  kill "$API_SERVER_PID" 2>/dev/null || true
  wait "$API_SERVER_PID" 2>/dev/null || true
  API_SERVER_PID=''
}
