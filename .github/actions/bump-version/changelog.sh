#!/usr/bin/env bash
set -e

latest_tag=$(git describe --tags --abbrev=0 HEAD^ || echo "")
new_tag=$(git describe --tags --abbrev=0 HEAD)
changelog_date=$(date +"%a, %b %d %Y")

{
  echo -e "\n## [$new_tag] - $changelog_date\n"
  if [ -n "$latest_tag" ]; then
    git log ${latest_tag}..HEAD --pretty=format:"- %s"
  else
    git log HEAD --pretty=format:"- %s"
  fi
  echo ""
} >> CHANGELOG.md

git add CHANGELOG.md
git commit -m "docs: update changelog for $new_tag" || echo "No changelog update needed"
