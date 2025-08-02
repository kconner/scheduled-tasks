# Scheduled Tasks

A light system for scheduling macOS terminal commands as repeating launchd agents.

- A task can run daily, hourly, or every N minutes.
- Task runs are logged.
- If one or more runs of a task are missed during sleep, the task runs once when the system wakes.

## Usage

Clone this repository to any location. Avoid changing that location while any tasks exist.

```sh
# list tasks
./scheduled-tasks 

# create a task
./scheduled-tasks create <task-name> <interval> "<command>"
# intervals: daily, hourly, or <number of minutes>

# remove a task
./scheduled-tasks remove <task-name>

# read task logs
./scheduled-tasks logs <task-name>
```

## How it works

For each created task, a plist in `~/Library/LaunchAgents/` passes the given command to `run-task.sh`. Really it's done through a symlink in the `tasks/` folder, which exists to give a distinct, recognizable name to each task in System Settings and elsewhere.

It's default launchctl behavior to dedupe task runs missed during sleep.

`run-task.sh` executes the command and appends to the task's logfile in the `logs/` folder.
