# tukuyomil032/tap

tukuyomil032の Homebrew Cask および Scoop Bucket を統合管理するリポジトリ。

## プロジェクト構造

```
homebrew-tap/
├── .github/workflows/
│   ├── ci.yml                       # bats と rubocop（push / PR）
│   ├── mc-vector-bump-cask.yml      # mc-vector: Homebrew バージョン自動更新
│   ├── mc-vector-update-scoop.yml   # mc-vector: Scoop バージョン自動更新
│   └── <appname>-bump-cask.yml      # 追加アプリは同様の命名規則で追加
├── Casks/
│   ├── mc-vector.rb                 # Homebrew Cask 定義
│   ├── glance.rb                    # Homebrew Cask 定義
│   ├── perch.rb                     # perch: stable チャンネル用 Cask
│   └── perch@latest.rb              # perch: beta チャンネル用 Cask
├── Formula/
│   └── gitkeeper.rb                 # Homebrew Formula 定義
├── bucket/
│   └── mc-vector.json               # Scoop マニフェスト定義
├── scripts/
│   └── resolve-release.sh           # チャンネル別のリリース解決（bump ワークフローが使用）
├── tests/
│   ├── resolve-release.bats         # bats-core によるユニットテスト
│   ├── helpers/                     # fixture 用の擬似 GitHub API サーバ
│   └── fixtures/api/                # シナリオごとの API レスポンス
├── Gemfile / Gemfile.lock           # rubocop の依存管理（Bundler）
├── package.json / bun.lock          # lefthook の依存管理（Bun）
├── lefthook.yml                     # Git フック設定
├── justfile                         # タスクランナー
└── CLAUDE.md                        # このファイル
```

## セットアップ

```bash
bundle install        # rubocop のインストール
bunx lefthook install # Git フックのインストール
# または
just install && just setup
```

## コード規約

### Cask / Formula ファイル（Casks/*.rb, Formula/*.rb）

- **文字列はダブルクォート使用**（`"mc-vector"` など）
  - 根拠: Homebrew 本体の `Library/.rubocop.yml` が `Style/StringLiterals: EnforcedStyle: double_quotes`
    を強制しており、`brew style --cask` はシングルクォートを offense として報告する
  - このリポジトリの `.rubocop.yml` は `Style/StringLiterals` の `Exclude` に `Casks/**/*.rb` と
    `Formula/**/*.rb` を入れているため `bundle exec rubocop` は両形式を許すが、
    配布先の Homebrew 公式スタイルに合わせてダブルクォートで書く
- rubocop で静的解析を実施（`bundle exec rubocop`）
- Homebrew 公式の Cask DSL に準拠

### その他の Ruby ファイル（Gemfile など）

- **文字列はシングルクォート使用**（`.rubocop.yml` の `Style/StringLiterals: EnforcedStyle: single_quotes`）

### Scoop マニフェスト（bucket/*.json）

- JSON フォーマットで記述（インデント2スペース）
- `version` / `url` / `hash` の3フィールドは `<appname>-update-scoop.yml` により自動更新される
- `installer.script` / `uninstaller.script` は PowerShell 配列で記述
- JSON の更新は `jq` コマンドを使用（直接編集は避ける）

### バージョン更新

- **macOS**: GitHub Actions（`<appname>-bump-cask.yml`）が6時間ごとに GitHub Releases API を確認、新バージョン検出時は `Casks/<appname>.rb` の `version` / `sha256` を書き換えて `main` へコミット（`brew bump-cask-pr` は使っていない）
- **Windows**: GitHub Actions（`<appname>-update-scoop.yml`）が6時間ごとに GitHub Releases API を確認、新バージョン検出時は `bucket/<appname>.json` を直接更新し `main` へコミット

perch は `scripts/resolve-release.sh` 経由でチャンネルごとにバージョンを解決する。他のアプリはワークフロー内にロジックがインラインで書かれている。`resolve-release.sh` は既存の呼び出し契約を保つNuShellラッパーで、実装本体は同じディレクトリの `resolve-release.nu` にある。実行環境には `nu` が必要。

### 新アプリ追加時

1. `Casks/<appname>.rb` を追加
2. `bucket/<appname>.json` を追加
3. `.github/workflows/<appname>-bump-cask.yml` を追加
4. `.github/workflows/<appname>-update-scoop.yml` を追加
5. README の Available Casks / Available Apps テーブルに追記

### 複数チャンネル（stable / pre-release）を配る場合

Homebrew 公式の `claude-code` / `claude-code@latest` と同じ命名に従う。

1. `Casks/<appname>.rb`（stable）と `Casks/<appname>@latest.rb`（pre-release を含む最新。perch の場合は beta のみ）を用意する
2. `@latest` 側に `conflicts_with cask: "<appname>"` を書く（同じ app を置くため排他）
3. `@latest` の `livecheck` は `strategy :github_releases` を**ブロック形式**で使う。既定のパスは pre-release を除外してしまうため、`json` を自分で filter する必要がある
4. bump ワークフローは `channel` / `cask` / `token` の matrix にし、`scripts/resolve-release.sh` でバージョンを解決する。両ジョブが `main` へ push するので `max-parallel: 1` と `concurrency` を付ける

`scripts/resolve-release.sh` は該当チャンネルに追跡対象が無いとき `skip=true` を返して exit 0 する。安定版が未公開なリポジトリでもワークフローが失敗しないのはこのため。

## よく使うコマンド

| コマンド | 説明 |
|----------|------|
| `just lint` | RuboCop で Cask ファイルを検査 |
| `just fix` | 自動修正可能な違反を修正 |
| `just fix-all` | すべての自動修正を実行（危険な変更含む） |
| `just test` | bats-core で `scripts/` のテストを実行（要 `brew install bats-core`） |
| `just check` | `just lint` と `just test` をまとめて実行 |
| `just setup` | Git フックをインストール |
| `just install` | Bundler で gem をインストール |

## Git フック

`lefthook` により pre-commit 時に RuboCop が自動実行される。
対象ファイル: `Casks/*.rb`

フックの無効化（緊急時のみ）:

```bash
LEFTHOOK=0 git commit
```
