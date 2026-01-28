#!/usr/bin/env bash
set -e

# Install git-cliff if not already available
cargo install git-cliff --locked || true

# Get latest and new tag
latest_tag=$(git describe --tags --abbrev=0 HEAD^ || echo "")
new_tag=$(git describe --tags --abbrev=0 HEAD)
changelog_date=$(date +"%a, %b %d %Y")

# Generate changelog using cliff.toml
if [ -n "$latest_tag" ]; then
  git cliff --config ${{ github.action_path }}/cliff.toml \
    --tag "$new_tag" \
    --unreleased \
    --output CHANGELOG.md
else
  git cliff --config ${{ github.action_path }}/cliff.toml \
    --tag "$new_tag" \
    --unreleased \
    --output CHANGELOG.md
fi

git add CHANGELOG.md
git commit -m "docs: update changelog for $new_tag" || echo "No changelog update needed"
