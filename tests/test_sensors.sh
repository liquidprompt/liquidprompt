
# Error on unset variables
set -u

. ../liquidprompt --no-activate

typeset -a outputs values

# Add test cases to these arrays like below

# Linux 4.18.0-193.19.1.el8_2.x86_64 #1 SMP Mon Sep 14 14:37:00 UTC 2020 x86_64 GNU/Linux CentOS Linux release 8.2.2004 (Core)
outputs+=(
"k10temp-pci-00c3
Adapter: PCI adapter
CPU:
  temp1_input: 15.000
  temp1_max: 70.000
  temp1_crit: 75.000
  temp1_crit_hyst: 74.000

acpitz-virtual-0
Adapter: Virtual device
temp1:
  temp1_input: 25.000
  temp1_crit: 80.000

radeon-pci-0008
Adapter: PCI adapter
temp1:
  temp1_input: 12.000
  temp1_crit: 120.000
  temp1_crit_hyst: 90.000"
)
values+=(25)


function test_sensors {

  sensors() {
    printf '%s\n' "$__output"
  }

  for (( index=0; index < ${#values[@]}; index++ )); do
    __output=${outputs[$index]}
    __lp_temp_sensors
    assertEquals "Sensors temperature output" "${values[$index]}" "$lp_temperature"
  done
}

if [ -n "${ZSH_VERSION-}" ]; then
  SHUNIT_PARENT="$0"
  setopt shwordsplit ksh_arrays
fi

. ./shunit2
