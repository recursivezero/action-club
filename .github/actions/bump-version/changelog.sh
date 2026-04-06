#!/usr/bin/env bash
set -e

# Get the latest tag BEFORE this current bump
latest_tag=$(git describe --tags --abbrev=0 2>/dev/null || echo "")
new_tag=${NEW_VERSION:-"v$(node -p "require('./package.json').version")"}
changelog_date=$(date +"%Y-%m-%d")

# Create temporary changelog entry
{
  echo -e "\n## [$new_tag] - $changelog_date\n"
  if [ -n "$latest_tag" ]; then
    # Logs between the last release and now
    git log "${latest_tag}..HEAD" --pretty=format:"- %s"
  else
    # First release ever
    git log --pretty=format:"- %s"
  fi
  echo -e "\n"
} > NEW_CHANGELOG.md

# Prepend to existing CHANGELOG.md
if [ -f CHANGELOG.md ]; then
    cat CHANGELOG.md >> NEW_CHANGELOG.md
fi
mv NEW_CHANGELOG.md CHANGELOG.md

# Final Commit & Tag logic (Move this to the end of the suite)
git add package.json package-lock.json CHANGELOG.md
git commit -m "chore: release $new_tag"
git tag -a "$new_tag" -m "release $new_tag"