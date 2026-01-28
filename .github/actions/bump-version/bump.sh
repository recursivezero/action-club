#!/usr/bin/env bash
set -e

if [ "$GITHUB_EVENT_NAME" = "workflow_dispatch" ] && [ -n "${INPUT_BUMP_TYPE}" ]; then
  # Manual run with dropdown input
  bump_type="${INPUT_BUMP_TYPE}"
  echo "Using bump type from workflow_dispatch input: $bump_type"
else
  # Automatic run based on commit message
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

case "$bump_type" in
  minor) npm version minor -m "chore: bump minor version" ;;
  major) npm version major -m "chore: bump major version" ;;
  patch) npm version patch -m "chore: bump patch version" ;;
  *)     echo "Invalid bump type: $bump_type" && exit 1 ;;
esac
