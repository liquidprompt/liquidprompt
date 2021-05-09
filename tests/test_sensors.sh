
# Error on unset variables
set -u

. ../liquidprompt --no-activate

typeset -a outputs values

# Add test cases to these arrays like below

# No output
outputs+=("")
values+=("")

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

# Linux 5.4.0-58-generic #64-Ubuntu SMP Wed Dec 9 08:16:25 UTC 2020 x86_64 GNU/Linux Ubuntu 20.04.1 LTS
outputs+=(
"ath10k_hwmon-pci-0200
Adapter: PCI adapter
temp1:
  temp1_input: 47.000

coretemp-isa-0000
Adapter: ISA adapter
Package id 0:
  temp1_input: 68.000
  temp1_max: 100.000
  temp1_crit: 100.000
  temp1_crit_alarm: 0.000
Core 0:
  temp2_input: 68.000
  temp2_max: 100.000
  temp2_crit: 100.000
  temp2_crit_alarm: 0.000
Core 1:
  temp3_input: 67.000
  temp3_max: 100.000
  temp3_crit: 100.000
  temp3_crit_alarm: 0.000
Core 2:
  temp4_input: 66.000
  temp4_max: 100.000
  temp4_crit: 100.000
  temp4_crit_alarm: 0.000
Core 3:
  temp5_input: 65.000
  temp5_max: 100.000
  temp5_crit: 100.000
  temp5_crit_alarm: 0.000

BAT0-acpi-0
Adapter: ACPI interface
in0:
  in0_input: 12.642
curr1:
  curr1_input: 0.001

dell_smm-virtual-0
Adapter: Virtual device
fan1:
  fan1_input: 4921.000
fan2:
  fan2_input: 4921.000

pch_skylake-virtual-0
Adapter: Virtual device
temp1:
  temp1_input: 55.500

acpitz-acpi-0
Adapter: ACPI interface
temp1:
  temp1_input: 25.000
  temp1_crit: 107.000
"
)
values+=(68)

# Linux 4.9.0-13-amd64 #1 SMP Debian 4.9.228-1 (2020-07-05) x86_64 GNU/Linux Debian 9.13 (stretch)
outputs+=(
"coretemp-isa-0000
Adapter: ISA adapter
Physical id 0:
  temp1_input: 51.000
  temp1_max: 74.000
  temp1_crit: 94.000
  temp1_crit_alarm: 0.000
Core 0:
  temp2_input: 46.000
  temp2_max: 74.000
  temp2_crit: 94.000
  temp2_crit_alarm: 0.000
Core 1:
  temp3_input: 52.000
  temp3_max: 74.000
  temp3_crit: 94.000
  temp3_crit_alarm: 0.000
Core 2:
  temp4_input: 48.000
  temp4_max: 74.000
  temp4_crit: 94.000
  temp4_crit_alarm: 0.000
Core 3:
  temp5_input: 43.000
  temp5_max: 74.000
  temp5_crit: 94.000
  temp5_crit_alarm: 0.000
"
)
values+=(52)

# Linux 4.9.78-xxxx-std-ipv6-64 #2 SMP Wed Jan 24 10:27:15 CET 2018 x86_64 GNU/Linux Debian 10 (buster)
outputs+=(
"coretemp-isa-0000
Adapter: ISA adapter
Core 0:
  temp2_input: 48.000
  temp2_crit: 100.000
  temp2_crit_alarm: 0.000
Core 1:
  temp3_input: 47.000
  temp3_crit: 100.000
  temp3_crit_alarm: 0.000

w83627dhg-isa-0290
Adapter: ISA adapter
Vcore:
  in0_input: 1.032
  in0_min: 0.000
  in0_max: 1.744
  in0_alarm: 0.000
in1:
  in1_input: 1.008
  in1_min: 2.024
  in1_max: 1.056
  in1_alarm: 1.000
AVCC:
  in2_input: 3.376
  in2_min: 2.976
  in2_max: 3.632
  in2_alarm: 0.000
+3.3V:
  in3_input: 3.376
  in3_min: 2.976
  in3_max: 3.632
  in3_alarm: 0.000
in4:
  in4_input: 1.016
  in4_min: 1.240
  in4_max: 0.232
  in4_alarm: 1.000
in5:
  in5_input: 1.512
  in5_min: 1.760
  in5_max: 0.576
  in5_alarm: 1.000
in6:
  in6_input: 1.080
  in6_min: 0.664
  in6_max: 0.048
  in6_alarm: 1.000
3VSB:
  in7_input: 3.392
  in7_min: 2.976
  in7_max: 3.632
  in7_alarm: 0.000
Vbat:
  in8_input: 3.264
  in8_min: 2.704
  in8_max: 3.632
  in8_alarm: 0.000
fan1:
  fan1_input: 0.000
  fan1_min: 10546.000
  fan1_alarm: 1.000
  fan1_div: 128.000
fan2:
  fan2_input: 0.000
  fan2_min: 10546.000
  fan2_alarm: 1.000
  fan2_div: 128.000
fan3:
  fan3_input: 0.000
  fan3_min: 10546.000
  fan3_alarm: 1.000
  fan3_div: 128.000
fan4:
  fan4_input: 0.000
  fan4_min: 10546.000
  fan4_alarm: 1.000
  fan4_div: 128.000
fan5:
  fan5_input: 0.000
  fan5_min: 10546.000
  fan5_alarm: 1.000
  fan5_div: 128.000
temp1:
  temp1_input: 44.000
  temp1_max: 3.000
  temp1_max_hyst: 64.000
  temp1_alarm: 0.000
  temp1_type: 1.000
  temp1_offset: 0.000
temp3:
  temp3_input: 44.500
  temp3_max: 80.000
  temp3_max_hyst: 75.000
  temp3_alarm: 0.000
  temp3_type: 1.000
  temp3_offset: 0.000
cpu0_vid:
  cpu0_vid: 0.000
intrusion0:
  intrusion0_alarm: 1.000
"
)
values+=(48)


function test_sensors {

  LP_ENABLE_TEMP=1
  LP_TEMP_THRESHOLD=-1000000

  sensors() {
    printf '%s\n' "$__output"
  }

  for (( index=0; index < ${#values[@]}; index++ )); do
    __output=${outputs[$index]}
    unset lp_temperature
    __lp_temp_sensors
    assertEquals "Sensors temperature output at index ${index}" "${values[$index]}" "${lp_temperature-}"

    if [[ -n ${values[$index]} ]]; then
      valid=0
    else
      valid=1
    fi

    __lp_temp_detect sensors
    assertEquals "Sensors temperature detect at index ${index}" "$valid" "$?"

    # Set the temp function in case the above detect said it was invalid.
    # While we should never be in this situation, might as well make sure
    # it doesn't crash.
    _LP_TEMP_FUNCTION=__lp_temp_sensors
    unset lp_temperature
    _lp_temperature
    assertEquals "Sensors temperature return at index ${index}" "$valid" "$?"
    assertEquals "Sensors temperature return output at index ${index}" "${values[$index]}" "${lp_temperature-}"
  done
}

if [ -n "${ZSH_VERSION-}" ]; then
  SHUNIT_PARENT="$0"
  setopt shwordsplit ksh_arrays
fi

. ./shunit2
