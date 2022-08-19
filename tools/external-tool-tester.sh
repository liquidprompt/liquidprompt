#!/bin/sh

# Do NOT error on failed commands
set +e

# Don't error (or do anything) for no matching globs.
if [ -n "${ZSH_VERSION-}" ]; then
  setopt nullglob
else  # Bash
  shopt -s nullglob
fi

# Error if the output is a terminal
if [ -t 1 ]; then
  printf 'This script must be redirected to a file, or special characters will be lost
  Ex: %s > output.txt\nOr, to upload directly:
  %s | curl -F "sprunge=<-" "http://sprunge.us"\n' "$0" "$0"
  exit 1
fi

# Export needed variables
export LC_ALL=C

# Print OS info
printf -- '---Uname:\n'
uname -a
printf -- '---lpb_release:\n'
lsb_release -a 2>/dev/null || printf '<none>\n'
printf -- '---/etc/*release:\n'
cat /etc/*release 2>/dev/null </dev/null || printf '<none>\n'
printf -- '---/etc/issue*:\n'
cat /etc/issue* 2>/dev/null </dev/null || printf '<none>\n'
printf -- '---/proc/version:\n'
cat /proc/version 2>/dev/null </dev/null || printf '<none>\n'

# Sanity check to verify special characters have not been lost on upload
printf '\nSpecial character check: \a\b\t\001\r\n'

test_tool() {
  local stderr
  printf '\nCommand: "%s"\n--------stdout--------\n' "$*"
  { stderr="$( { "$@"; } 2>&1 1>&3 3>&- )"; } 3>&1
  printf '\n--------stderr--------\n%s\n----------------------\nReturn code: "%s"\n' "$stderr" "$?"
}

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

for power_supply in "/sys/class/power_supply/"*; do
  for interface in "${power_supply}/"*; do
    test_tool cat "$interface"
  done
done
test_tool acpi --battery
test_tool pmset -g batt

test_tool nproc
# Not actually a command used, we read directly from the file
test_tool cat /proc/loadavg
test_tool cat /proc/net/wireless
test_tool /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport --getinfo
test_tool sysctl -n hw.ncpu
test_tool sysctl -n vm.loadavg
test_tool kstat -m cpu_info
test_tool uptime

test_tool sensors -u
test_tool acpi -t
_LP_LINUX_TEMPERATURE_FILES=(
  /sys/class/hwmon/hwmon*/temp*_input
  # CentOS has an intermediate /device directory:
  /sys/class/hwmon/hwmon*/device/temp*_input
  /sys/devices/platform/coretemp.*/hwmon/hwmon*/temp*_input
  # Older, fallback option
  /sys/class/thermal/thermal_zone*/temp
)
for interface in ${_LP_LINUX_TEMPERATURE_FILES[@]+"${_LP_LINUX_TEMPERATURE_FILES[@]}"}; do
  test_tool cat "$interface"
done

test_tool date '+%I %M'
test_tool tty
test_tool basename -- /dev/pts/0

# shellcheck disable=SC2016
printf 'Tests complete.\nMake sure to upload the file directly, do not `cat` and copy paste!\n' >&2
