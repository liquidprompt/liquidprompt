# WARNING: this require that your terminal use one of the "nerd-fonts":
# https://github.com/ryanoasis/nerd-fonts

# To use this theme, put the following lines in your .liquidpromptrc:
# LP_PS1_FILE=~/code/liquidprompt/powernerd.ps1
# source ~/code/liquidprompt/powernerd.colors

# Segment separator
s() { c=$1; echo -n -e ${LP_COLOR[$c]}${NO_COL}; }

# add time, jobs, load and battery
LP_PS1="\n${LP_PS1_PREFIX}${LP_TIME}$(s BLACK_ON_PURPLE)${LP_BATT}${LP_LOAD}$(s PURPLE_ON_GREEN)${LP_JOBS}"

# add user, host and permissions colon
LP_PS1="${LP_PS1}${LP_USER}$(s GREEN_ON_YELLOW)${LP_HOST}$(s YELLOW_ON_BLACK)${LP_PERM}${LP_BRACKET_CLOSE}"

LP_PS1="${LP_PS1}${LP_PWD}$(s BLUE_ON_GREEN)${LP_VENV}$(s GREEN_ON_BLACK)${LP_PROXY}$(s BLACK_ON_WHITE)"

# Add VCS infos
# If root, the info has not been collected unless LP_ENABLE_VCS_ROOT
# is set.
LP_PS1="${LP_PS1}${LP_VCS}$(s WHITE_ON_BLACK)"

# add return code and prompt mark
LP_PS1="${LP_PS1}${LP_RUNTIME}${LP_ERR}$(s BLACK)\n$(s BLACK_ON_WHITE)${LP_MARK}$(s WHITE)"

# "invisible" parts
# Get the current prompt on the fly and make it a title.
# Remove chevrons on the way.
LP_TITLE="$(_lp_title "$(echo $LP_PS1|sed 's// /g')")"

# Insert it in the prompt
LP_PS1="${LP_TITLE}${LP_PS1}${LP_PS1_POSTFIX}"

# vim: set et sts=4 sw=4 tw=120 ft=sh:
