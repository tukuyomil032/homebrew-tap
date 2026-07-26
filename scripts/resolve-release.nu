def log [message: string] {
  print -e $message
}

def usage [message?: string] {
  if $message != null { print -e $'error: ($message)' }
  print -e 'usage: resolve-release.sh --repo <owner/name> --channel <stable|beta> --asset-template <template>'
  exit 1
}

def main [repo: string, channel: string, asset_template: string] {
  let api_base = ($env.GH_API_BASE? | default 'https://api.github.com')
  let tmp_dir = (mktemp -d | str trim)
  let body_file = ($tmp_dir | path join 'response.json')

  let headers = [
    'Accept: application/vnd.github+json'
    'X-GitHub-Api-Version: 2022-11-28'
  ]
  let auth_headers = if ($env.GITHUB_TOKEN? | default '' | is-empty) {
    []
  } else {
    [$'Authorization: Bearer ($env.GITHUB_TOKEN)']
  }

  let api_get = {|path: string|
    let endpoint = $'($api_base)($path)'
    let result = (do {
      ^curl --silent --show-error --location ...($headers | each {|header| [-H $header] } | flatten) ...($auth_headers | each {|header| [-H $header] } | flatten) -o $body_file -w '%{http_code}' $endpoint
    } | complete)
    { status: ($result.stdout | str trim), code: $result.exit_code }
  }

  let release = if $channel == 'stable' {
    log $'Looking up the latest stable release of ($repo)...'
    let endpoint = $'/repos/($repo)/releases/latest'
    let result = (do $api_get $endpoint)
    if $result.code != 0 { error make {msg: $'GET ($endpoint) returned HTTP 000'} }
    if $result.status == '404' {
      print 'skip=true'
      print $'skip_reason=no stable release published for ($repo)'
      exit 0
    }
    if $result.status != '200' { error make {msg: $'GET ($endpoint) returned HTTP ($result.status)'} }
    try { open $body_file --raw | from json } catch { error make {msg: 'failed to parse release JSON'} }
  } else if $channel == 'beta' {
    log $'Looking up the newest release of ($repo), pre-releases included...'
    let endpoint = $'/repos/($repo)/releases?per_page=100'
    let result = (do $api_get $endpoint)
    if $result.code != 0 { error make {msg: $'GET ($endpoint) returned HTTP 000'} }
    if $result.status != '200' { error make {msg: $'GET ($endpoint) returned HTTP ($result.status)'} }
    let releases = try { open $body_file --raw | from json } catch { error make {msg: 'failed to parse release JSON'} }
    let published = ($releases | where draft != true | sort-by {|release| ($release | get -o published_at | default ($release | get -o created_at | default '')) } | reverse)
    if ($published | is-empty) {
      print 'skip=true'
      print $'skip_reason=no published release found for ($repo)'
      exit 0
    }
    $published | first
  } else {
    usage $'unknown channel: ($channel)'
  }

  let tag = ($release.tag_name? | default '')
  if ($tag | is-empty) { error make {msg: 'resolved release has no tag_name'} }
  let version = ($tag | str replace --regex '^v' '')
  let asset_name = ($asset_template | str replace --all '{version}' $version)
  let asset = ($release.assets? | default [] | where name == $asset_name | first)
  if $asset == null {
    print 'skip=true'
    print $'skip_reason=release ($tag) of ($repo) has no asset named ($asset_name)'
    exit 0
  }

  log $'Resolved the ($channel) channel of ($repo) to ($tag) (($asset_name))'
  print 'skip=false'
  print $'tag=($tag)'
  print $'version=($version)'
  print $'asset_name=($asset_name)'
  print $'asset_url=($asset.browser_download_url)'
}
