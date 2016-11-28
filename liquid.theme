
####################################
# LIQUID PROMPT DEFAULT THEME FILE #
####################################

# Special characters
# Be sure to use characters that exists in the font you use. You can use several
# characters at once.
# Below is an example of how to fallback to ASCII if the term is not Unicode-capable.
# Defaults to UTF-8 characters.
if [[ "$(locale -k LC_CTYPE | sed -n 's/^charmap="\(.*\)"/\1/p')" == *"UTF-8"* ]]; then
    # If charset is UTF-8.
    LP_MARK_BATTERY="⌁"        # in front of the battery charge
    LP_MARK_ADAPTER="⏚"        # displayed when plugged
    LP_MARK_LOAD="⌂"           # in front of the load
    LP_MARK_TEMP="θ"           # in front of the temp
    LP_MARK_PROXY="↥"          # indicate a proxy in use
    LP_MARK_HG="☿"             # prompt mark in hg repositories
    LP_MARK_SVN="‡"            # prompt mark in svn repositories
    LP_MARK_GIT="±"            # prompt mark in git repositories
    LP_MARK_FOSSIL="⌘"         # prompt mark in fossil repositories
    LP_MARK_DISABLED="⌀"       # prompt mark in directory with disabled VCS info
    LP_MARK_UNTRACKED="*"      # if git has untracked files
    LP_MARK_STASH="+"          # if git has stashs
    LP_MARK_SHORTEN_PATH=" … " # prompt mark in shortened paths
    LP_MARK_PERM=":"           # separator between host and path
else
    # If charset is anything else, fallback to ASCII chars
    LP_MARK_BATTERY="b"
    LP_MARK_ADAPTER="p"
    LP_MARK_LOAD="c"
    LP_MARK_TEMP="T"
    LP_MARK_PROXY="^"
    LP_MARK_HG="m"
    LP_MARK_SVN="="
    LP_MARK_GIT="+"
    LP_MARK_FOSSIL="f"
    LP_MARK_DISABLED="!"
    LP_MARK_UNTRACKED="*"
    LP_MARK_STASH="+"
    LP_MARK_SHORTEN_PATH=" ... "
    LP_MARK_PERM=":"
fi

LP_MARK_BRACKET_OPEN="["  # open bracket
LP_MARK_BRACKET_CLOSE="]" # close bracket
#LP_MARK_DEFAULT=""        # default prompt mark
LP_MARK_PREFIX=" "        # prompt mark prefix
LP_PS1_PREFIX=""
LP_PS1_POSTFIX=""

# Colors
# Available colors are:
# BOLD, BLACK, BOLD_GRAY, WHITE, BOLD_WHITE,
# RED, BOLD_RED, WARN_RED, CRIT_RED, DANGER_RED,
# GREEN, BOLD_GREEN, YELLOW, BOLD_YELLOW, BLUE,
# BOLD_BLUE, PURPLE, PINK, CYAN, BOLD_CYAN
# Set to a null string "" if you do not want color.

# Current working directory
LP_COLOR_PATH="$BOLD"         # as normal user
LP_COLOR_PATH_ROOT="$BOLD_YELLOW"   # as root

# Color of the proxy mark
LP_COLOR_PROXY="$BOLD_BLUE"

# Jobs count
LP_COLOR_JOB_D="$YELLOW"        # Detached (aka screen sessions)
LP_COLOR_JOB_R="$BOLD_YELLOW"   # Running (xterm &)
LP_COLOR_JOB_Z="$BOLD_YELLOW"   # Sleeping (Ctrl-Z)

# Last error code
LP_COLOR_ERR="$PURPLE"

# Prompt mark
LP_COLOR_MARK="$BOLD"     # as user
LP_COLOR_MARK_ROOT="$BOLD_RED"  # as root
LP_COLOR_MARK_SUDO="$BOLD_RED"  # when sudo credentials are cached

# Current user
LP_COLOR_USER_LOGGED=""           # user who logged in
LP_COLOR_USER_ALT="$BOLD"         # user but not the one who logged in
LP_COLOR_USER_ROOT="$BOLD_YELLOW" # root

# Hostname
LP_COLOR_HOST=""            # local host
LP_COLOR_SSH="$BLUE"        # connected via SSH
LP_COLOR_SU="$BOLD_YELLOW"  # connected remotely but in new environment through su/sudo
LP_COLOR_TELNET="$WARN_RED" # connected via telnet
LP_COLOR_X11_ON="$GREEN"    # connected with X11 support
LP_COLOR_X11_OFF="$YELLOW"  # connected without X11 support

# Separation mark (aka permission in the working dir)
LP_COLOR_WRITE="$GREEN"  # have write permission
LP_COLOR_NOWRITE="$RED"  # do not have write permission

# VCS
LP_COLOR_UP="$GREEN"                # repository is up to date / a push have been made
LP_COLOR_COMMITS="$YELLOW"          # some commits have not been pushed
LP_COLOR_COMMITS_BEHIND="$BOLD_RED" # some commits have not been pushed
LP_COLOR_CHANGES="$RED"             # there is some changes to commit
LP_COLOR_DIFF="$PURPLE"             # number of lines impacted by current changes

# Battery
LP_COLOR_CHARGING_ABOVE="$GREEN"      # charging and above threshold
LP_COLOR_CHARGING_UNDER="$YELLOW"     # charging but under threshold
LP_COLOR_DISCHARGING_ABOVE="$YELLOW"  # discharging but above threshold
LP_COLOR_DISCHARGING_UNDER="$RED"     # discharging and under threshold

# Time
LP_COLOR_TIME="$BLUE"

# Brackets inside screen/tmux
LP_COLOR_IN_MULTIPLEXER="$BOLD_BLUE"

# Virtual environment
LP_COLOR_VIRTUALENV="$CYAN"

# Runtime
LP_COLOR_RUNTIME="$YELLOW"

# Color map (for battery and load levels, and temperature)
# Range from 0 (nothing special) to 9 (alert)
LP_COLORMAP=(
    ""
    "$GREEN"
    "$BOLD_GREEN"
    "$YELLOW"
    "$BOLD_YELLOW"
    "$RED"
    "$BOLD_RED"
    "$WARN_RED"
    "$CRIT_RED"
    "$DANGER_RED"
)

# vim: set et sts=4 sw=4 tw=120 ft=sh:
