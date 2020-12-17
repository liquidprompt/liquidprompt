#!/bin/sh

# Do NOT error on failed commands
set +e

test_tool() {
  local stderr
  printf '\nCommand: "%s"\n--------stdout--------\n' "$*"
  { stderr="$( { "$@"; } 2>&1 1>&3 3>&- )"; } 3>&1
  printf '\n--------stderr--------\n%s\n----------------------\nReturn code: "%s"\n' "$stderr" "$?"
}

# Export needed variables
export LC_ALL=C

# Print uname
printf 'Uname:\n'
uname -a

test_tool uname

hostname_cksum() {
  hostname | cksum
}
test_tool hostname_cksum

test_tool tput sgr0
test_tool tput me
test_tool tput bold
test_tool tput md
test_tool tput smul
test_tool tput us
test_tool tput colors
test_tool tput setaf 0
test_tool tput AF 0
test_tool tput AF 0 0 0
test_tool tput setab 0
test_tool tput AB 0
test_tool tput AB 0 0 0

test_tool who am i
test_tool ps -o comm= -p "$PPID"
test_tool logname

test_tool screen -ls
test_tool tmux list-sessions

test_tool acpi --battery
test_tool pmset -g batt

test_tool nproc
# Not actually a command used, we read directly from the file
test_tool cat /proc/loadavg
test_tool sysctl -n hw.ncpu
test_tool sysctl -n vm.loadavg
test_tool kstat -m cpu_info
test_tool uptime

test_tool sensors -u
test_tool acpi -t

test_tool date '+%I %M'
test_tool tty
test_tool basename -- /dev/pts/0
