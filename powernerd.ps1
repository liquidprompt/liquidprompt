# WARNING: this require that your terminal use one of the "nerd-fonts":
# https://github.com/ryanoasis/nerd-fonts

# To use this theme, put the following lines in your .liquidpromptrc:
# LP_PS1_FILE=~/code/liquidprompt/powernerd.ps1
# source ~/code/liquidprompt/powernerd.colors

local SEP=""
# local SEP=""

# Segment separator
s() { c=$1; echo -n -e ${LP_COLOR[$c]}${SEP}; }

add() { LP_PS1="${LP_PS1}$1"; }

# Tag
LP_PS1="\n╭·${LP_PS1_PREFIX}${LP_COLOR[BLACK]}"
# Time
add "${LP_COLOR[WHITE_ON_BLACK]}${LP_TIME}$(s BLACK_ON_PURPLE)"
# Machine state
add "${LP_TEMP}${LP_BATT}${LP_LOAD}"
# Jobs
add "${LP_JOBS}$(s PURPLE_ON_GREEN)"
# User
add "${LP_COLOR[BLACK_ON_GREEN]}${LP_USER}$(s GREEN_ON_YELLOW)"
# Host
add "${LP_COLOR[BLACK_ON_YELLOW]}${LP_HOST}$(s YELLOW_ON_BLACK)"
# Permissions
add "${LP_PERM}${LP_BRACKET_CLOSE}"
# Path
add "${LP_COLOR[WHITE_ON_BLUE]}🖿 ${LP_PWD}$(s BLUE_ON_GREEN)"
# Virtual env
add "${LP_COLOR[WHITE_ON_GREEN]}${LP_VENV}$(s GREEN_ON_BLACK)"
# Proxy
add "${LP_PROXY}$(s BLACK_ON_WHITE)"
# VCSs
add "${LP_VCS}$(s WHITE_ON_BLACK)"
# Run time
add "${LP_RUNTIME}"
# Error code
add "${LP_ERR}${NO_COL}$(s BLACK)"
# Last line
add "${NO_COL}\n╰·${LP_COLOR[BLACK]}${NO_COL}${LP_COLOR[WHITE]}${LP_MARK}$(s WHITE) "

# "invisible" parts
# Get the current prompt on the fly and make it a title.
# Remove chevrons on the way.
LP_TITLE=$(_lp_title $(echo $LP_PS1|sed "s/${SEP}/ /g"))

# Insert it in the prompt
LP_PS1="${LP_TITLE}${LP_PS1}${LP_PS1_POSTFIX}"

# vim: set et sts=4 sw=4 tw=120 ft=sh:
