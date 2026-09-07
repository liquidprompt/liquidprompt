
# Error on unset variables
set -u

if [ -n "${ZSH_VERSION-}" ]; then
  SHUNIT_PARENT="$0"
  setopt shwordsplit ksh_arrays
fi

. ../liquidprompt --no-activate

typeset -a temp_outputs temp_values

# Add test cases to these arrays like below
# Output of iSMC temp --output influx

temp_outputs=("")
temp_values=("")

# Darwin 25.6.0 Darwin Kernel Version 25.6.0: Fri Jul 31 19:18:49 PDT 2026; root:xnu-12377.161.14~5/RELEASE_ARM64_T6000 arm64 M1
# Truncated
temp_outputs+=(
"airflow_left,sensortype=temperature,unit=c,key=talp value=36.112625 1789052902032487000
airport_1,sensortype=temperature,unit=c,key=tw0p value=36.38289 1789052902032487000
ambient_outside_lid,sensortype=temperature,unit=c,key=taol value=24.1875 1789052902032487000
ambient_top_proximity,sensortype=temperature,unit=c,key=tatp value=37.88739 1789052902032487000
battery_1,sensortype=temperature,unit=c,key=tb0t value=28 1789052902032487000
board_diode_battery_proximity,sensortype=temperature,unit=c,key=tdbp value=26.9375 1789052902032487000
cpu_die_1,sensortype=temperature,unit=c,key=te00 value=38.470314 1789052902032487000
cpu_die_2,sensortype=temperature,unit=c,key=te01 value=51.828316 1789052902032487000
cpu_die_3,sensortype=temperature,unit=c,key=te02 value=57.791878 1789052902032487000
cpu_die_aggregate,sensortype=temperature,unit=c,key=tcdx value=41.067356 1789052902032487000
cpu_die_average,sensortype=temperature,unit=c,key=tcmb value=51.828316 1789052902032487000
cpu_die_max,sensortype=temperature,unit=c,key=tcmz value=57.791878 1789052902032487000
cpu_efficiency_core_1,sensortype=temperature,unit=c,key=tp0a value=50.01675 1789052902032487000
cpu_efficiency_core_2,sensortype=temperature,unit=c,key=tp0u value=48.987877 1789052902032487000
cpu_heatpipe,sensortype=temperature,unit=c,key=tchp value=34.715332 1789052902032487000
cpu_performance_core_1,sensortype=temperature,unit=c,key=tp02 value=51.310875 1789052902032487000
cpu_performance_core_2,sensortype=temperature,unit=c,key=tp06 value=50.072876 1789052902032487000
cpu_performance_core_3,sensortype=temperature,unit=c,key=tp0e value=51.466873 1789052902032487000
cpu_performance_core_4,sensortype=temperature,unit=c,key=tp0i value=50.410873 1789052902032487000
cpu_performance_core_5,sensortype=temperature,unit=c,key=tp0m value=47.934624 1789052902032487000
cpu_performance_core_6,sensortype=temperature,unit=c,key=tp0q value=49.987877 1789052902032487000
cpu_performance_core_7,sensortype=temperature,unit=c,key=tp0y value=51.98225 1789052902032487000
cpu_performance_core_8,sensortype=temperature,unit=c,key=tp0c value=50.0545 1789052902032487000
gpu_1,sensortype=temperature,unit=c,key=tg05 value=45.846413 1789052902032487000
gpu_2,sensortype=temperature,unit=c,key=tg0d value=44.858566 1789052902032487000
gpu_3,sensortype=temperature,unit=c,key=tg0l value=47.264236 1789052902032487000
gpu_4,sensortype=temperature,unit=c,key=tg0t value=46.520603 1789052902032487000
gpu_heatsink_1,sensortype=temperature,unit=c,key=tg0h value=28 1789052902032487000
gpu_probe_b_1,sensortype=temperature,unit=c,key=tg0b value=28 1789052902032487000
gpu_probe_b_2,sensortype=temperature,unit=c,key=tg1b value=28 1789052902032487000
gpu_probe_b_3,sensortype=temperature,unit=c,key=tg2b value=27.799988 1789052902032487000
gpu_probe_c_1,sensortype=temperature,unit=c,key=tg0c value=27 1789052902032487000
gpu_probe_v_1,sensortype=temperature,unit=c,key=tg0v value=28 1789052902032487000
memory_1,sensortype=temperature,unit=c,key=tm02 value=38.21875 1789052902032487000
nand,sensortype=temperature,unit=c,key=th0x value=31.097656 1789052902032487000
nand_ch0_temp,sensortype=temperature,unit=c,key=temp value=29 1789052902032487000
nvme_1_(a),sensortype=temperature,unit=c,key=th0a value=29.828125 1789052902032487000
pmu_tp0s,sensortype=temperature,unit=c,key=tp0s value=36.330414 1789052902032487000
power_delivery_ic_1,sensortype=temperature,unit=c,key=tpd0 value=36.330414 1789052902032487000
power_management_proximity,sensortype=temperature,unit=c,key=tpmp value=35.441452 1789052902032487000
power_probe_voltage_diode,sensortype=temperature,unit=c,key=tpvd value=37.22839 1789052902032487000
power_supply_proximity,sensortype=temperature,unit=c,key=tpsp value=37.040543 1789052902032487000
rf_delivery_1,sensortype=temperature,unit=c,key=trd0 value=39.172012 1789052902032487000
rf_probe_1,sensortype=temperature,unit=c,key=tr1d value=37.04506 1789052902032487000
rf_reference,sensortype=temperature,unit=c,key=tr0z value=51.850006 1789052902032487000
ssd_1,sensortype=temperature,unit=c,key=ts02 value=39.375 1789052902032487000
ssd_controller,sensortype=temperature,unit=c,key=ts1p value=25.996094 1789052902032487000
ssd_proximity_1,sensortype=temperature,unit=c,key=ts0p value=35.81082 1789052902032487000
soc_heatsink_1,sensortype=temperature,unit=c,key=th02 value=45.84375 1789052902032487000
soc_regulator_v,sensortype=temperature,unit=c,key=tsvr value=36.373886 1789052902032487000
soc_thermal_diode_cluster_1_probe_1,sensortype=temperature,unit=c,key=td00 value=23.723488 1789052902032487000
thunderbolt_left_proximity,sensortype=temperature,unit=c,key=talt value=29.494095 1789052902032487000
virtual_ambient_1,sensortype=temperature,unit=c,key=tva0 value=24.362082 1789052902032487000
virtual_die_1,sensortype=temperature,unit=c,key=tvd0 value=51.828316 1789052902032487000
virtual_sensor_1,sensortype=temperature,unit=c,key=tvs0 value=32.819897 1789052902032487000
virtual_voltage,sensortype=temperature,unit=c,key=tvv0 value=40.836002 1789052902032487000
gas_gauge_battery,sensortype=temperature,unit=c,key=battery value=28 1789052902032487000"
)
temp_values+=("57")

