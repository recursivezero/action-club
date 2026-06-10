#!/usr/bin/env bash
set -e

# Use NEW_VERSION from bump.sh if available, otherwise fall back to latest git tag
new_tag=${NEW_VERSION:-$(git describe --tags --abbrev=0 2>/dev/null || echo "v0.0.0")}
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

echo "### 📝 Changelog updated for $new_tag" >> $GITHUB_STEP_SUMMARY
