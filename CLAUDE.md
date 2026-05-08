# homebrew-tap

tukuyomil032の Homebrew Cask及びscoop を管理するリポジトリ。

## プロジェクト構造

```
homebrew-tap/
├── .github/workflows/
│   ├── bump-cask.yml                # Homebrew バージョン自動更新ワークフロー
│   └── update-scoop.yml             # Scoop バージョン自動更新ワークフロー
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
- `version` / `url` / `hash` の3フィールドは `update-scoop.yml` により自動更新される
- `installer.script` / `uninstaller.script` は PowerShell 配列で記述
- JSON の更新は `jq` コマンドを使用（直接編集は避ける）

### バージョン更新

- **macOS**: GitHub Actions（`bump-cask.yml`）が6時間ごとに `brew livecheck` を実行、新バージョン検出時は `brew bump-cask-pr` で PR を自動作成
- **Windows**: GitHub Actions（`update-scoop.yml`）が6時間ごとに GitHub Releases API を確認、新バージョン検出時は `bucket/mc-vector.json` を直接更新し `main` へコミット

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