# Darwin 22.6.0 Darwin Kernel Version 22.6.0: Tue Jul 15 08:22:28 PDT 2025; root:xnu-8796.141.3.713.2~2/RELEASE_X86_64 x86_64 Intel
temp_outputs+=(
"airport_1,sensortype=temperature,unit=c,key=tw0p value=60.4375 1789169343970828000
ambient_air_1,sensortype=temperature,unit=c,key=ta0v value=22.828125 1789169343970828000
battery_1,sensortype=temperature,unit=c,key=tb0t value=32.5 1789169343970828000
battery_2,sensortype=temperature,unit=c,key=tb1t value=30.097656 1789169343970828000
battery_3,sensortype=temperature,unit=c,key=tb2t value=32.5 1789169343970828000
cpu_core_2,sensortype=temperature,unit=c,key=tc1c value=94 1789169343970828000
cpu_core_3,sensortype=temperature,unit=c,key=tc2c value=96 1789169343970828000
cpu_core_4,sensortype=temperature,unit=c,key=tc3c value=92 1789169343970828000
cpu_core_5,sensortype=temperature,unit=c,key=tc4c value=96 1789169343970828000
cpu_diode_filtered_1,sensortype=temperature,unit=c,key=tc0f value=92.48828 1789169343970828000
cpu_diode_virtual_1,sensortype=temperature,unit=c,key=tc0e value=89.85547 1789169343970828000
cpu_proximity_1,sensortype=temperature,unit=c,key=tc0p value=69.0625 1789169343970828000
disk_1_(a),sensortype=temperature,unit=c,key=th0a value=45.25 1789169343970828000
disk_1_(b),sensortype=temperature,unit=c,key=th0b value=42.125 1789169343970828000
disk_1_(c),sensortype=temperature,unit=c,key=th0c value=42.75 1789169343970828000
gpu_amd_radeon,sensortype=temperature,unit=c,key=tgdd value=64 1789169343970828000
gpu_diode_1,sensortype=temperature,unit=c,key=tg0d value=35 1789169343970828000
gpu_intel_graphics,sensortype=temperature,unit=c,key=tcgc value=81 1789169343970828000
gpu_proximity_1,sensortype=temperature,unit=c,key=tg0p value=64.4375 1789169343970828000
heatpipe_2,sensortype=temperature,unit=c,key=th1h value=54.25 1789169343970828000
heatpipe_3,sensortype=temperature,unit=c,key=th2h value=67.25 1789169343970828000
memory_proximity_1,sensortype=temperature,unit=c,key=tm0p value=60.375 1789169343970828000
nvme_1_(a),sensortype=temperature,unit=c,key=th0a value=45.25 1789169343970828000
nvme_1_(b),sensortype=temperature,unit=c,key=th0b value=42.125 1789169343970828000
nvme_1_(c),sensortype=temperature,unit=c,key=th0c value=42.75 1789169343970828000
system_agent,sensortype=temperature,unit=c,key=tcsa value=85 1789169343970828000
thunderbolt_left,sensortype=temperature,unit=c,key=ttld value=45.875 1789169343970828000
thunderbolt_right,sensortype=temperature,unit=c,key=ttrd value=38.875 1789169343970828000"
)
temp_values+=("94")

