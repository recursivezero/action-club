#!/usr/bin/env bash
set -e

bump="${GITHUB_HEAD_COMMIT_MESSAGE:-$(git log -1 --pretty=%B)}"
echo "Commit message: $bump"

if [[ "$bump" == *"#minor"* ]]; then
  npm version minor -m "chore: bump minor version"
elif [[ "$bump" == *"#major"* ]]; then
  npm version major -m "chore: bump major version"
else
  npm version patch -m "chore: bump patch version"
fi
