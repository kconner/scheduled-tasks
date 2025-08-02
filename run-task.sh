#!/bin/bash

# Generic wrapper script for scheduled tasks

TASK_NAME="$1"
shift
COMMAND="$@"

# Get the absolute path of this script's directory
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
LOG_DIR="$SCRIPT_DIR/logs"
LOG_FILE="$LOG_DIR/${TASK_NAME}.log"

# Ensure log directory exists
mkdir -p "$LOG_DIR"

# Function to log with timestamp
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

# Log start
log "=== Task '$TASK_NAME' starting ==="
log "Command: $COMMAND"
log "Environment: USER=$USER, HOME=$HOME, PATH=$PATH"

# Execute the command and capture output
TEMP_OUTPUT=$(mktemp)
TEMP_ERROR=$(mktemp)

# Run the command
if eval "$COMMAND" > "$TEMP_OUTPUT" 2> "$TEMP_ERROR"; then
    EXIT_CODE=0
    log "Task completed successfully (exit code: 0)"
else
    EXIT_CODE=$?
    log "Task failed (exit code: $EXIT_CODE)"
fi

# Log output if any
if [[ -s "$TEMP_OUTPUT" ]]; then
    log "--- Output ---"
    cat "$TEMP_OUTPUT" >> "$LOG_FILE"
    log "--- End Output ---"
fi

# Log errors if any
if [[ -s "$TEMP_ERROR" ]]; then
    log "--- Errors ---"
    cat "$TEMP_ERROR" >> "$LOG_FILE"
    log "--- End Errors ---"
fi

# Clean up temp files
rm -f "$TEMP_OUTPUT" "$TEMP_ERROR"

# Log end
log "=== Task '$TASK_NAME' finished ==="
log ""

exit $EXIT_CODE