function test_iSMC_temperature {

  LP_ENABLE_TEMP=1
  _LP_LINUX_TEMPERATURE_FILES=("")
  LP_TEMP_THRESHOLD=-1000000

  iSMC() {
    printf '%s\n' "$__temp_output"
  }
  # Stub needed to test iSMC with no output.
  acpi() { :; }
  sensors() { :; }
  smctemp() { :; }

  typeset valid

  for (( index=0; index < ${#temp_values[@]}; index++ )); do
    __temp_output=${temp_outputs[$index]}
    unset lp_temperature
    __lp_temp_iSMC
    assertEquals "iSMC temperature output at index ${index}" "${temp_values[$index]}" "${lp_temperature-}"

    if [[ -n ${temp_values[$index]} ]]; then
      valid=0
    else
      valid=1
    fi

    __lp_temp_detect
    assertEquals "iSMC temperature detect at index ${index}" "$valid" "$?"

    # Set the temp function in case the above detect said it was invalid.
    # While we should never be in this situation, might as well make sure
    # it doesn't crash.
    _LP_TEMP_FUNCTION=__lp_temp_iSMC

    # This is to test that _lp_temperature() ignores previous high values
    lp_temperature=10000

    _lp_temperature
    assertEquals "iSMC temperature return at index ${index}" "$valid" "$?"
    assertEquals "iSMC temperature return output at index ${index}" "${temp_values[$index]}" "${lp_temperature-}"
  done
}

. ./shunit2
