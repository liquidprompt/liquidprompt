
# Error on unset variables
set -u

# Load Linux version of _lp_battery()
uname() { printf 'Linux'; }

. ../liquidprompt --no-activate
unset -f uname

LP_ENABLE_BATT=1

typeset -a battery_outputs battery_statuses battery_values temp_outputs temp_values

# Add test cases to these arrays like below

# Linux 4.19.0-10-amd64 #1 SMP Debian 4.19.132-1 (2020-07-24) x86_64 GNU/Linux Debian 10 (buster)
battery_outputs+=(
""
)
battery_statuses+=(4)
battery_values+=("")
temp_outputs+=(
"Thermal 0: ok, 23.0 degrees C"
)
temp_values+=(23)

# Unknown
temp_outputs+=(
"Thermal 0: ok, -267.8 degrees C"
)
temp_values+=(0)


function test_acpi_battery {

  acpi() {
    printf '%s\n' "$__battery_output"
  }

  for (( index=0; index < ${#battery_values[@]}; index++ )); do
    __battery_output=${battery_outputs[$index]}

    LP_BATTERY_THRESHOLD=100
    _lp_battery
    assertEquals "ACPI battery below returns at index ${index}" "${battery_statuses[$index]}" "$?"
    assertEquals "ACPI battery value at index ${index}" "${battery_values[$index]}" "$lp_battery"

    _status=${battery_statuses[$index]}
    (( _status < 4 )) && _status=$(( _status + 1 ))

    LP_BATTERY_THRESHOLD=0
    _lp_battery
    assertEquals "ACPI battery above returns at index ${index}" "$_status" "$?"
    assertEquals "ACPI battery value at index ${index}" "${battery_values[$index]}" "$lp_battery"
  done
}

function test_acpi_temperature {

  acpi() {
    printf '%s\n' "$__temp_output"
  }

  for (( index=0; index < ${#temp_values[@]}; index++ )); do
    __temp_output=${temp_outputs[$index]}
    local lp_temperature=0
    __lp_temp_acpi
    assertEquals "ACPI temperature output at index ${index}" "${temp_values[$index]}" "$lp_temperature"
  done
}

if [ -n "${ZSH_VERSION-}" ]; then
  SHUNIT_PARENT="$0"
  setopt shwordsplit ksh_arrays
fi

. ./shunit2
