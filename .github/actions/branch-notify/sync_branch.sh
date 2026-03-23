#!/bin/bash

# ==============================================================================
# INPUT ARGUMENTS
# ==============================================================================
# $1: The branch name being created (e.g., feature/RZX-250001)
# $2: The project prefix to search for (e.g., RZX)
# $3: Dry run flag (true/false)
# ==============================================================================
BRANCH_NAME=$1
SEARCH_PREFIX=$2
DRY_RUN=$3
DEFAULT_LABEL="development"

echo "--- STARTING SYNC SCRIPT ---"

# ------------------------------------------------------------------------------
# STEP 1: Extract the Issue ID from the branch name
# Uses Regex to find the pattern "PREFIX-NUMBERS"
# ------------------------------------------------------------------------------
ID=$(echo "$BRANCH_NAME" | grep -oE "$SEARCH_PREFIX-[0-9]+")

if [ -z "$ID" ]; then
  echo "⚠️  No ID matching prefix '$SEARCH_PREFIX' found in branch '$BRANCH_NAME'. Skipping."
  exit 0
fi

echo "🔎 Extracted Issue ID: $ID"

# ------------------------------------------------------------------------------
# STEP 2: Find the GitHub Issue Number
# Searches for an open issue where the title contains the Extracted ID
# ------------------------------------------------------------------------------
ISSUE_NUM=$(gh issue list --state open --search "$ID" --json number --jq '.[0].number')

if [ "$ISSUE_NUM" == "null" ] || [ -z "$ISSUE_NUM" ]; then
  echo "❌ No open issue found with '$ID' in the title."
  exit 0
fi

echo "✅ Found Matching Issue: #$ISSUE_NUM"

# ------------------------------------------------------------------------------
# STEP 3: Execute Actions (Comment & Label)
# ------------------------------------------------------------------------------
BRANCH_URL="https://github.com/${GITHUB_REPOSITORY}/tree/${BRANCH_NAME}"
if [ "$DRY_RUN" == "true" ]; then
  echo "🧪 [DRY RUN] Would update Issue #$ISSUE_NUM with label '$DEFAULT_LABEL'"
else
  # A. Ensure the 'development' label exists in the repo
  # 2>/dev/null hides the error if it already exists; || true ensures the script continues
  gh label create "$DEFAULT_LABEL" --color "0E8A16" --description "Branch created for this issue" 2>/dev/null || true

  # B. Add a comment with a direct link to the branch
  # We use a Markdown link: [text](url)
  COMMENT_BODY="🚀 **Branch Created**: [\`$BRANCH_NAME\`]($BRANCH_URL) by @$GITHUB_ACTOR"
  
  gh issue comment "$ISSUE_NUM" --body "$COMMENT_BODY"

  # C. Apply the label to the right-hand sidebar
  gh issue edit "$ISSUE_NUM" --add-label "$DEFAULT_LABEL"
  
  echo "✨ Issue #$ISSUE_NUM updated successfully with comment and label."
fi

echo "--- SCRIPT FINISHED ---"