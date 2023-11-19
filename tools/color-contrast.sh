#!/bin/bash

# ANSI 256 colors index to [0,255] RGB 3-tuple.
function ansi2rgb() # ansi_color_index -> RGB array
{
    local ansi
    ansi=${1-}
    if [[ -z "$ansi" ]]; then
        return 1
    fi

    local R G B

    if [[ "$ansi" -ge 232 && "$ansi" -le 255 ]]; then
        # Greyscale.
        R=$(( ( ansi - 232 ) * 10 + 8 ))
        G=$R
        B=$R

    elif [[ "$ansi" -ge 0 && "$ansi" -le "15" ]]; then
        # Default 16-bits colors.
        local -a ansi_16
        ansi_16=( "0 0 0" "128 0 0" "0 128 0" "128 128 0" "0 0 128" "128 0 128" "0 128 128" "192 192 192" "80 80 80" "255 0 0" "0 255 0" "255 255 0" "0 0 255" "255 0 255" "0 255 255" "255 255 255" )
        read -r R G B <<< "${ansi_16[$ansi]}"

    else
        # Color cube.
        local iR iG iB

        iR=$(( (ansi - 16) / 36 ))
        if [[ "$iR" -gt 0 ]]; then
            R=$(( 55 + iR * 40 ))
        else
            R=0
        fi

        iG=$(( (ansi - 16) % 36 / 6 ))
        if [[ "$iG" -gt 0 ]]; then
            G=$(( 55 + iG * 40 ))
        else
            G=0
        fi

        iB=$(( (ansi - 16) % 6 ))
        if [[ "$iB" -gt 0 ]]; then
            B=$(( 55 + iB * 40 ))
        else
            B=0
        fi
    fi
    RGB=( "$R" "$G" "$B" )
}

# Math hack to have the power function not existing in bc, computes value^power.
function pow() # value power -> pow
{
    local value=$1
    local power=$2
    pow=$( bc -l <<< "e(($power) * l($value))" )
}

# Linearize an RGB component.
# TODO: 
function lum() # decimal_component -> lum
{
    local dC
    dC=${1}
    # if (( $( bc -l <<< "$dC <= 0.04045" ) )); then # https://stackoverflow.com/a/56678483
    if (( $( bc -l <<< "$dC <= 0.03928" ) )); then # https://www.w3.org/TR/WCAG20/#relativeluminancedef
        lum=$( bc -l <<< "$dC / 12.92" )
    else
        local val
        val=$( bc -l <<< "($dC + 0.055) / 1.055" )
        pow $val 2.4
        lum=$pow
    fi
}

# RGB linear (relative) luminance.
function luminance() # ( R G B ) -> luminance
{
    local RGB
    R=${1}
    G=${2}
    B=${3}

    # Components in [0,1].
    dR=$( bc -l <<< "$R / 255" )
    dG=$( bc -l <<< "$G / 255" )
    dB=$( bc -l <<< "$B / 255" )

    # Linearizations.
    local lR
    lum $dR
    lR=$lum

    local lG
    lum $dG
    lG=$lum

    local lB
    lum $dB
    lB=$lum

    # Spectral weighting.
    luminance=$( bc -l <<< "0.2126 * $lR + 0.7152 * $lG + 0.0722 * $lB" )
}

# Round with the given precision.
function round() # value precision
{
    val=$1
    prec=${2-1}
    export LC_NUMERIC="en_US.UTF-8"
    printf %.${prec}f $(echo "scale=$prec;(((10^$prec)*$val)+0.5)/(10^$prec)" | bc)
}

# Perceived lightness in [0,100] (i.e. [darkest,lightest]).
function lightness() # luminance -> lightness
{
    local luminance
    luminance=${1}
    if (( $( bc -l <<< "$luminance < 216/24389" ) )); then
        lightness=$( bc -l <<< "($luminance * 24389/27)" )
    else
        pow $luminance 1/3
        lightness=$( bc -l <<< "($pow * 116 - 16)" )
    fi
}

