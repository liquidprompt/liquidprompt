#!/usr/bin/env bash

if ! command -v xtermcontrol 1> /dev/null; then
    printf '\033[1;31mRequirement Error\033[0m:\n'
    printf '  - xtermcontrol not found\n'
fi

declare -a colors
for i in {0..15}; do
    color=$(xtermcontrol --get-color"$i")
    colors["$i"]=$(printf '#%s%s%s' "${color:4:2}" "${color:9:2}" "${color:14:2}")
done

real_path=$(realpath "$0" | sed 's|\(.*\)/.*|\1|')

if [[ -f "$real_path/xcolors2hexTable.json" ]]; then
    for i in {0..15}; do
        sed -i -r "s/(.color${i}.: .)#....../\1${colors[$i]}/" xcolors2hexTable.json
    done
fi

if [[ -f "$real_path/lpcolorsFg2hexTable.json" ]]; then
    for i in {0..15}; do
        sed -i -r "s/(.lp_terminal_format ${i}.: .)#....../\1${colors[$i]}/" lpcolorsFg2hexTable.json
    done
fi

if [[ -f "$real_path/lpcolorsFg2hexTable.json" ]]; then
    for i in {0..15}; do
        sed -i -r "s/(.lp_terminal_format -?. ${i}.: .)#....../\1${colors[$i]}/" lpcolorsBg2hexTable.json
    done
fi

