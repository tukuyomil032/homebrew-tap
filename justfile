default:
    @just --list

# Casks/*.rb と Formula/*.rb を RuboCop で検査
lint:
    bundle exec rubocop Casks/ Formula/

# 自動修正可能な違反を修正（safe cop のみ）
fix:
    bundle exec rubocop --autocorrect Casks/ Formula/

# すべての自動修正を実行（危険な変更を含む）
fix-all:
    bundle exec rubocop --autocorrect-all Casks/ Formula/

# scripts/ のシェルスクリプトを bats-core でテスト（要: brew install bats-core）
test:
    bats tests/

# lint と test をまとめて実行
check: lint test

# Git フックをインストール（初回セットアップ時に実行）
setup:
    bunx lefthook install

# Bundler で gem をインストール
install:
    bundle install