# Contrast of two luminances.
function luminance_contrast() # L1 L2 -> luminance_contrast
{
    local L1
    L1=$1

    local L2
    L2=$2

    # L1 should always be the lighter color.
    if (( $( bc -l <<< "$L1 < $L2" ) )); then
        local l2
        l2=$L2
        L2=$L1
        L1=$l2
    fi

    luminance_contrast=$( bc -l <<< "($L1 + 0.05) / ($L2 + 0.05)" )
}

# Luminance contrast of two ANSI 256 colors.
function contrast() # ansi_1 ansi_2 -> contrast
{
    local L1
    ansi=${1}
    ansi2rgb $ansi
    luminance ${RGB[*]}
    L1=$luminance

    local L2
    ansi=${2}
    ansi2rgb $ansi
    luminance ${RGB[*]}
    L2=$luminance

    luminance_contrast $L1 $L2
    contrast=$luminance_contrast
}

# Luminance contrast to W3C contrast level (AAA, AA or A).
function contrast_level() # contrast -> contrast_level
{
    if (( $( bc <<< "$1 >= 7" ) )); then
        contrast_level="AAA"
    elif (( $( bc <<< "$1 >= 4" ) )); then
        contrast_level="AA"
    else
        contrast_level="A"
    fi
}

# Print some information about the given ANSI 256 color.
function print_info() # ansi_color
{
    ansi=${1}
    echo "ANSI: $ansi"

    if [[ "$ansi" -ge 0 && "$ansi" -le "15" ]]; then
        echo "Warning: this color may appear different on screen, depending on your terminal configuration."
    fi

    ansi2rgb $ansi
    echo "RGB: ${RGB[*]}"

    luminance ${RGB[*]}
    echo "Luminance: $luminance"

    lightness $luminance
    echo "Perceived lightness: $lightness"
}

function along_hori() # start width [padding=0]
{
    local sep
    sep="—"
    local start width padding
    start=$1
    width=$2
    padding=${3-0}

    if [[ $padding -lt 1 ]]; then
        padding=1
    fi

    along_hori=""
    for _ in $( seq 0 $((padding-1)) ); do
        along_hori+="${sep}_"
    done
    for s in $( seq $start $((start+width-1)) ); do
        along_hori+=$(printf "$sep%d" "$s")
    done
    for _ in $( seq 0 $((padding-1)) ); do
        along_hori+="${sep}_"
    done
}

function along_vert() # start width height [padding=0]
{
    local sep
    sep="|"
    local start width height padding
    start=$1
    width=$2
    height=$3
    padding=${4-0}

    along_vert=""
    for s in $( seq $start $width $((start+width*height-1)) ); do
        along_hori $s $width $padding
        along_vert+="$sep$along_hori"
    done
}

# Foreground.
function fg() # fg
{
    printf "\033[38;5;${1}m"
}

# Background.
function bg() # bg
{
    printf "\033[48;5;${1}m"
}

# High-contrast foreground on background.
function hbg() # bg
{
    ansi2rgb $1
    luminance ${RGB[*]}
    lightness $luminance
    if (( $(bc <<< "$lightness >= 50" ) )); then
        # Black on bg
        printf "\033[38;5;0m\033[48;5;${1}m"
    else
        # White on bg
        printf "\033[38;5;15m\033[48;5;${1}m"
    fi
}

# First color as foreground, second as background.
function fbg() # fg bg
{
    printf "\033[38;5;${1}m\033[48;5;${2}m"
}

# First color as background, second as foreground.
function bfg() # bg fg
{
    printf "\033[38;5;${2}m\033[48;5;${1}m"
}

