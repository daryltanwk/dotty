#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
# Treat unset variables as an error when substituting.
# Exit if any command in a pipeline fails.
set -euo pipefail

# Define the snippet to manage
SNIPPET='for file in ~/.bashrc.d/*.bashrc; do source $file; done'
BASHRC_FILE="$HOME/.bashrc"
TEMP_FILE="${BASHRC_FILE}.tmp.$$" # Temporary file for safe modification

# --- Dry Run Logic ---
DRY_RUN=false
if [[ "$#" -gt 0 && ("$1" == "--dry-run" || "$1" == "-n") ]]; then
    DRY_RUN=true
    echo "--- Dry run mode enabled. No actual file changes will be made. ---"
    shift # Consume the dry-run argument
fi

# --- Ensure .bashrc exists ---
if [[ ! -f "$BASHRC_FILE" ]]; then
    echo "Note: $BASHRC_FILE does not exist. Creating it."
    if [ "$DRY_RUN" == "false" ]; then
        touch "$BASHRC_FILE"
    fi
fi

# --- Check existing state ---

# Check if the snippet exists anywhere in the file (exact line match)
# -F: fixed string, -x: whole line, -q: quiet (exit status indicates match)
if grep -F -x -q "$SNIPPET" "$BASHRC_FILE"; then
    SNIPPET_EXISTS=true
else
    SNIPPET_EXISTS=false
fi

# Get the last line of the file, removing trailing whitespace for robust comparison
LAST_LINE=""
if [[ -s "$BASHRC_FILE" ]]; then # Check if file is not empty
    LAST_LINE=$(tail -n 1 "$BASHRC_FILE" | sed 's/[[:space:]]*$//')
fi
# Clean the snippet string for comparison (remove potential trailing whitespace)
CLEAN_SNIPPET=$(echo "$SNIPPET" | sed 's/[[:space:]]*$//')

# Check if the last line matches the snippet
if [[ "$LAST_LINE" == "$CLEAN_SNIPPET" ]]; then
    IS_AT_END=true
else
    IS_AT_END=false
fi

# --- Determine and perform action ---

ACTION_TAKEN="None" # Default action

if [ "$SNIPPET_EXISTS" == true ] && [ "$IS_AT_END" == true ]; then
    # Scenario 1: Snippet exists and is at the bottom
    ACTION_TAKEN="Already at end"
    echo "Scenario: Snippet already exists at the end of $BASHRC_FILE."
    echo "Action: No changes needed."

elif [ "$SNIPPET_EXISTS" == true ] && [ "$IS_AT_END" == false ]; then
    # Scenario 2: Snippet exists but is NOT at the bottom
    ACTION_TAKEN="Moved to end"
    echo "Scenario: Snippet found in $BASHRC_FILE but not at the end."
    echo "Action: Removing existing snippet(s) and appending to the end."

    if [ "$DRY_RUN" == "false" ]; then
        # Remove all lines exactly matching the snippet
        grep -v -F -x "$SNIPPET" "$BASHRC_FILE" > "$TEMP_FILE"
        # Append the snippet to the cleaned file
        echo "$SNIPPET" >> "$TEMP_FILE"
        # Replace the original file with the temporary file
        mv "$TEMP_FILE" "$BASHRC_FILE"
    else
        echo "Dry run: Would remove existing snippet(s) and append to the end."
    fi

elif [ "$SNIPPET_EXISTS" == false ]; then
    # Scenario 3: Snippet does NOT exist
    ACTION_TAKEN="Appended"
    echo "Scenario: Snippet not found in $BASHRC_FILE."
    echo "Action: Appending snippet to the end of the file."

    if [ "$DRY_RUN" == "false" ]; then
        # Append the snippet to the file
        echo "" >> "$BASHRC_FILE"
        echo "$SNIPPET" >> "$BASHRC_FILE"
    else
         echo "Dry run: Would append the snippet to the end of the file."
    fi
fi

# --- Report final status ---
echo "" # Newline for clarity
case "$ACTION_TAKEN" in
    "Already at end")
        echo "Status: The snippet is correctly placed at the end of $BASHRC_FILE."
        ;;
    "Moved to end")
        echo "Status: The snippet was successfully moved to the end of $BASHRC_FILE."
        ;;
    "Appended")
        echo "Status: The snippet was successfully appended to $BASHRC_FILE."
        ;;
    "None") # Should not happen with the current logic, but as a fallback
         echo "Status: No action was taken on $BASHRC_FILE."
         ;;
esac

if [ "$DRY_RUN" == "true" ]; then
    echo "--- Dry run finished. No actual file changes were made. ---"
fi

# Clean up temporary file if it exists (useful if script was interrupted)
# This might not catch all interrupt signals, but covers normal execution.
trap 'rm -f "$TEMP_FILE"' EXIT