#!/usr/bin/env bash
set -e

bump_type="${INPUT_BUMP_TYPE:-patch}"

if [ -f package.json ]; then
  # Node project: use npm version
  new_version=$(npm version "$bump_type" -m "chore: bump $bump_type version to %s")
else
  # No package.json: bump purely with git tags
  latest_tag=$(git describe --tags --abbrev=0 2>/dev/null || echo "v0.0.0")
  version=${latest_tag#v}
  major=$(echo $version | cut -d. -f1)
  minor=$(echo $version | cut -d. -f2)
  patch=$(echo $version | cut -d. -f3)
  case $bump_type in
    major) major=$((major+1)); minor=0; patch=0 ;;
    minor) minor=$((minor+1)); patch=0 ;;
    patch) patch=$((patch+1)) ;;
  esac
  new_version="v${major}.${minor}.${patch}"
  git tag -a "$new_version" -m "chore: bump $bump_type version to $new_version"
fi

echo "NEW_VERSION=$new_version" >> $GITHUB_ENV
echo "### 📦 Version bumped to $new_version ($bump_type)" >> $GITHUB_STEP_SUMMARY
