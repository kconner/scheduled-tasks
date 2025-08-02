#!/bin/bash
set -u

usage() {
    echo "Usage: $0 <task-name> <command>"
    echo ""
    echo "This script is used internally by the scheduled-tasks system to run tasks"
    echo "with logging. It's typically called by launchd, not directly by users."
    echo ""
    echo "For testing, you can run:"
    echo "  $0 test-task \"echo 'Hello, world!'\""
    echo ""
    echo "Logs will be created in: <repo-location>/logs/<task-name>.log"
}

if [[ "$1" == "--help" || "$1" == "-h" || $# -eq 0 ]]; then
    usage
    exit 0
fi

task_name="$1"
shift
command="$*"

# Locate the folder containing the script, even if called through a symlink
script_folder="$(cd "$(dirname "$(realpath "$0")")" && pwd)"

logs_folder="$script_folder/logs"
log_path="$logs_folder/${task_name}.log"

mkdir -p "$logs_folder"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$log_path"
}

log "=== '$task_name'"
log "command: $command"

stdout_path=$(mktemp)
stderr_path=$(mktemp)

if eval "$command" > "$stdout_path" 2> "$stderr_path"; then
    exit_code=0
    log "succeeded (exit code: 0)"
else
    exit_code=$?
    log "failed (exit code: $exit_code)"
fi

if [[ -s "$stdout_path" ]]; then
    log "--- stdout"
    cat "$stdout_path" >> "$log_path"
    log "--- end stdout"
fi

if [[ -s "$stderr_path" ]]; then
    log "--- stderr"
    cat "$stderr_path" >> "$log_path"
    log "--- end stderr"
fi

rm -f "$stdout_path" "$stderr_path"

log "--- end '$task_name'"
log ""

exit $exit_code
