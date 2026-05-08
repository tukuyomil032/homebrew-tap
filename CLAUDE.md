# tukuyomil032/tap

tukuyomil032の Homebrew Cask および Scoop Bucket を統合管理するリポジトリ。

## プロジェクト構造

```
homebrew-tap/
├── .github/workflows/
│   ├── mc-vector-bump-cask.yml      # mc-vector: Homebrew バージョン自動更新
│   ├── mc-vector-update-scoop.yml   # mc-vector: Scoop バージョン自動更新
│   └── <appname>-bump-cask.yml      # 追加アプリは同様の命名規則で追加
├── Casks/
│   └── mc-vector.rb                 # Homebrew Cask 定義
├── bucket/
│   └── mc-vector.json               # Scoop マニフェスト定義
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

### Cask ファイル（Casks/*.rb）

- **文字列はシングルクォート使用**（`'mc-vector'` など）
  - 式展開が必要な場合のみダブルクォートを使用（`"#{version}"` など）
- rubocop で静的解析を実施（`bundle exec rubocop`）
- Homebrew 公式の Cask DSL に準拠

### Scoop マニフェスト（bucket/*.json）

- JSON フォーマットで記述（インデント2スペース）
- `version` / `url` / `hash` の3フィールドは `<appname>-update-scoop.yml` により自動更新される
- `installer.script` / `uninstaller.script` は PowerShell 配列で記述
- JSON の更新は `jq` コマンドを使用（直接編集は避ける）

### バージョン更新

- **macOS**: GitHub Actions（`<appname>-bump-cask.yml`）が6時間ごとに `brew livecheck` を実行、新バージョン検出時は `brew bump-cask-pr` で PR を自動作成
- **Windows**: GitHub Actions（`<appname>-update-scoop.yml`）が6時間ごとに GitHub Releases API を確認、新バージョン検出時は `bucket/<appname>.json` を直接更新し `main` へコミット

### 新アプリ追加時

1. `Casks/<appname>.rb` を追加
2. `bucket/<appname>.json` を追加
3. `.github/workflows/<appname>-bump-cask.yml` を追加
4. `.github/workflows/<appname>-update-scoop.yml` を追加
5. README の Available Casks / Available Apps テーブルに追記

## よく使うコマンド

| コマンド | 説明 |
|----------|------|
| `just lint` | RuboCop で Cask ファイルを検査 |
| `just fix` | 自動修正可能な違反を修正 |
| `just fix-all` | すべての自動修正を実行（危険な変更含む） |
| `just setup` | Git フックをインストール |
| `just install` | Bundler で gem をインストール |

## Git フック

`lefthook` により pre-commit 時に RuboCop が自動実行される。
対象ファイル: `Casks/*.rb`

フックの無効化（緊急時のみ）:

```bash
LEFTHOOK=0 git commit
```
