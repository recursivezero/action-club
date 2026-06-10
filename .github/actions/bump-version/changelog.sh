#!/usr/bin/env bash
set -e

new_tag=${NEW_VERSION:-$(git describe --tags --abbrev=0 2>/dev/null || echo "v0.0.0")}
changelog_date=$(date +"%Y-%m-%d")

{
  echo -e "\n## [$new_tag] - $changelog_date\n"
  echo "- Version bump type: ${INPUT_BUMP_TYPE:-patch}"
  echo ""
  git log "$(git describe --tags --abbrev=0 2>/dev/null || echo "")..HEAD" --pretty=format:"- %s"
  echo ""
} >> CHANGELOG.md   # <-- append instead of prepend

git add CHANGELOG.md
git commit -m "chore: update changelog for $new_tag" || true

#echo "### 📝 Changelog updated for $new_tag" >> $GITHUB_STEP_SUMMARY