# Print a color block.
function print_block() # how panel [contrast_min=7 [contrast_ref=""]]
{
    local how contrast_min contrast_ref
    how=${1}
    local -a panel
    read -ra panel <<< "${2}"
    contrast_min=${3-7}
    contrast_ref=${4-""}

    IFS='—' read -ra items <<< "${panel[*]}"
    for i in ${items[@]}; do
        if [[ "$i" == "_" ]]; then
            printf " "
        else
            if [[ -n "$contrast_ref" ]]; then
                contrast $i $contrast_ref
                if (( $( bc <<< "$contrast >= $contrast_min" ) )); then
                    printf "%s %03d%s" "$($how $i $contrast_ref)" "${i}" "${no}"
                else
                    # printf " %03d" "$(round $contrast 0)"
                    printf " ···"
                fi
            else
                printf "%s %03d%s" "$($how $i $contrast_ref)" "${i}" "${no}"
            fi
        fi
    done

}

# Print columns of color panels.
function print_panel() # along [contrast_min=7 [contrast_ref=""]]
{
    local along contrast_min contrast_ref
    along="$1"
    contrast_min=${2-7}
    contrast_ref=${3-""}

    IFS='|' read -ra panels <<< "$along"
    for panel in ${panels[@]}; do
        print_block "fg" "${panel[@]}" $contrast_min $contrast_ref
        printf "\t"
        if [[ -n "$contrast_ref" ]]; then
            print_block "bfg" "${panel[@]}" $contrast_min $contrast_ref
            printf "\t"
            print_block "fbg" "${panel[@]}" $contrast_min $contrast_ref
        else
            print_block "hbg" "${panel[@]}" $contrast_min $contrast_ref
        fi
        printf "\n"
    done
}

# Print the three panels of ANSI.
function print_ansi() # [contrast_min=7 [contrast_ref=""]]
{
    contrast_min=${1-7}
    contrast_ref=${2-""}
    no=$'\033[0m'

    # 16 core colors.
    along_vert 0 8 2
    print_panel "$along_vert" $contrast_min $contrast_ref

    # Color cube.
    along_vert 16 6 $((6*6)) 5
    print_panel "$along_vert" $contrast_min $contrast_ref

    # Grey scale.
    along_vert $((16+6*6*6)) 8 3
    print_panel "$along_vert" $contrast_min $contrast_ref

}

# No color passed => print the two fg & bg ANSI tables.
if [[ $# -eq 0 ]]; then
    print_ansi

# One color passed => print three ANSI tables filtered by two contrast levels.
elif [[ $# -eq 1 ]]; then
    print_info $1
    echo "--"

    no=$'\033[0m'
    printf "fg1    : $(fg $1)Logoden biniou degemer mat${no}\n"
    printf "    bg1: $(bg $1)Mederieg mel dlead keit ur${no}\n"
    printf " HC/bg1: $(hbg $1)Pempoull vro pomper lezenn${no}\n"
    echo "--"

    echo "Compatible level AAA:"
    print_ansi 7 $1
    echo "--"

    echo "Compatible level AA:"
    print_ansi 4 $1

# Two colors passed => print the contrast level and exit on error if below AAA.
elif [[ $# -eq 2 ]]; then
    print_info $1
    echo "--"
    print_info $2
    echo "--"

    no=$'\033[0m'
    printf "fg1/bg2: $(fg $1)$(bg $2)Logoden biniou degemer mat${no}\n"
    printf "fg2/bg1: $(fg $2)$(bg $1)C’houevr Oskaleg d’a pakad${no}\n"
    printf "fg1    : $(fg $1)An penn ar bed egistomp ur${no}\n"
    printf "fg2    : $(fg $2)lakaat leue dir rumm Malo!${no}\n"
    printf "    bg1: $(bg $1)Mederieg mel dlead keit ur${no}\n"
    printf "    bg2: $(bg $2)Gwened broustañ eno sal an${no}\n"
    printf " HC/bg1: $(hbg $1)Pempoull vro pomper lezenn${no}\n"
    printf " HC/bg2: $(hbg $2)Seitek da beajourien zoken${no}\n"
    echo "--"

    contrast $1 $2
    contrast_level $contrast
    echo "Contrast: $(round $contrast):1 ($contrast_level)"
    if [[ "$contrast_level" == "AAA" ]]; then
        exit 0
    elif [[ "$contrast_level" == "AA" ]]; then
        exit 1
    else
        exit 2
    fi
fi
