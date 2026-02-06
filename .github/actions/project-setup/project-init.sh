#!/bin/bash
set -e

# ==============================================================================
# SCRIPT: project-init.sh
# DESCRIPTION: Connects an item to Project 1 and moves it to a specific column.
# USAGE: ./project-init.sh <URL> <NUMBER> <STATUS>
# ==============================================================================

# Assign arguments to meaningful variable names

PROJECT_OWNER="${1:-$GITHUB_REPOSITORY_OWNER}"
PROJECT_NUMBER="$2"
ITEM_URL="$3" # Issue or PR url
ISSUE_NUMBER="$4"
TARGET_STATUS="$5"

echo "--- STARTING PROJECT INITIALIZATION ---"
echo "📍 Item: $ITEM_URL"
echo "🎯 Target Status: $TARGET_STATUS"

run_automation() {
  # STEP A: Get the Project Global Node ID
  # This ID is required for all 'gh project item-edit' operations.
  PROJECT_DATA=$(gh project view $PROJECT_NUMBER --owner "$PROJECT_OWNER" --format json)
  PROJECT_ID=$(echo $PROJECT_DATA | jq -r '.id')

  # STEP B: Add the Item (Issue/PR) to the Project
  # This returns the 'Item ID', which represents the "card" on the board.
  echo "📥 Adding item to Project #$PROJECT_NUMBER..."
  ITEM_ID=$(gh project item-add $PROJECT_NUMBER --owner "$PROJECT_OWNER" --url "$ITEM_URL" --format json | jq -r '.id')

  # STEP C: Map Field and Option IDs
  # We fetch the ID for the 'Status' field and the ID for the specific column name.
  echo "⚙️  Mapping metadata for status: $TARGET_STATUS..."
  STATUS_FIELD_ID=$(gh project field-list $PROJECT_NUMBER --owner "$PROJECT_OWNER" --format json | jq -r '.fields[] | select(.name=="Status") | .id')
  
  # Search the options array for the specific column name (e.g., 'Todo' or 'In Progress')
  OPTION_ID=$(gh project field-list $PROJECT_NUMBER --owner "$PROJECT_OWNER" --format json | jq -r ".fields[] | select(.name==\"Status\") | .options[] | select(.name==\"$TARGET_STATUS\") | .id")

  # STEP D: Final Update
  # Apply the status change to the item.
  echo "🚀 Updating item to column: $TARGET_STATUS..."
  gh project item-edit --id "$ITEM_ID" --project-id "$PROJECT_ID" --field-id "$STATUS_FIELD_ID" --single-select-option-id "$OPTION_ID"
}

# Execute the function and handle potential failures
if run_automation; then
  echo "✅ Success: Item linked and set to $TARGET_STATUS."
else
  echo "❌ Error: Automation failed. Posting fallback comment..."
  # If it fails, post a comment to the issue/PR so the human knows.
  gh issue comment "$ISSUE_NUMBER" \
  --repo "$GITHUB_REPOSITORY" \
  --body "⚠️ **Automation Note**: Failed to link this to Project #$PROJECT_NUMBER with status '$TARGET_STATUS'. Please check Action logs."

  exit 1
fi