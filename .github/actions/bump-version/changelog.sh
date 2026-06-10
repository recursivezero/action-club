#!/usr/bin/env bash
set -e

new_tag=${NEW_VERSION:-"v$(node -p "require('./package.json').version")"}
changelog_date=$(date +"%Y-%m-%d")

{
  echo -e "\n## [$new_tag] - $changelog_date\n"
  git log "$(git describe --tags --abbrev=0 2>/dev/null || echo "")..HEAD" --pretty=format:"- %s"
  echo -e "\n"
} > NEW_CHANGELOG.md

if [ -f CHANGELOG.md ]; then
  cat CHANGELOG.md >> NEW_CHANGELOG.md
fi
mv NEW_CHANGELOG.md CHANGELOG.md

git add CHANGELOG.md
git commit -m "chore: update changelog for $new_tag" || true
