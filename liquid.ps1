
#######################################
# LIQUID PROMPT EXAMPLE TEMPLATE FILE #
#######################################

# This file is not updated with new template sections. This is an example of
# how to make a template, not what can go in one.
# Available sections can be found in the documentation:
# https://liquidprompt.readthedocs.io/en/stable/theme/default.html#templates

# Remember that most features come with their corresponding colors.

# add time, jobs, load and battery
LP_PS1="${LP_PS1_PREFIX}${LP_TIME}${LP_BATT}${LP_LOAD}${LP_TEMP}${LP_JOBS}"
# add user, host and permissions colon
LP_PS1+="${LP_BRACKET_OPEN}${LP_USER}${LP_HOST}${LP_PERM}"

LP_PS1+="${LP_PWD}${LP_BRACKET_CLOSE}${LP_SCLS}${LP_VENV}${LP_RUBY_VENV}${LP_TFSPACE}${LP_PROXY}"

# Add VCS infos
LP_PS1+="${LP_VCS}"

# add return code and prompt mark
LP_PS1+="${LP_RUNTIME}${LP_ERR}${LP_MARK_PREFIX}${LP_COLOR_MARK}${LP_MARK}${LP_PS1_POSTFIX}"

# Get the current prompt on the fly and make it a title
_lp_formatted_title "$LP_PS1"

# vim: set et sts=4 sw=4 tw=120 ft=sh:
