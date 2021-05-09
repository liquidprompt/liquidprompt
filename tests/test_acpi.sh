
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
battery_outputs+=(
"Battery 0: Discharging, 55%, 01:39:34 remaining"
)
battery_statuses+=(0)
battery_values+=(55)
temp_outputs+=(
"Thermal 0: ok, -267.8 degrees C"
)
temp_values+=(-267)

# VPS at OVH
temp_outputs+=(
""
)
temp_values+=("")

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

  LP_ENABLE_TEMP=1
  LP_TEMP_THRESHOLD=-1000000

  acpi() {
    printf '%s\n' "$__temp_output"
  }

  local valid

  for (( index=0; index < ${#temp_values[@]}; index++ )); do
    __temp_output=${temp_outputs[$index]}
    unset lp_temperature
    __lp_temp_acpi
    assertEquals "ACPI temperature output at index ${index}" "${temp_values[$index]}" "${lp_temperature-}"

    if [[ -n ${temp_values[$index]} ]]; then
      valid=0
    else
      valid=1
    fi

    __lp_temp_detect acpi
    assertEquals "ACPI temperature detect at index ${index}" "$valid" "$?"

    # Set the temp function in case the above detect said it was invalid.
    # While we should never be in this situation, might as well make sure
    # it doesn't crash.
    _LP_TEMP_FUNCTION=__lp_temp_acpi
    unset lp_temperature
    _lp_temperature
    assertEquals "ACPI temperature return at index ${index}" "$valid" "$?"
    assertEquals "ACPI temperature return output at index ${index}" "${temp_values[$index]}" "${lp_temperature-}"
  done
}

if [ -n "${ZSH_VERSION-}" ]; then
  SHUNIT_PARENT="$0"
  setopt shwordsplit ksh_arrays
fi

. ./shunit2
