#!/usr/bin/env bash
set -e

new_tag=${NEW_VERSION:-$(git describe --tags --abbrev=0 2>/dev/null || echo "v0.0.0")}
changelog_date=$(date +"%Y-%m-%d")

{
  echo ""   # <-- ensures a blank line before each heading
  echo "## [$new_tag] - $changelog_date"
  echo ""   # <-- ensures a blank line after heading
  echo "- Version bump type: ${INPUT_BUMP_TYPE:-patch}"
  git log "$(git describe --tags --abbrev=0 2>/dev/null || echo "")..HEAD" --pretty=format:"- %s"
} >> CHANGELOG.md

git add CHANGELOG.md
git commit -m "chore: update changelog for $new_tag" || true

echo "### 📝 Changelog updated for $new_tag" >> $GITHUB_STEP_SUMMARY
