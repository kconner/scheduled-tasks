# Scheduled Tasks for macOS

A simple system for scheduling terminal commands that run reliably, even when your Mac is asleep.

## Features

- **Sleep-aware**: Tasks missed during sleep will run when your Mac wakes up
- **Simple interface**: One command to create scheduled tasks
- **Logging**: All task executions are logged with timestamps
- **Multiple intervals**: Support for hourly, daily, 30-minute, or custom intervals
- **Easy management**: List, view logs, and remove tasks easily

## Installation

The system is already set up in `~/scheduled-tasks/`. No additional installation needed.

## Usage

### Create a scheduled task

```bash
cd ~/scheduled-tasks
./create-task.sh <task-name> "<command>" <interval>
```

Supported intervals:
- `hourly` - Run every hour
- `daily` - Run every 24 hours  
- `30min` - Run every 30 minutes
- `<number>` - Run every N seconds

### Examples

```bash
# Backup documents every hour
./create-task.sh backup-docs "rsync -av ~/Documents /Volumes/Backup/" hourly

# Clean temporary files daily
./create-task.sh clean-temp "rm -rf ~/Downloads/*.tmp" daily

# Check for updates every 30 minutes
./create-task.sh check-updates "brew update" 30min

# Custom interval - ping server every 5 minutes (300 seconds)
./create-task.sh ping-check "ping -c 1 example.com" 300
```

### List all tasks

```bash
./create-task.sh --list
```

### View task logs

```bash
./create-task.sh --logs <task-name>
```

### Remove a task

```bash
./create-task.sh --remove <task-name>
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
1. Check if it's loaded: `./create-task.sh --list`
2. View logs: `./create-task.sh --logs <task-name>`
3. Check launchd errors: `tail /tmp/com.user.scheduled.<task-name>.stderr`
4. Verify the command works manually: `~/scheduled-tasks/scheduled-task-runner.sh test "your command"`