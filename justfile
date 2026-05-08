default:
    @just --list

# Casks/*.rb を RuboCop で検査
lint:
    bundle exec rubocop Casks/

# 自動修正可能な違反を修正（safe cop のみ）
fix:
    bundle exec rubocop --autocorrect Casks/

# すべての自動修正を実行（危険な変更を含む）
fix-all:
    bundle exec rubocop --autocorrect-all Casks/

# Git フックをインストール（初回セットアップ時に実行）
setup:
    bunx lefthook install

# Bundler で gem をインストール
install:
    bundle install
