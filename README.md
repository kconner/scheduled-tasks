# Scheduled Tasks for macOS

A simple system for scheduling terminal commands that run reliably, even when your Mac is asleep.

## Features

- **Sleep-aware**: Tasks missed during sleep will run when your Mac wakes up
- **Simple interface**: One command to create scheduled tasks
- **Logging**: All task executions are logged with timestamps
- **Multiple intervals**: Support for hourly, daily, 30-minute, or custom intervals
- **Easy management**: List, view logs, and remove tasks easily

## Installation

Clone this repository to any location. The scripts will work from wherever they're located.

## Usage

### List scheduled tasks

```bash
./scheduled-tasks                    # Default: lists all tasks
./scheduled-tasks list               # Explicit list command
```

### Create a scheduled task

```bash
./scheduled-tasks create <task-name> "<command>" <interval>
```

Supported intervals:
- `hourly` - Run every hour
- `daily` - Run every 24 hours  
- `30min` - Run every 30 minutes
- `<number>` - Run every N seconds

### Examples

```bash
# Backup documents every hour
./scheduled-tasks create backup-docs "rsync -av ~/Documents /Volumes/Backup/" hourly

# Clean temporary files daily
./scheduled-tasks create clean-temp "rm -rf ~/Downloads/*.tmp" daily

# Check for updates every 30 minutes
./scheduled-tasks create check-updates "brew update" 30min

# Custom interval - ping server every 5 minutes (300 seconds)
./scheduled-tasks create ping-check "ping -c 1 example.com" 300
```

### View task logs

```bash
./scheduled-tasks logs <task-name>
```

### Remove a task

```bash
./scheduled-tasks remove <task-name>
```

## How it works

1. **launchd integration**: Uses macOS's built-in launchd system for scheduling
2. **Wrapper script**: All commands run through a wrapper that handles logging
3. **Plist files**: Each task creates a plist file in `~/Library/LaunchAgents/`
4. **Sleep handling**: launchd automatically runs missed tasks after wake

## Logs

All task executions are logged to `~/scheduled-tasks/logs/<task-name>.log`

Each log entry includes:
- Timestamp
- Command executed
- Environment variables
- Exit status
- Command output and errors

## Notes

- Task names must contain only letters, numbers, hyphens, and underscores
- Commands with special characters should be properly quoted
- The system adds `/usr/local/bin` to PATH for common tools like `brew`
- Tasks run with your user permissions
- Logs are never automatically cleaned up - manage them as needed

## Troubleshooting

If a task isn't running:
1. Check if it's loaded: `./scheduled-tasks --list`
2. View logs: `./scheduled-tasks --logs <task-name>`
3. Check launchd errors: `tail /tmp/com.user.scheduled.<task-name>.stderr`
4. Verify the command works manually: `./run-task.sh test "your command"`