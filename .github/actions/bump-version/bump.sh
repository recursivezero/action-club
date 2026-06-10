#!/usr/bin/env bash
set -e

if [ "$GITHUB_EVENT_NAME" = "workflow_dispatch" ] && [ -n "${INPUT_BUMP_TYPE}" ]; then
  bump_type="${INPUT_BUMP_TYPE}"
  echo "Using bump type from workflow_dispatch input: $bump_type"
else
  bump="${GITHUB_HEAD_COMMIT_MESSAGE:-$(git log -1 --pretty=%B)}"
  echo "Commit message: $bump"
  if [[ "$bump" == *"#minor"* ]]; then
    bump_type="minor"
  elif [[ "$bump" == *"#major"* ]]; then
    bump_type="major"
  else
    bump_type="patch"
  fi
  echo "Derived bump type from commit message: $bump_type"
fi

# Single bump call: commits + tags
new_version=$(npm version "$bump_type" -m "chore: bump $bump_type version to %s")
echo "NEW_VERSION=$new_version" >> $GITHUB_ENV
echo "Bumped to $new_version"
