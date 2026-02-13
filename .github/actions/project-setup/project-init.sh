#!/bin/bash
set -e

# Arguments
PROJECT_OWNER="${1:-$GITHUB_REPOSITORY_OWNER}"
PROJECT_NUMBER="$2"
ITEM_URL="$3" 
ISSUE_NUMBER="$4"
TARGET_STATUS="$5"

echo "--- STARTING PROJECT INITIALIZATION ---"
echo "📍 Item: $ITEM_URL"
echo "🎯 Target Status: $TARGET_STATUS"

run_automation() {
  # STEP A: Get Project ID
  PROJECT_DATA=$(gh project view "$PROJECT_NUMBER" --owner "$PROJECT_OWNER" --format json)
  PROJECT_ID=$(echo "$PROJECT_DATA" | jq -r '.id')

  # STEP B: Add Item
  echo "📥 Adding item to Project #$PROJECT_NUMBER..."
  ITEM_ID=$(gh project item-add "$PROJECT_NUMBER" --owner "$PROJECT_OWNER" --url "$ITEM_URL" --format json | jq -r '.id')

  # STEP C: Map Metadata
  echo "⚙️  Mapping metadata for status: $TARGET_STATUS..."
  FIELDS_JSON=$(gh project field-list "$PROJECT_NUMBER" --owner "$PROJECT_OWNER" --format json)
  
  STATUS_FIELD_ID=$(echo "$FIELDS_JSON" | jq -r '.fields[] | select(.name=="Status") | .id')
  OPTION_ID=$(echo "$FIELDS_JSON" | jq -r ".fields[] | select(.name==\"Status\") | .options[] | select(.name==\"$TARGET_STATUS\") | .id")

  if [[ -z "$OPTION_ID" || "$OPTION_ID" == "null" ]]; then
    echo "❌ Error: Could not find option ID for status '$TARGET_STATUS'"
    return 1
  fi

  # STEP D: Final Update with Error Handling
  echo "🚀 Updating item to column: $TARGET_STATUS..."
  
  # Capture stderr to check for "no changes to make"
  set +e # Temporarily disable 'exit on error' to handle the CLI response
  OUTPUT=$(gh project item-edit --id "$ITEM_ID" --project-id "$PROJECT_ID" --field-id "$STATUS_FIELD_ID" --single-select-option-id "$OPTION_ID" 2>&1)
  EXIT_CODE=$?
  set -e # Re-enable 'exit on error'

  if [ $EXIT_CODE -eq 0 ]; then
    return 0
  elif [[ "$OUTPUT" == *"no changes to make"* ]]; then
    echo "ℹ️  Notice: Item is already in '$TARGET_STATUS' status."
    return 0
  else
    echo "❌ CLI Error: $OUTPUT"
    return 1
  fi
}

if run_automation; then
  echo "✅ Success: Project synchronization complete."
else
  echo "❌ Error: Automation failed. Posting fallback comment..."
  gh issue comment "$ISSUE_NUMBER" \
    --repo "$GITHUB_REPOSITORY" \
    --body "⚠️ **Automation Note**: Failed to link this to Project #$PROJECT_NUMBER with status '$TARGET_STATUS'. Please check Action logs."
  exit 1
fi