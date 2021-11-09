# Error on unset variables
set -u

# Load Linux version of _lp_battery()
uname() { printf 'Linux'; }

. ../liquidprompt --no-activate
unset -f uname

LP_ENABLE_BATT=1
_LP_BATTERY_FUNCTION=__lp_battery_sysfs

typeset -a battery_types battery_presents battery_status battery_capacities battery_out_statuses battery_values

# Add test cases to these arrays like below

# Empty ("") means file doesn't exist

# Linux 5.11.0-38-generic #42~20.04.1-Ubuntu SMP Tue Sep 28 20:41:07 UTC 2021 x86_64 x86_64 x86_64 GNU/Linux
battery_types+=("Battery")
battery_presents+=("1")
battery_statuses+=("Discharging")
battery_capacities+=("67")
battery_out_statuses+=(0)
battery_values+=("67")
battery_scopes+=("")

# Full, not charging
battery_types+=("Battery")
battery_presents+=("")
battery_statuses+=("")
battery_capacities+=("")
battery_out_statuses+=(4)
battery_values+=("")
battery_scopes+=("System")

# Not a battery
battery_types+=("Mains")
battery_presents+=("")
battery_statuses+=("")
battery_capacities+=("")
battery_out_statuses+=(4)
battery_values+=("")
battery_scopes+=("")

# Wrong type of battery battery (Wireless mouse, some other)
battery_types+=("Battery")
battery_presents+=("1")
battery_statuses+=("")
battery_capacities+=("0")
battery_out_statuses+=(4)
battery_values+=("")
battery_scopes+=("Device")


test_sysfs_battery() {
  _LP_LINUX_POWERSUPPLY_PATH=$(mktemp -d)
  for (( index=0; index < ${#battery_values[@]}; index++ )); do
    _LP_LINUX_POWERSUPPLY_PATH_DEVICE="${_LP_LINUX_POWERSUPPLY_PATH}/${index}"
    mkdir "${_LP_LINUX_POWERSUPPLY_PATH_DEVICE}"

    if [[ -n ${battery_types[index]-} ]]; then
      printf '%s' "${battery_types[index]}" > "${_LP_LINUX_POWERSUPPLY_PATH_DEVICE}/type"
    fi
    if [[ -n ${battery_presents[index]-} ]]; then
      printf '%s' "${battery_presents[index]}" > "${_LP_LINUX_POWERSUPPLY_PATH_DEVICE}/present"
    fi
    if [[ -n ${battery_statuses[index]-} ]]; then
      printf '%s' "${battery_statuses[index]}" > "${_LP_LINUX_POWERSUPPLY_PATH_DEVICE}/status"
    fi
    if [[ -n ${battery_capacities[index]-} ]]; then
      printf '%s' "${battery_capacities[index]}" > "${_LP_LINUX_POWERSUPPLY_PATH_DEVICE}/capacity"
    fi
    if [[ -n ${battery_scopes[index]} ]]; then
      printf '%s' "${battery_scopes[index]}" > "${_LP_LINUX_POWERSUPPLY_PATH_DEVICE}/scope"
    fi

    LP_BATTERY_THRESHOLD=100
    _lp_battery
    assertEquals "sysfs battery below returns at index ${index}" "${battery_out_statuses[$index]}" "$?"
    assertEquals "sysfs battery value at index ${index}" "${battery_values[$index]}" "${lp_battery-}"

    _status=${battery_out_statuses[$index]}
    (( _status < 4 )) && _status=$(( _status + 1 ))

    LP_BATTERY_THRESHOLD=0
    _lp_battery
    assertEquals "sysfs battery above returns at index ${index}" "$_status" "$?"
    assertEquals "sysfs battery value at index ${index}" "${battery_values[$index]}" "${lp_battery-}"

    rm -r "$_LP_LINUX_POWERSUPPLY_PATH_DEVICE"
  done
  rm -r "$_LP_LINUX_POWERSUPPLY_PATH"
}

if [ -n "${ZSH_VERSION-}" ]; then
  SHUNIT_PARENT="$0"
  setopt shwordsplit ksh_arrays
fi

. ./shunit2
