################################################################################
# LIQUID PROMPT
# An intelligent and non-intrusive prompt for Bash and zsh
################################################################################


# Licensed under the AGPL version 3
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

###########
# AUTHORS #
###########

# Alex Prengère     <alexprengere@gmail.com>      # Untracked git files
# Anthony Gelibert  <anthony.gelibert@me.com>     # Several fix
# Aurelien Requiem  <aurelien@requiem.fr>         # Major clean refactoring, variable path length, error codes, several bugfixes.
# Brendan Fahy      <bmfahy@gmail.com>            # Postfix variable
# Clément Mathieu   <clement@unportant.info>      # Bazaar support
# David Loureiro    <david.loureiro@sysfera.com>  # Small portability fix
# Étienne Deparis   <etienne@depar.is>            # Fossil support
# Florian Le Frioux <florian@lefrioux.fr>         # Use ± mark when root in VCS dir.
# François Schmidts <francois.schmidts@gmail.com> # Initial PROMPT_DIRTRIM support
# Frédéric Lepied   <flepied@gmail.com>           # Python virtual env
# Jonas Bengtsson   <jonas.b@gmail.com>           # Git remotes fix
# Joris Dedieu      <joris@pontiac3.nfrance.com>  # Portability framework, FreeBSD support, bugfixes.
# Joris Vaillant    <joris.vaillant@gmail.com>    # Small git fix
# Luc Didry         <luc@fiat-tux.fr>             # ZSH port, several fix
# Ludovic Rousseau  <ludovic.rousseau@gmail.com>  # Lot of bugfixes.
# Markus Dreseler   <github@dreseler.de>          # Runtime of last command
# Nicolas Lacourte  <nicolas@dotinfra.fr>         # Screen title
# nojhan            <nojhan@gmail.com>            # Original author.
# Olivier Mengué    <dolmen@cpan.org>             # Major optimizations, refactorings everywhere; current maintainer
# Poil              <poil@quake.fr>               # Speed improvements
# Rolf Morel        <rolfmorel@gmail.com>         # "Shorten path" refactoring and fixes
# Thomas Debesse    <thomas.debesse@gmail.com>    # Fix columns use.
# Yann 'Ze' Richard <ze@nbox.org>                 # Do not fail on missing commands.

# See the README.md file for a summary of features.

# Issue #161: do not load if not an interactive shell
test -z "$TERM" -o "x$TERM" = xdumb && return

# Check for recent enough version of bash.
if test -n "$BASH_VERSION" -a -n "$PS1" ; then
    bash=${BASH_VERSION%.*}; bmajor=${bash%.*}; bminor=${bash#*.}
    if [[ $bmajor -lt 3 ]] || [[ $bmajor -eq 3 && $bminor -lt 2 ]]; then
        unset bash bmajor bminor
        return
    fi

    unset bash bmajor bminor

    _LP_SHELL_bash=true
    _LP_SHELL_zsh=false
    _LP_OPEN_ESC="\["
    _LP_CLOSE_ESC="\]"
    _LP_USER_SYMBOL="\u"
    _LP_HOST_SYMBOL="\h"
    _LP_TIME_SYMBOL="\t"
    _LP_MARK_SYMBOL='\$'
    _LP_FIRST_INDEX=0
    _LP_PWD_SYMBOL="\\w"
    _LP_PERCENT='%' # percent must be escaped on zsh
    # Disable the DEBUG trap used by the RUNTIME feature
    # (in case we are reloading LP in the same shell after disabling
    # the feature in .liquidpromptrc)
    # FIXME this doesn't seem to work :(
    [[ -n "$LP_ENABLE_RUNTIME" ]] && trap - DEBUG
elif test -n "$ZSH_VERSION" ; then
    _LP_SHELL_bash=false
    _LP_SHELL_zsh=true
    _LP_OPEN_ESC="%{"
    _LP_CLOSE_ESC="%}"
    _LP_USER_SYMBOL="%n"
    _LP_HOST_SYMBOL="%m"
    _LP_TIME_SYMBOL="%*"
    _LP_MARK_SYMBOL='%(!.#.%%)'
    _LP_FIRST_INDEX=1
    _LP_PERCENT='%%'
    _LP_PWD_SYMBOL="%~"
else
    echo "liquidprompt: shell not supported" >&2
    return
fi

# Store $2 (or $?) as a true/false value in variable named $1
# $? is propagated
#   _lp_bool foo 5
#   => foo=false
#   _lp_bool foo 0
#   => foo=true
_lp_bool()
{
    local res=${2:-$?}
    if [[ $res = 0 ]]; then
        eval $1=true
    else
        eval $1=false
    fi
    return $res
}

# Save $IFS as we want to restore the default value at the beginning of the
# prompt function
_LP_IFS="$IFS"


###############
# OS specific #
###############

# LP_OS detection, default to Linux
case $(uname) in
    FreeBSD)   LP_OS=FreeBSD ;;
    DragonFly) LP_OS=FreeBSD ;;
    OpenBSD)   LP_OS=OpenBSD ;;
    Darwin)    LP_OS=Darwin  ;;
    SunOS)     LP_OS=SunOS   ;;
    *)         LP_OS=Linux   ;;
esac

# Get cpu count
case "$LP_OS" in
    Linux)   _lp_CPUNUM=$( nproc 2>/dev/null || grep -c '^[Pp]rocessor' /proc/cpuinfo ) ;;
    FreeBSD|Darwin|OpenBSD) _lp_CPUNUM=$( sysctl -n hw.ncpu ) ;;
    SunOS)   _lp_CPUNUM=$( kstat -m cpu_info | grep -c "module: cpu_info" ) ;;
esac

# Extended regexp patterns for sed
# GNU/BSD sed
_LP_SED_EXTENDED=r
[[ "$LP_OS" = Darwin ]] && _LP_SED_EXTENDED=E


# get current load
case "$LP_OS" in
    Linux)
        _lp_cpu_load () {
            local load eol
            read load eol < /proc/loadavg
            echo "$load"
        }
        ;;
    FreeBSD|Darwin|OpenBSD)
        _lp_cpu_load () {
            local bol load eol
            # If you have problems with syntax coloring due to the following
            # line, do this: ln -s liquidprompt liquidprompt.bash
            # and edit liquidprompt.bash
            read bol load eol <<<"$( LANG=C sysctl -n vm.loadavg )"
            echo "$load"
        }
        ;;
    SunOS)
        _lp_cpu_load () {
            LANG=C uptime | awk '{print substr($10,0,length($10))}'
        }
esac

# Reset so all PWD dependent variables are computed after loading
unset LP_OLD_PWD

#################
# CONFIGURATION #
#################

# The following code is run just once. But it is encapsulated in a function
# to benefit of 'local' variables.
#
# What we do here:
# 1. Setup variables that can be used by the user: the "API" of Liquid Prompt
#    for config/theme. Those variables are local to the function.
#    In practice, this is only color variables.
# 2. Setup default values
# 3. Load the configuration
_lp_source_config()
{

    # TermInfo feature detection
    local ti_sgr0="$( { tput sgr0 || tput me ; } 2>/dev/null )"
    local ti_bold="$( { tput bold || tput md ; } 2>/dev/null )"
    local ti_setaf
    local ti_setab
    if tput setaf 0 >/dev/null 2>&1; then
        ti_setaf() { tput setaf "$1" ; }
    elif tput AF 0 >/dev/null 2>&1; then
        # FreeBSD
        ti_setaf() { tput AF "$1" ; }
    elif tput AF 0 0 0 >/dev/null 2>&1; then
        # OpenBSD
        ti_setaf() { tput AF "$1" 0 0 ; }
    else
        echo "liquidprompt: terminal $TERM not supported" >&2
        ti_setaf () { : ; }
    fi
    if tput setab 0 >/dev/null 2>&1; then
        ti_setab() { tput setab "$1" ; }
    elif tput AB 0 >/dev/null 2>&1; then
        # FreeBSD
        ti_setab() { tput AB "$1" ; }
    elif tput AB 0 0 0 >/dev/null 2>&1; then
        # OpenBSD
        ti_setab() { tput AB "$1" 0 0 ; }
    else
        echo "liquidprompt: terminal $TERM not supported" >&2
        ti_setab() { : ; }
    fi

    # Colors: variables are local so they will have a value only
    # during config loading and will not conflict with other values
    # with the same names defined by the user outside the config.
    local BOLD="${_LP_OPEN_ESC}${ti_bold}${_LP_CLOSE_ESC}"

    local BLACK="${_LP_OPEN_ESC}$(ti_setaf 0)${_LP_CLOSE_ESC}"
    local BOLD_GRAY="${_LP_OPEN_ESC}${ti_bold}$(ti_setaf 0)${_LP_CLOSE_ESC}"
    local WHITE="${_LP_OPEN_ESC}$(ti_setaf 7)${_LP_CLOSE_ESC}"
    local BOLD_WHITE="${_LP_OPEN_ESC}${ti_bold}$(ti_setaf 7)${_LP_CLOSE_ESC}"

    local RED="${_LP_OPEN_ESC}$(ti_setaf 1)${_LP_CLOSE_ESC}"
    local BOLD_RED="${_LP_OPEN_ESC}${ti_bold}$(ti_setaf 1)${_LP_CLOSE_ESC}"
    local WARN_RED="${_LP_OPEN_ESC}$(ti_setaf 0 ; ti_setab 1)${_LP_CLOSE_ESC}"
    local CRIT_RED="${_LP_OPEN_ESC}${ti_bold}$(ti_setaf 7 ; ti_setab 1)${_LP_CLOSE_ESC}"
    local DANGER_RED="${_LP_OPEN_ESC}${ti_bold}$(ti_setaf 3 ; ti_setab 1)${_LP_CLOSE_ESC}"

    local GREEN="${_LP_OPEN_ESC}$(ti_setaf 2)${_LP_CLOSE_ESC}"
    local BOLD_GREEN="${_LP_OPEN_ESC}${ti_bold}$(ti_setaf 2)${_LP_CLOSE_ESC}"

    local YELLOW="${_LP_OPEN_ESC}$(ti_setaf 3)${_LP_CLOSE_ESC}"
    local BOLD_YELLOW="${_LP_OPEN_ESC}${ti_bold}$(ti_setaf 3)${_LP_CLOSE_ESC}"

    local BLUE="${_LP_OPEN_ESC}$(ti_setaf 4)${_LP_CLOSE_ESC}"
    local BOLD_BLUE="${_LP_OPEN_ESC}${ti_bold}$(ti_setaf 4)${_LP_CLOSE_ESC}"

    local PURPLE="${_LP_OPEN_ESC}$(ti_setaf 5)${_LP_CLOSE_ESC}"
    local PINK="${_LP_OPEN_ESC}${ti_bold}$(ti_setaf 5)${_LP_CLOSE_ESC}"

    local CYAN="${_LP_OPEN_ESC}$(ti_setaf 6)${_LP_CLOSE_ESC}"
    local BOLD_CYAN="${_LP_OPEN_ESC}${ti_bold}$(ti_setaf 6)${_LP_CLOSE_ESC}"

    # NO_COL is special: it will be used at runtime, not just during config loading
    NO_COL="${_LP_OPEN_ESC}${ti_sgr0}${_LP_CLOSE_ESC}"

    # compute the hash of the hostname
    # and get the corresponding number in [1-6] (red,green,yellow,blue,purple or cyan)
    # FIXME check portability of cksum and add more formats (bold? 256 colors?)
    local hash=$(( 1 + $(hostname | cksum | cut -d " " -f 1) % 6 ))
    LP_COLOR_HOST_HASH="${_LP_OPEN_ESC}$(ti_setaf $hash)${_LP_CLOSE_ESC}"

    unset ti_sgr0 ti_bold ti_setaf ti_setab


    # Default values (globals)
    LP_BATTERY_THRESHOLD=${LP_BATTERY_THRESHOLD:-75}
    LP_LOAD_THRESHOLD=${LP_LOAD_THRESHOLD:-60}
    LP_TEMP_THRESHOLD=${LP_TEMP_THRESHOLD:-60}
    LP_RUNTIME_THRESHOLD=${LP_RUNTIME_THRESHOLD:-2}
    LP_PATH_LENGTH=${LP_PATH_LENGTH:-35}
    LP_PATH_KEEP=${LP_PATH_KEEP:-2}
    LP_PATH_DEFAULT="${LP_PATH_DEFAULT:-$_LP_PWD_SYMBOL}"
    LP_HOSTNAME_ALWAYS=${LP_HOSTNAME_ALWAYS:-0}
    LP_USER_ALWAYS=${LP_USER_ALWAYS:-1}
    LP_PERCENTS_ALWAYS=${LP_PERCENTS_ALWAYS:-1}
    LP_PS1=${LP_PS1:-""}
    LP_PS1_PREFIX=${LP_PS1_PREFIX:-""}
    LP_PS1_POSTFIX=${LP_PS1_POSTFIX:-""}
    LP_TITLE_OPEN=${LP_TITLE_OPEN:-"\e]0;"}
    LP_TITLE_CLOSE=${LP_TITLE_CLOSE:-"\a"}
    LP_SCREEN_TITLE_OPEN=${LP_SCREEN_TITLE_OPEN:-"\033k"}
    LP_SCREEN_TITLE_CLOSE=${LP_SCREEN_TITLE_CLOSE:-"\033\134"}

    LP_ENABLE_PERM=${LP_ENABLE_PERM:-1}
    LP_ENABLE_SHORTEN_PATH=${LP_ENABLE_SHORTEN_PATH:-1}
    LP_ENABLE_PROXY=${LP_ENABLE_PROXY:-1}
    LP_ENABLE_TEMP=${LP_ENABLE_TEMP:-1}
    LP_ENABLE_JOBS=${LP_ENABLE_JOBS:-1}
    LP_ENABLE_LOAD=${LP_ENABLE_LOAD:-1}
    LP_ENABLE_BATT=${LP_ENABLE_BATT:-1}
    LP_ENABLE_GIT=${LP_ENABLE_GIT:-1}
    LP_ENABLE_SVN=${LP_ENABLE_SVN:-1}
    LP_ENABLE_VCSH=${LP_ENABLE_VCSH:-1}
    LP_ENABLE_FOSSIL=${LP_ENABLE_FOSSIL:-1}
    LP_ENABLE_HG=${LP_ENABLE_HG:-1}
    LP_ENABLE_BZR=${LP_ENABLE_BZR:-1}
    LP_ENABLE_TIME=${LP_ENABLE_TIME:-0}
    if $_LP_SHELL_bash; then
        LP_ENABLE_RUNTIME=${LP_ENABLE_RUNTIME:-1}
    else
        LP_ENABLE_RUNTIME=${LP_ENABLE_RUNTIME:-0}
    fi
    LP_ENABLE_VIRTUALENV=${LP_ENABLE_VIRTUALENV:-1}
    LP_ENABLE_SCLS=${LP_ENABLE_SCLS:-1}
    LP_ENABLE_VCS_ROOT=${LP_ENABLE_VCS_ROOT:-0}
    LP_ENABLE_TITLE=${LP_ENABLE_TITLE:-0}
    LP_ENABLE_SCREEN_TITLE=${LP_ENABLE_SCREEN_TITLE:-0}
    LP_ENABLE_SSH_COLORS=${LP_ENABLE_SSH_COLORS:-0}
    # LP_DISABLED_VCS_PATH="${LP_DISABLED_VCS_PATH}"

    LP_MARK_DEFAULT="${LP_MARK_DEFAULT:-$_LP_MARK_SYMBOL}"
    LP_MARK_BATTERY="${LP_MARK_BATTERY:-"⌁"}"
    LP_MARK_ADAPTER="${LP_MARK_ADAPTER:-"⏚"}"
    LP_MARK_LOAD="${LP_MARK_LOAD:-"⌂"}"
    LP_MARK_TEMP="${LP_MARK_TEMP:-"θ"}"
    LP_MARK_PROXY="${LP_MARK_PROXY:-"↥"}"
    LP_MARK_HG="${LP_MARK_HG:-"☿"}"
    LP_MARK_SVN="${LP_MARK_SVN:-"‡"}"
    LP_MARK_GIT="${LP_MARK_GIT:-"±"}"
    LP_MARK_VCSH="${LP_MARK_VCSH:-"|"}"
    LP_MARK_FOSSIL="${LP_MARK_FOSSIL:-"⌘"}"
    LP_MARK_BZR="${LP_MARK_BZR:-"⚯"}"
    LP_MARK_DISABLED="${LP_MARK_DISABLED:-"⌀"}"
    LP_MARK_UNTRACKED="${LP_MARK_UNTRACKED:-"*"}"
    LP_MARK_STASH="${LP_MARK_STASH:-"+"}"
    LP_MARK_BRACKET_OPEN="${LP_MARK_BRACKET_OPEN:-"["}"
    LP_MARK_BRACKET_CLOSE="${LP_MARK_BRACKET_CLOSE:-"]"}"
    LP_MARK_SHORTEN_PATH="${LP_MARK_SHORTEN_PATH:-" … "}"
    LP_MARK_PREFIX="${LP_MARK_PREFIX:-" "}"

    LP_COLOR_PATH=${LP_COLOR_PATH:-$BOLD}
    LP_COLOR_PATH_ROOT=${LP_COLOR_PATH_ROOT:-$BOLD_YELLOW}
    LP_COLOR_PROXY=${LP_COLOR_PROXY:-$BOLD_BLUE}
    LP_COLOR_JOB_D=${LP_COLOR_JOB_D:-$YELLOW}
    LP_COLOR_JOB_R=${LP_COLOR_JOB_R:-$BOLD_YELLOW}
    LP_COLOR_JOB_Z=${LP_COLOR_JOB_Z:-$BOLD_YELLOW}
    LP_COLOR_ERR=${LP_COLOR_ERR:-$PURPLE}
    LP_COLOR_MARK=${LP_COLOR_MARK:-$BOLD}
    LP_COLOR_MARK_ROOT=${LP_COLOR_MARK_ROOT:-$BOLD_RED}
    LP_COLOR_USER_LOGGED=${LP_COLOR_USER_LOGGED:-""}
    LP_COLOR_USER_ALT=${LP_COLOR_USER_ALT:-$BOLD}
    LP_COLOR_USER_ROOT=${_ROOT:-$BOLD_YELLOW}
    LP_COLOR_HOST=${LP_COLOR_HOST:-""}
    LP_COLOR_SSH=${LP_COLOR_SSH:-$BLUE}
    LP_COLOR_SU=${LP_COLOR_SU:-$BOLD_YELLOW}
    LP_COLOR_TELNET=${LP_COLOR_TELNET:-$WARN_RED}
    LP_COLOR_X11_ON=${LP_COLOR_X11:-$GREEN}
    LP_COLOR_X11_OFF=${LP_COLOR_X11:-$YELLOW}
    LP_COLOR_WRITE=${LP_COLOR_WRITE:-$GREEN}
    LP_COLOR_NOWRITE=${LP_COLOR_NOWRITE:-$RED}
    LP_COLOR_UP=${LP_COLOR_UP:-$GREEN}
    LP_COLOR_COMMITS=${LP_COLOR_COMMITS:-$YELLOW}
    LP_COLOR_CHANGES=${LP_COLOR_CHANGES:-$RED}
    LP_COLOR_DIFF=${LP_COLOR_DIFF:-$PURPLE}
    LP_COLOR_CHARGING_ABOVE=${LP_COLOR_CHARGING_ABOVE:-$GREEN}
    LP_COLOR_CHARGING_UNDER=${LP_COLOR_CHARGING_UNDER:-$YELLOW}
    LP_COLOR_DISCHARGING_ABOVE=${LP_COLOR_DISCHARGING_ABOVE:-$YELLOW}
    LP_COLOR_DISCHARGING_UNDER=${LP_COLOR_DISCHARGING_UNDER:-$RED}
    LP_COLOR_TIME=${LP_COLOR_TIME:-$BLUE}
    LP_COLOR_IN_MULTIPLEXER=${LP_COLOR_IN_MULTIPLEXER:-$BOLD_BLUE}
    LP_COLOR_RUNTIME=${LP_COLOR_RUNTIME:-$YELLOW}
    LP_COLOR_VIRTUALENV=${LP_COLOR_VIRTUALENV:-$CYAN}

    LP_COLORMAP_0=${LP_COLORMAP_0:-""}
    LP_COLORMAP_1=${LP_COLORMAP_1:-$GREEN}
    LP_COLORMAP_2=${LP_COLORMAP_2:-$BOLD_GREEN}
    LP_COLORMAP_3=${LP_COLORMAP_3:-$YELLOW}
    LP_COLORMAP_4=${LP_COLORMAP_4:-$BOLD_YELLOW}
    LP_COLORMAP_5=${LP_COLORMAP_5:-$RED}
    LP_COLORMAP_6=${LP_COLORMAP_6:-$BOLD_RED}
    LP_COLORMAP_7=${LP_COLORMAP_7:-$WARN_RED}
    LP_COLORMAP_8=${LP_COLORMAP_8:-$CRIT_RED}
    LP_COLORMAP_9=${LP_COLORMAP_9:-$DANGER_RED}

    # Debugging flags
    LP_DEBUG_TIME=${LP_DEBUG_TIME:-0}

    # Default config file may be the XDG standard ~/.config/liquidpromptrc,
    # but heirloom dotfile has priority.

    local configfile
    if [[ -f "/etc/liquidpromptrc" ]]
    then
        source "/etc/liquidpromptrc"
    fi
    if [[ -f "$HOME/.liquidpromptrc" ]]
    then
        configfile="$HOME/.liquidpromptrc"
    elif [[ -z "$XDG_HOME_DIR" ]]
    then
        configfile="$HOME/.config/liquidpromptrc"
    else
        configfile="$XDG_HOME_DIR/liquidpromptrc"
    fi
    if [[ -f "$configfile" ]]
    then
        source "$configfile"
    fi
}
# do source config files
_lp_source_config
unset _lp_source_config

# Disable features if the tool is not installed
[[ "$LP_ENABLE_GIT"  = 1 ]] && { command -v git  >/dev/null || LP_ENABLE_GIT=0  ; }
[[ "$LP_ENABLE_SVN"  = 1 ]] && { command -v svn  >/dev/null || LP_ENABLE_SVN=0  ; }
[[ "$LP_ENABLE_FOSSIL"  = 1 ]] && { command -v fossil  >/dev/null || LP_ENABLE_FOSSIL=0  ; }
[[ "$LP_ENABLE_HG"   = 1 ]] && { command -v hg   >/dev/null || LP_ENABLE_HG=0   ; }
[[ "$LP_ENABLE_BZR"  = 1 ]] && { command -v bzr > /dev/null || LP_ENABLE_BZR=0  ; }
case "$LP_OS" in
    Darwin) [[ "$LP_ENABLE_BATT" = 1 ]] && { command -v pmset >/dev/null || LP_ENABLE_BATT=0 ; };;
    *)      [[ "$LP_ENABLE_BATT" = 1 ]] && { command -v acpi >/dev/null || LP_ENABLE_BATT=0 ; };;
esac
command -v screen >/dev/null ; _lp_bool _LP_ENABLE_SCREEN $?
command -v tmux >/dev/null   ; _lp_bool _LP_ENABLE_TMUX $?
$_LP_ENABLE_SCREEN || $_LP_ENABLE_TMUX ; _lp_bool _LP_ENABLE_DETACHED_SESSIONS $?

if [[ "$LP_ENABLE_RUNTIME" == 1 ]] && ! $_LP_SHELL_bash; then
    echo Unfortunately, runtime printing for zsh is not yet supported. Turn LP_ENABLE_RUNTIME off in your config to hide this message.
    LP_ENABLE_RUNTIME=0
fi

# If we are running in a terminal multiplexer, brackets are colored
if [[ "$TERM" == screen* ]]; then
    LP_BRACKET_OPEN="${LP_COLOR_IN_MULTIPLEXER}${LP_MARK_BRACKET_OPEN}${NO_COL}"
    LP_BRACKET_CLOSE="${LP_COLOR_IN_MULTIPLEXER}${LP_MARK_BRACKET_CLOSE}${NO_COL}"
    (( LP_ENABLE_TITLE = LP_ENABLE_TITLE && LP_ENABLE_SCREEN_TITLE ))
    LP_TITLE_OPEN="$LP_SCREEN_TITLE_OPEN"
    LP_TITLE_CLOSE="$LP_SCREEN_TITLE_CLOSE"
else
    LP_BRACKET_OPEN="${LP_MARK_BRACKET_OPEN}"
    LP_BRACKET_CLOSE="${LP_MARK_BRACKET_CLOSE}"
fi

[[ "_$TERM" == _linux* ]] && LP_ENABLE_TITLE=0

# update_terminal_cwd is a shell function available on MacOS X Lion that
# will update an icon of the directory displayed in the title of the terminal
# window.
# See http://hints.macworld.com/article.php?story=20110722211753852
if [[ "$TERM_PROGRAM" == Apple_Terminal ]] && command -v update_terminal_cwd >/dev/null; then
    _LP_TERM_UPDATE_DIR=update_terminal_cwd
    # Remove "update_terminal_cwd; " that has been add by Apple in /et/bashrc.
    # See issue #196
    PROMPT_COMMAND="${PROMPT_COMMAND//update_terminal_cwd; /}"
else
    _LP_TERM_UPDATE_DIR=:
fi

# Default value for LP_PERM when LP_ENABLE_PERM is 0
LP_PERM=:   # without color


# Escape the given strings
# Must be used for all strings that may comes from remote sources,
# like VCS branch names
_lp_escape()
{
    printf "%q" "$*"
}


###############
# Who are we? #
###############

# Yellow for root, bold if the user is not the login one, else no color.
if [[ "$EUID" -ne "0" ]] ; then  # if user is not root
    # if user is not login user
    if [[ ${USER} != "$(logname 2>/dev/null || echo "$LOGNAME")" ]]; then
        LP_USER="${LP_COLOR_USER_ALT}${_LP_USER_SYMBOL}${NO_COL}"
    else
        if [[ "${LP_USER_ALWAYS}" -ne "0" ]] ; then
            LP_USER="${LP_COLOR_USER_LOGGED}${_LP_USER_SYMBOL}${NO_COL}"
        else
            LP_USER=""
        fi
    fi
else # root!
    LP_USER="${LP_COLOR_USER_ROOT}${_LP_USER_SYMBOL}${NO_COL}"
    LP_COLOR_MARK="${LP_COLOR_MARK_ROOT}"
    LP_COLOR_PATH="${LP_COLOR_PATH_ROOT}"
    # Disable VCS info for all paths
    if [[ "$LP_ENABLE_VCS_ROOT" != 1 ]]; then
        LP_DISABLED_VCS_PATH=/
        LP_MARK_DISABLED="$_LP_MARK_SYMBOL"
    fi
fi


#################
# Where are we? #
#################

_lp_connection()
{
    if [[ -n "$SSH_CLIENT$SSH2_CLIENT$SSH_TTY" ]] ; then
        echo ssh
    else
        # TODO check on *BSD
        local sess_src="$(who am i | sed -n 's/.*(\(.*\))/\1/p')"
        local sess_parent="$(ps -o comm= -p $PPID 2> /dev/null)"
        if [[ -z "$sess_src" || "$sess_src" = ":"* ]] ; then
            echo lcl  # Local
        elif [[ "$sess_parent" = "su" || "$sess_parent" = "sudo" ]] ; then
            echo su   # Remote su/sudo
        else
            echo tel  # Telnet
        fi
    fi
}

# Put the hostname if not locally connected
# color it in cyan within SSH, and a warning red if within telnet
# else display the host without color
# The connection is not expected to change from inside the shell, so we
# build this just once
LP_HOST=""
[[ -r /etc/debian_chroot ]] && LP_HOST="($(< /etc/debian_chroot))"

# If we are connected with a X11 support
if [[ -n "$DISPLAY" ]]; then
    LP_HOST="${LP_COLOR_X11_ON}${LP_HOST}@${NO_COL}"
else
    LP_HOST="${LP_COLOR_X11_OFF}${LP_HOST}@${NO_COL}"
fi

case "$(_lp_connection)" in
lcl)
    if [[ "${LP_HOSTNAME_ALWAYS}" -eq "0" ]] ; then
        # FIXME do we want to display the chroot if local?
        LP_HOST="" # no hostname if local
    else
        LP_HOST="${LP_HOST}${LP_COLOR_HOST}${_LP_HOST_SYMBOL}${NO_COL}"
    fi
    ;;
ssh)
    # If we want a different color for each host
    [[ "$LP_ENABLE_SSH_COLORS" -eq 1 ]] && LP_COLOR_SSH="$LP_COLOR_HOST_HASH"
    LP_HOST="${LP_HOST}${LP_COLOR_SSH}${_LP_HOST_SYMBOL}${NO_COL}"
    ;;
su)
    LP_HOST="${LP_HOST}${LP_COLOR_SU}${_LP_HOST_SYMBOL}${NO_COL}"
    ;;
tel)
    LP_HOST="${LP_HOST}${LP_COLOR_TELNET}${_LP_HOST_SYMBOL}${NO_COL}"
    ;;
*)
    LP_HOST="${LP_HOST}${_LP_HOST_SYMBOL}" # defaults to no color
    ;;
esac

# Useless now, so undefine
unset _lp_connection


_lp_get_home_tilde_collapsed()
{
    local tilde="~"
    echo "${PWD/#$HOME/$tilde}"
}

# Shorten the path of the current working directory
# * Show only the current directory
# * Show as much of the cwd path as possible, if shortened display a
#   leading mark, such as ellipses, to indicate that part is missing
# * show at least LP_PATH_KEEP leading dirs and current directory
_lp_shorten_path()
{

    if [[ "$LP_ENABLE_SHORTEN_PATH" != 1 ]] ; then
        LP_PWD="$LP_PATH_DEFAULT"
        if $_LP_SHELL_bash; then
            [[ -n "$PROMPT_DIRTRIM" ]] && _lp_set_dirtrim
        fi
        return
    fi

    local ret=""

    local p="$(_lp_get_home_tilde_collapsed)"
    local mask="${LP_MARK_SHORTEN_PATH}"
    local -i max_len=$(( ${COLUMNS:-80} * LP_PATH_LENGTH / 100 ))

    if [[ ${LP_PATH_KEEP} == -1 ]]; then
        # only show the current directory, excluding any parent dirs
        ret="${p##*/}" # discard everything up to and including the last slash
        [[ "${ret}" == "" ]] && ret="/" # if in root directory
    elif (( ${#p} <= max_len )); then
        ret="${p}"
    elif [[ ${LP_PATH_KEEP} == 0 ]]; then
        # len is over max len, show as much of the tail as is allowed
        ret="${p##*/}" # show at least complete current directory
        p="${p:0:${#p} - ${#ret}}"
        ret="${mask}${p:${#p} - (${max_len} - ${#ret} - ${#mask})}${ret}"
    else
        # len is over max len, show at least LP_PATH_KEEP leading dirs and
        # current directory
        local tmp=${p//\//}
        local -i delims=$(( ${#p} - ${#tmp} ))

        for (( dir=0; dir < LP_PATH_KEEP; dir++ )); do
            (( dir == delims )) && break

            local left="${p#*/}"
            local name="${p:0:${#p} - ${#left}}"
            p="${left}"
            ret="${ret}${name%/}/"
        done

        if (( delims <= LP_PATH_KEEP )); then
            # no dirs between LP_PATH_KEEP leading dirs and current dir
            ret="${ret}${p##*/}"
        else
            local base="${p##*/}"

            p="${p:0:${#p} - ${#base}}"

            [[ ${ret} != "/" ]] && ret="${ret%/}" # strip trailing slash

            local -i len_left=$(( max_len - ${#ret} - ${#base} - ${#mask} ))

            ret="${ret}${mask}${p:${#p} - ${len_left}}${base}"
        fi
    fi
    # Escape special chars
    if $_LP_SHELL_bash; then
        LP_PWD="${ret//\\/\\\\}"
    else # zsh
        LP_PWD="${ret//\%/%%}"
    fi
}

# In Bash shells, PROMPT_DIRTRIM is the number of directory to keep at the end
# of the displayed path (if "\w" is present in the PS1 var).
# Liquid Prompt can calculate this number under two conditions, path shortening
# must be disabled and PROMPT_DIRTRIM must be already set.
_lp_set_dirtrim() {
    local p="$(_lp_get_home_tilde_collapsed)"
    local -i max_len="${COLUMNS:-80}*$LP_PATH_LENGTH/100"
    local -i dt=0

    if (( ${#p} > max_len )); then
        local q="/${p##*/}"
        local show="$q"
        # +3 because of the ellipsis: "..."
        while (( ${#show}+3 < max_len )); do
            (( dt++ ))
            p="${p%$q}"
            q="/${p##*/}"
            show="$q$show"
        done
        (( dt == 0 )) && dt=1
    fi
    PROMPT_DIRTRIM=$dt
    # For debugging
    # echo PROMPT_DIRTRIM=$PROMPT_DIRTRIM >&2
}



################
# Related jobs #
################

# Display the count of each if non-zero:
# - detached screens sessions and/or tmux sessions running on the host
# - attached running jobs (started with $ myjob &)
# - attached stopped jobs (suspended with Ctrl-Z)
_lp_jobcount_color()
{
    [[ "$LP_ENABLE_JOBS" != 1 ]] && return

    local m_stop="z"
    local m_run="&"
    local ret

    if $_LP_ENABLE_DETACHED_SESSIONS; then
        local -i detached=0
        $_LP_ENABLE_SCREEN && let detached=$(screen -ls 2> /dev/null | grep -c '[Dd]etach[^)]*)$')
        $_LP_ENABLE_TMUX && let detached+=$(tmux list-sessions 2> /dev/null | grep -cv 'attached')
        (( detached > 0 )) && ret="${ret}${LP_COLOR_JOB_D}${detached}d${NO_COL}"
    fi

    local running=$(( $(jobs -r | wc -l) ))
    if [[ $running != 0 ]] ; then
        [[ -n "$ret" ]] && ret="${ret}/"
        ret="${ret}${LP_COLOR_JOB_R}${running}${m_run}${NO_COL}"
    fi

    local stopped=$(( $(jobs -s | wc -l) ))
    if [[ $stopped != 0 ]] ; then
        [[ -n "$ret" ]] && ret="${ret}/"
        ret="${ret}${LP_COLOR_JOB_Z}${stopped}${m_stop}${NO_COL}"
    fi

    echo -n "$ret"
}



######################
# VCS branch display #
######################

_lp_are_vcs_enabled()
{
    [[ -z "$LP_DISABLED_VCS_PATH" ]] && return 0
    local path
    local IFS=:
    for path in $LP_DISABLED_VCS_PATH; do
        [[ "$PWD" == *"$path"* ]] && return 1
    done
    return 0
}

# GIT #

# Get the branch name of the current directory
_lp_git_branch()
{
    [[ "$LP_ENABLE_GIT" != 1 ]] && return

    \git rev-parse --inside-work-tree >/dev/null 2>&1 || return

    local branch
    # Recent versions of Git support the --short option for symbolic-ref, but
    # not 1.7.9 (Ubuntu 12.04)
    if branch="$(\git symbolic-ref -q HEAD)"; then
        _lp_escape "${branch#refs/heads/}"
    else
        # In detached head state, use commit instead
        # No escape needed
        \git rev-parse --short -q HEAD
    fi
}

# Set a color depending on the branch state:
# - green if the repository is up to date
# - yellow if there is some commits not pushed
# - red if there is changes to commit
#
# Add the number of pending commits and the impacted lines.
_lp_git_branch_color()
{
    [[ "$LP_ENABLE_GIT" != 1 ]] && return

    local branch
    branch="$(_lp_git_branch)"
    if [[ -n "$branch" ]] ; then

        local end
        end="$NO_COL"
        if LC_ALL=C \git status --porcelain 2>/dev/null | grep -Eq '^\?\?'; then
            end="$LP_COLOR_CHANGES$LP_MARK_UNTRACKED$end"
        fi

        if [[ -n "$(\git stash list -n 1 2>/dev/null)" ]]; then
            end="$LP_COLOR_COMMITS$LP_MARK_STASH$end"
        fi

        local remote
        remote="$(\git config --get branch.${branch}.remote 2>/dev/null)"

        local -i has_commit
        has_commit=0
        if [[ -n "$remote" ]]; then
            local remote_branch
            remote_branch="$(\git config --get branch.${branch}.merge)"
            if [[ -n "$remote_branch" ]]; then
                has_commit="$(\git rev-list --count ${remote_branch/refs\/heads/refs\/remotes\/$remote}..HEAD 2>/dev/null)"
                [[ -z "$has_commit" ]] && has_commit=0
            fi
        fi

        local ret
        local shortstat # only to check for uncommitted changes
        shortstat="$(LC_ALL=C \git diff --shortstat HEAD 2>/dev/null)"

        if [[ -n "$shortstat" ]] ; then
            local u_stat # shorstat of *unstaged* changes
            u_stat="$(LC_ALL=C \git diff --shortstat 2>/dev/null)"
            u_stat=${u_stat/*changed, /} # removing "n file(s) changed"

            local i_lines # inserted lines
            if [[ "$u_stat" = *insertion* ]] ; then
                i_lines=${u_stat/ inser*}
            else
                i_lines=0
            fi

            local d_lines # deleted lines
            if [[ "$u_stat" = *deletion* ]] ; then
                d_lines=${u_stat/*\(+\), }
                d_lines=${d_lines/ del*/}
            else
                d_lines=0
            fi

            local has_lines
            has_lines="+$i_lines/-$d_lines"

            if [[ "$has_commit" -gt "0" ]] ; then
                # Changes to commit and commits to push
                ret="${LP_COLOR_CHANGES}${branch}${NO_COL}(${LP_COLOR_DIFF}$has_lines${NO_COL},${LP_COLOR_COMMITS}$has_commit${NO_COL})"
            else
                ret="${LP_COLOR_CHANGES}${branch}${NO_COL}(${LP_COLOR_DIFF}$has_lines${NO_COL})" # changes to commit
            fi
        else
            if [[ "$has_commit" -gt "0" ]] ; then
                # some commit(s) to push
                ret="${LP_COLOR_COMMITS}${branch}${NO_COL}(${LP_COLOR_COMMITS}$has_commit${NO_COL})"
            else
                ret="${LP_COLOR_UP}${branch}" # nothing to commit or push
            fi
        fi
        echo -ne "$ret$end"
    fi
}

# Search upwards through a directory structure looking for a file/folder with
# the given name.  Used to avoid invoking 'hg' and 'bzr'.
_lp_upwards_find()
{
    local dir
    dir="$PWD"
    while [[ -n "$dir" ]]; do
        [[ -d "$dir/$1" ]] && return 0
        dir="${dir%/*}"
    done
    return 1
}

# MERCURIAL #

# Get the branch name of the current directory
_lp_hg_branch()
{
    [[ "$LP_ENABLE_HG" != 1 ]] && return

    # First do a simple search to avoid having to invoke hg -- at least on my
    # machine, the python startup causes a noticeable hitch when changing
    # directories.
    _lp_upwards_find .hg || return

    # We found an .hg folder, so we need to invoke hg and see if we're actually
    # in a repository.

    local branch
    branch="$(hg branch 2>/dev/null)"

    [[ $? -eq 0 ]] && _lp_escape "$branch"
}

# Set a color depending on the branch state:
# - green if the repository is up to date
# - red if there is changes to commit
# - TODO: yellow if there is some commits not pushed
_lp_hg_branch_color()
{
    [[ "$LP_ENABLE_HG" != 1 ]] && return

    local branch
    local ret
    branch="$(_lp_hg_branch)"
    if [[ -n "$branch" ]] ; then

        local has_untracked
        has_untracked=
        if hg status -u 2>/dev/null | grep -q '^\?' >/dev/null ; then
            has_untracked="$LP_COLOR_CHANGES$LP_MARK_UNTRACKED"
        fi

        # Count local commits waiting for a push
        #
        # Unfortunately this requires contacting the remote, so this is always slow
        # => disabled  https://github.com/nojhan/liquidprompt/issues/217
        local -i commits
        #commits=$(hg outgoing --no-merges ${branch} 2>/dev/null | grep -c '\(^changeset\:\)')
        commits=0

        # Check if there is some uncommitted stuff
        if [[ -z "$(hg status --quiet -n)" ]] ; then
            if (( commits > 0 )) ; then
                # some commit(s) to push
                ret="${LP_COLOR_COMMITS}${branch}${NO_COL}(${LP_COLOR_COMMITS}$commits${NO_COL})${has_untracked}${NO_COL}"
            else
                # nothing to commit or push
                ret="${LP_COLOR_UP}${branch}${has_untracked}${NO_COL}"
            fi
        else
            local has_lines
            # Parse the last line of the diffstat-style output
            has_lines="$(hg diff --stat 2>/dev/null | sed -n '$ s!^.*, \([0-9]*\) .*, \([0-9]*\).*$!+\1/-\2!p')"
            if (( commits > 0 )) ; then
                # Changes to commit and commits to push
                ret="${LP_COLOR_CHANGES}${branch}${NO_COL}(${LP_COLOR_DIFF}$has_lines${NO_COL},${LP_COLOR_COMMITS}$commits${NO_COL})${has_untracked}${NO_COL}"
            else
                ret="${LP_COLOR_CHANGES}${branch}${NO_COL}(${LP_COLOR_DIFF}$has_lines${NO_COL})${has_untracked}${NO_COL}" # changes to commit
            fi
        fi
        echo -ne "$ret"
    fi
}

# SUBVERSION #

# Get the branch name of the current directory
# For the first level of the repository, gives the repository name
_lp_svn_branch()
{
    [[ "$LP_ENABLE_SVN" != 1 ]] && return
    local root
    local url
    eval "$(LANG=C LC_ALL=C svn info 2>/dev/null | sed -n 's/^URL: \(.*\)/url="\1"/p;s/^Repository Root: \(.*\)/root="\1"/p' )"
    [[ -z "$root" ]] && return

    # Make url relative to root
    url="${url:${#root}}"
    if [[ "$url" == */trunk* ]] ; then
        echo -n trunk
    elif [[ "$url" == */branches/?* ]] ; then
        url="${url##*/branches/}"
        _lp_escape "${url%/*}"
    elif [[ "$url" == */tags/?* ]] ; then
        url="${url##*/tags/}"
        _lp_escape "${url%/*}"
    else
        _lp_escape "${root##*/}"
    fi
}

# Set a color depending on the branch state:
# - green if the repository is clean
#   (use $LP_SVN_STATUS_OPTS to define what that means with
#    the --depth option of 'svn status')
# - red if there is changes to commit
# Note that, due to subversion way of managing changes,
# informations are only displayed for the CURRENT directory.
_lp_svn_branch_color()
{
    [[ "$LP_ENABLE_SVN" != 1 ]] && return

    local branch
    branch="$(_lp_svn_branch)"
    if [[ -n "$branch" ]] ; then
        local changes
        changes=$(( $(svn status $LP_SVN_STATUS_OPTIONS | grep -c -v "?") ))
        if [[ $changes -eq 0 ]] ; then
            echo "${LP_COLOR_UP}${branch}${NO_COL}"
        else
            echo "${LP_COLOR_CHANGES}${branch}${NO_COL}(${LP_COLOR_DIFF}$changes${NO_COL})" # changes to commit
        fi
    fi
}


# FOSSIL #

# Get the tag name of the current directory
_lp_fossil_branch()
{
    [[ "$LP_ENABLE_FOSSIL" != 1 ]] && return
    local branch
    branch=$(fossil status 2>/dev/null | sed -n "s/tags:[ ]*\(\w*\)$/\1/Ip")
    if [ -n "$branch" ]; then
        echo "$branch"
    else
        if fossil info &>/dev/null ; then
            echo "no-tag"
        fi
    fi
}

# Set a color depending on the branch state:
# - green if the repository is clean
# - red if there is changes to commit
# - yellow if the branch has no tag name
#
# Add the number of impacted files with a
# + when files are ADDED or EDITED
# - when files are DELETED
_lp_fossil_branch_color()
{
    [[ "$LP_ENABLE_FOSSIL" != 1 ]] && return

    local branch
    branch="$(_lp_fossil_branch)"

    if [ -n "$branch" ]; then
        local -i C2E # Modified files (added or edited)
        local C2A # Extras files
        local ret
        C2E=$(fossil changes | wc -l)
        C2A=$(fossil extras | wc -l)
        ret=$(fossil diff -i -v | awk "/^(+[^+])|(+$)/ { plus+=1; } /^(-[^-])|(-$)/ { minus+=1; } END { total=\"\"; if(plus>0){ total=\"+\"plus; if(minus>0) total=total\"/\"; } if(minus>0) total=total\"-\"minus; print total;}")

        if (( C2E > 0 )); then
            [[ -n "$ret" ]] && ret+=" in "
            ret="(${LP_COLOR_DIFF}${ret}${C2E}${NO_COL})"
        fi

        if (( C2A > 0 )); then
            C2A="$LP_COLOR_CHANGES$LP_MARK_UNTRACKED"
        else
            C2A=""
        fi

        if [[ "$branch" = "no-tag" ]]; then
            # Warning, your branch has no tag name !
            branch="${LP_COLOR_COMMITS}$branch${NO_COL}$ret${LP_COLOR_COMMITS}$C2A${NO_COL}"
        else
            if (( C2E == 0 )); then
                # All is up-to-date
                branch="${LP_COLOR_UP}$branch$C2A${NO_COL}"
            else
                # There're some changes to commit
                branch="${LP_COLOR_CHANGES}$branch${NO_COL}$ret${LP_COLOR_CHANGES}$C2A${NO_COL}"
            fi
        fi
        echo "$branch"
    fi
}

# Bazaar #

# Get the branch name of the current directory
_lp_bzr_branch()
{
    [[ "$LP_ENABLE_BZR" != 1 ]] && return

    # First do a simple search to avoid having to invoke bzr -- at least on my
    # machine, the python startup causes a noticeable hitch when changing
    # directories.
    _lp_upwards_find .bzr || return

    # We found an .bzr folder, so we need to invoke bzr and see if we're
    # actually in a repository.

    local branch
    branch="$(bzr nick 2> /dev/null)"
    [[ $? -ne 0 ]] && return
    _lp_escape "$branch"
}


# Set a color depending on the branch state:
# - green if the repository is up to date
# - red if there is changes to commit
# - TODO: yellow if there is some commits not pushed
#
# Add the number of pending commits and the impacted lines.
_lp_bzr_branch_color()
{
    [[ "$LP_ENABLE_BZR" != 1 ]] && return

    # First do a simple search to avoid having to invoke bzr -- at least on my
    # machine, the python startup causes a noticeable hitch when changing
    # directories.
    _lp_upwards_find .bzr || return

    # We found an .bzr folder, so we need to invoke bzr and see if we're
    # actually in a repository.

    local output
    output="$(bzr version-info --check-clean --custom --template='{branch_nick} {revno} {clean}' 2> /dev/null)"
    [[ $? -ne 0 ]] && return
    $_LP_SHELL_zsh && setopt local_options && setopt sh_word_split
    local tuple
    tuple=($output)
    $_LP_SHELL_zsh && unsetopt sh_word_split
    local branch=${tuple[_LP_FIRST_INDEX+0]}
    local revno=${tuple[_LP_FIRST_INDEX+1]}
    local clean=${tuple[_LP_FIRST_INDEX+2]}

    if [[ -n "$branch" ]] ; then
        if [[ "$clean" -eq 0 ]] ; then
            ret="${LP_COLOR_CHANGES}${branch}${NO_COL}(${LP_COLOR_COMMITS}$revno${NO_COL})"
        else
            ret="${LP_COLOR_UP}${branch}${NO_COL}(${LP_COLOR_COMMITS}$revno${NO_COL})"
        fi

    fi
    echo -ne "$ret"
}


####################
# Wifi link status #
####################
_lp_wifi()
{
    # Linux
    sed -n '3s/^ *[^ ]*  *[^ ]*  *\([0-9]*\).*/\1/p' /proc/net/wireless
}

##################
# Battery status #
##################

# Get the battery status in percent
# returns 0 (and battery level) if battery is discharging and under threshold
# returns 1 (and battery level) if battery is discharging and above threshold
# returns 2 (and battery level) if battery is charging but under threshold
# returns 3 (and battery level) if battery is charging and above threshold
# returns 4 if no battery support
case "$LP_OS" in
    Linux)
    _lp_battery()
    {
        [[ "$LP_ENABLE_BATT" != 1 ]] && return 4
        local acpi
        acpi="$(acpi --battery 2>/dev/null)"
        # Extract the battery load value in percent
        # First, remove the beginning of the line...
        local bat="${acpi#Battery *, }"
        bat="${bat%%%*}" # remove everything starting at '%'

        if [[ -z "${bat}" ]] ; then
            # not battery level found
            return 4

        # discharging
        elif [[ "$acpi" == *"Discharging"* ]] ; then
            if [[ ${bat} -le $LP_BATTERY_THRESHOLD ]] ; then
                # under threshold
                echo -n "${bat}"
                return 0
            else
                # above threshold
                echo -n "${bat}"
                return 1
            fi

        # charging
        else
            if [[ ${bat} -le $LP_BATTERY_THRESHOLD ]] ; then
                # under threshold
                echo -n "${bat}"
                return 2
            else
                # above threshold
                echo -n "${bat}"
                return 3
            fi
        fi
    }
    ;;
    Darwin)
    _lp_battery()
    {
        [[ "$LP_ENABLE_BATT" != 1 ]] && return 4
        local pmset="$(pmset -g batt | sed -n -e '/InternalBattery/p')"
        local bat="$(cut -f2 <<<"$pmset")"
        bat="${bat%%%*}"
        case "$pmset" in
            *charged* | "")
            return 4
            ;;
            *discharging*)
            if [[ ${bat} -le $LP_BATTERY_THRESHOLD ]] ; then
                # under threshold
                echo -n "${bat}"
                return 0
            else
                # above threshold
                echo -n "${bat}"
                return 1
            fi
            ;;
            *)
            if [[ ${bat} -le $LP_BATTERY_THRESHOLD ]] ; then
                # under threshold
                echo -n "${bat}"
                return 2
            else
                # above threshold
                echo -n "${bat}"
                return 3
            fi
            ;;
        esac
    }
    ;;
esac

# Compute a gradient of background/foreground colors depending on the battery status
# Display:
# a  green ⏚ if the battery is charging    and above threshold
# a yellow ⏚ if the battery is charging    and under threshold
# a yellow ⌁ if the battery is discharging but above threshold
# a    red ⌁ if the battery is discharging and above threshold
_lp_battery_color()
{
    [[ "$LP_ENABLE_BATT" != 1 ]] && return

    local mark=$LP_MARK_BATTERY
    local chargingmark=$LP_MARK_ADAPTER
    local bat
    local ret
    bat="$(_lp_battery)"
    ret=$?

    if [[ $ret == 4 || $bat == 100 ]] ; then
        # no battery support or battery full: nothing displayed
        return
    elif [[ $ret == 3 && $bat != 100 ]] ; then
        # charging and above threshold and not 100%
        # green ⏚
        echo -ne "${LP_COLOR_CHARGING_ABOVE}$chargingmark${NO_COL}"
        return
    elif [[ $ret == 2 ]] ; then
        # charging but under threshold
        # yellow ⏚
        echo -ne "${LP_COLOR_CHARGING_UNDER}$chargingmark${NO_COL}"
        return
    elif [[ $ret == 1 ]] ; then
        # discharging but above threshold
        # yellow ⌁
        echo -ne "${LP_COLOR_DISCHARGING_ABOVE}$mark${NO_COL}"
        return

    # discharging and under threshold
    elif [[ "$bat" != "" ]] ; then
        ret="${LP_COLOR_DISCHARGING_UNDER}${mark}${NO_COL}"

        if [[ "$LP_PERCENTS_ALWAYS" -eq "1" ]]; then
            if   (( bat <=  0 )); then
                ret="${ret}${LP_COLORMAP_0}"
            elif (( bat <=  5 )); then         #  5
                ret="${ret}${LP_COLORMAP_9}"
            elif (( bat <= 10 )); then         #  5
                ret="${ret}${LP_COLORMAP_8}"
            elif (( bat <= 20 )); then         # 10
                ret="${ret}${LP_COLORMAP_7}"
            elif (( bat <= 30 )); then         # 10
                ret="${ret}${LP_COLORMAP_6}"
            elif (( bat <= 40 )); then         # 10
                ret="${ret}${LP_COLORMAP_5}"
            elif (( bat <= 50 )); then         # 10
                ret="${ret}${LP_COLORMAP_4}"
            elif (( bat <= 65 )); then         # 15
                ret="${ret}${LP_COLORMAP_3}"
            elif (( bat <= 80 )); then         # 15
                ret="${ret}${LP_COLORMAP_2}"
            elif (( bat < 100 )); then         # 20
                ret="${ret}${LP_COLORMAP_1}"
            else # >= 100
                ret="${ret}${LP_COLORMAP_0}"
            fi

            ret="${ret}${bat}$_LP_PERCENT"
        fi # LP_PERCENTS_ALWAYS
        echo -ne "${ret}${NO_COL}"
    fi # ret
}

_lp_color_map() {
    # Default scale: 0..100
    # Custom scale: 0..$2
    local -i scale value
    scale=${2:-100}
    # Transform the value to a 0..100 scale
    value=100*$1/scale
    if (( value < 50 )); then
        if (( value <  30 )); then
            if   (( value <  10 )); then
                echo -ne "${LP_COLORMAP_0}"
            elif (( value <  20 )); then
                echo -ne "${LP_COLORMAP_1}"
            else # 40..59
                echo -ne "${LP_COLORMAP_2}"
            fi
        elif (( value <  40 )); then
            echo -ne "${LP_COLORMAP_3}"
        else # 80..99
            echo -ne "${LP_COLORMAP_4}"
        fi
    elif (( value <  80 )); then
        if (( value <  60 )); then
            echo -ne "${LP_COLORMAP_5}"
        elif (( value <  70 )); then
            echo -ne "${LP_COLORMAP_6}"
        else
            echo -ne "${LP_COLORMAP_7}"
        fi
    elif (( value < 90 )) ; then
        echo -ne "${LP_COLORMAP_8}"
    else # (( value >= 90 ))
        echo -ne "${LP_COLORMAP_9}"
    fi
}

###########################
# runtime of last command #
###########################

_LP_RUNTIME_LAST_SECONDS=$SECONDS

_lp_runtime()
{
    [[ "$LP_ENABLE_RUNTIME" != 1 ]] && return
    if [[ $_LP_RUNTIME_SECONDS -ge $LP_RUNTIME_THRESHOLD ]]
    then
        echo -ne "${LP_COLOR_RUNTIME}"
        # display runtime seconds as days, hours, minutes, and seconds
        [[ "$_LP_RUNTIME_SECONDS" -ge 86400 ]] && echo -ne $((_LP_RUNTIME_SECONDS / 86400))d
        [[ "$_LP_RUNTIME_SECONDS" -ge 3600 ]] && echo -ne $((_LP_RUNTIME_SECONDS % 86400 / 3600))h
        [[ "$_LP_RUNTIME_SECONDS" -ge 60 ]] && echo -ne $((_LP_RUNTIME_SECONDS % 3600 / 60))m
        echo -ne $((_LP_RUNTIME_SECONDS % 60))s
        echo -ne "${NO_COL}"
    fi
}

_lp_reset_runtime()
{
    # Compute number of seconds since program was started
    _LP_RUNTIME_SECONDS=$((SECONDS - _LP_RUNTIME_LAST_SECONDS))

    # If no proper command was executed (i.e., someone pressed enter without entering a command),
    # reset the runtime counter
    [ "$_LP_RUNTIME_COMMAND_EXECUTED" != 1 ] && _LP_RUNTIME_LAST_SECONDS=$SECONDS && _LP_RUNTIME_SECONDS=0

    # A proper command has been executed if the last command was not related to Liquid Prompt
    [ "$BASH_COMMAND" = _lp_set_prompt ]
    _LP_RUNTIME_COMMAND_EXECUTED=$?
}

if [ "$LP_ENABLE_RUNTIME" = 1 ]
then
    # _lp_reset_runtime gets called whenever bash executes a command
    trap '_lp_reset_runtime' DEBUG
fi

###############
# System load #
###############

# Compute a gradient of background/forground colors depending on the battery status
_lp_load_color()
{
    # Colour progression is important ...
    #   bold gray -> bold green -> bold yellow -> bold red ->
    #   black on red -> bold white on red
    #
    # Then we have to choose the values at which the colours switch, with
    # anything past yellow being pretty important.

    [[ "$LP_ENABLE_LOAD" != 1 ]] && return

    local tmp="$(_lp_cpu_load)"
    tmp=${tmp/./}   # Remove '.'
    tmp=${tmp#0}    # Remove leading '0'
    tmp=${tmp#0}    # Remove leading '0', again (ex: 0.09)
    local -i load=${tmp:-0}/$_lp_CPUNUM

    if (( load > LP_LOAD_THRESHOLD )); then
        local ret="$(_lp_color_map $load 200)${LP_MARK_LOAD}"

        if [[ "$LP_PERCENTS_ALWAYS" == 1 ]]; then
            ret="${ret}${load}${_LP_PERCENT}"
        fi
        echo -nE "${ret}${NO_COL}"
    fi
}

######################
# System temperature #
######################

_lp_temp_sensors()
{
    # Return the hottest system temperature we get through the sensors command
    local i
    for i in $(sensors |
            sed -n -r "s/^(CPU|SYS|MB|Core|temp).*: *\+([0-9]*)\..°.*/\2/p"); do
        [[ $i -gt $temperature ]] && temperature=$i
    done
}

_lp_temp_acpi()
{
    local i
    for i in $(LANG=C acpi -t | sed 's/.* \(-\?[0-9]*\)\.[0-9]* degrees C$/\1/p'); do
        [[ $i -gt $temperature ]] && temperature=$i
    done
}

# Will set _LP_TEMP_FUNCTION so the temperature monitoring feature use an
# available command. _LP_TEMP_FUNCTION should return only a numeric value
if [[ "$LP_ENABLE_TEMP" = 1 ]]; then
    if command -v acpi >/dev/null; then
        _LP_TEMP_FUNCTION=_lp_temp_acpi
    elif command -v sensors >/dev/null; then
        _LP_TEMP_FUNCTION=_lp_temp_sensors
    # elif command -v the_command_you_want_to_use; then
    #   _LP_TEMP_FUNCTION=your_function
    else
        LP_ENABLE_TEMP=0
    fi
fi

_lp_temperature() {
    # Will display the numeric value as we got it through the _LP_TEMP_FUNCTION
    # and colorize it through _lp_color_map.
    [[ "$LP_ENABLE_TEMP" != 1 ]] && return

    local temperature
    temperature=0
    $_LP_TEMP_FUNCTION
    if [[ $temperature -ge $LP_TEMP_THRESHOLD ]]; then
        echo -ne "${LP_MARK_TEMP}$(_lp_color_map $temperature 120)$temperature°${NO_COL}"
    fi
}

##########
# DESIGN #
##########


# Sed expression using extended regexp to remove shell codes around terminal
# escape sequences
_LP_CLEAN_ESC="$(printf "s,%q|%q,,g" "$_LP_OPEN_ESC" "$_LP_CLOSE_ESC")"

# Remove all colors and escape characters of the given string and return a pure text
_lp_as_text()
{
    # Remove colors from the computed prompt
    echo -n "$1" | sed -$_LP_SED_EXTENDED "s/\x1B\[[0-9;]*[mK]//g;$_LP_CLEAN_ESC"
}

_lp_title()
{
    [[ "$LP_ENABLE_TITLE" != "1" ]] && return

    # Get the current computed prompt as pure text
    echo -n "${_LP_OPEN_ESC}${LP_TITLE_OPEN}$(_lp_as_text "$1")${LP_TITLE_CLOSE}${_LP_CLOSE_ESC}"
}

# Set the prompt mark to ± if git, to ☿ if mercurial, to ‡ if subversion
# to # if root and else $
_lp_smart_mark()
{
    local mark
    case "$LP_VCS_TYPE" in
    git)      mark="$LP_MARK_GIT"             ;;
    git-svn)  mark="$LP_MARK_GIT$LP_MARK_SVN" ;;
    git-vcsh) mark="$LP_MARK_VCSH$LP_MARK_GIT$LP_MARK_VCSH";;
    hg)       mark="$LP_MARK_HG"              ;;
    svn)      mark="$LP_MARK_SVN"             ;;
    fossil)   mark="$LP_MARK_FOSSIL"          ;;
    bzr)      mark="$LP_MARK_BZR"             ;;
    disabled) mark="$LP_MARK_DISABLED"        ;;
    *)        mark="$LP_MARK_DEFAULT"         ;;
    esac
    echo -ne "${LP_COLOR_MARK}${mark}${NO_COL}"
}

# insert a space on the right
_lp_sr()
{
    [[ -n "$1" ]] && echo -n "$1 "
}

# insert a space on the left
_lp_sl()
{
    [[ -n "$1" ]] && echo -n " $1"
}

# insert two space, before and after
_lp_sb()
{
    [[ -n "$1" ]] && echo -n " $1 "
}

###################
# CURRENT TIME    #
###################
_lp_time_analog()
{
    # get the date as "hours(12) minutes" in a single call
    # make a bash array with it
    local -a d
    d=( $(date "+%I %M") )
    # separate hours and minutes
    local -i hour=${d[_LP_FIRST_INDEX+0]#0} # no leading 0
    local -i min=${d[_LP_FIRST_INDEX+1]#0}

    # The targeted unicode characters are the "CLOCK FACE" ones
    # They are located in the codepages between:
    #     U+1F550 (ONE OCLOCK) and U+1F55B (TWELVE OCLOCK), for the plain hours
    #     U+1F55C (ONE-THIRTY) and U+1F567 (TWELVE-THIRTY), for the thirties
    #

    local -a plain
    plain=(🕐 🕑 🕒 🕓 🕔 🕕 🕖 🕗 🕘 🕙 🕚 🕛 )
    local -a half
    half=(🕜 🕝 🕞 🕟 🕠 🕡 🕢 🕣 🕤 🕥 🕦 🕧 )

    # "date %I" returns a number between 1 and 12 and we want 12 to be 0.
    local -i hi=$(( hour % 12))

    # add a space for correct alignment
    if (( min < 15 )) ; then
        echo -n "${plain[hi]} "
    elif (( min < 45 )) ; then
        echo -n "${half[hi]} "
    else
        echo -n "${plain[hi+1]} "
    fi
}

_lp_time()
{
    [[ "$LP_ENABLE_TIME" != 1 ]] && return
    if [[ "$LP_TIME_ANALOG" != 1 ]]; then
        echo -n "${LP_COLOR_TIME}${_LP_TIME_SYMBOL}${NO_COL}"
    else
        echo -n "${LP_COLOR_TIME}"
        _lp_time_analog
        echo -n "${NO_COL}"
    fi
}

########################
# Construct the prompt #
########################


_lp_set_prompt()
{
    # Display the return value of the last command, if different from zero
    # As this get the last returned code, it should be called first
    local -i err=$?
    if (( err != 0 )); then
        LP_ERR=" $LP_COLOR_ERR$err$NO_COL"
    else
        LP_ERR=''     # Hidden
    fi

    # Reset IFS to its default value to avoid strange behaviors
    # (in case the user is playing with the value at the prompt)
    local IFS="$_LP_IFS"

    # execute the old prompt
    if $_LP_SHELL_bash; then
        eval "$LP_OLD_PROMPT_COMMAND"
    else # zsh
        eval "${${LP_OLD_PROMPT_COMMAND#*$'\n'}%$'\n'*}"
    fi

    # left of main prompt: space at right
    LP_JOBS="$(_lp_sr "$(_lp_jobcount_color)")"
    LP_TEMP="$(_lp_sr "$(_lp_temperature)")"
    LP_LOAD="$(_lp_sr "$(_lp_load_color)")"
    LP_BATT="$(_lp_sr "$(_lp_battery_color)")"
    LP_TIME="$(_lp_sr "$(_lp_time)")"

    # in main prompt: no space
    if [[ "$LP_ENABLE_PROXY,$http_proxy" = 1,?* ]] ; then
        LP_PROXY="$LP_COLOR_PROXY$LP_MARK_PROXY$NO_COL"
    else
        LP_PROXY=
    fi

    # Display the current Python virtual environment, if available
    if [[ "$LP_ENABLE_VIRTUALENV,$VIRTUAL_ENV" = 1,?* ]] ; then
        LP_VENV=" [${LP_COLOR_VIRTUALENV}${VIRTUAL_ENV##*/}${NO_COL}]"
    else
        LP_VENV=
    fi

    # Display the current software collections enabled, if available
    if [[ "$LP_ENABLE_SCLS,$X_SCLS" = 1,?* ]] ; then
        LP_SCLS=" [${LP_COLOR_VIRTUALENV}${X_SCLS%"${X_SCLS##*[![:space:]]}"}${NO_COL}]"
    else
        LP_SCLS=
    fi

    LP_RUNTIME=$(_lp_sl "$(_lp_runtime)")

    # if change of working directory
    if [[ "$LP_OLD_PWD" != "LP:$PWD" ]]; then
        # Update directory icon for MacOS X
        $_LP_TERM_UPDATE_DIR

        LP_VCS=""
        LP_VCS_TYPE=""
        # LP_HOST is a global set at load time

        # LP_PERM: shows a ":"
        # - colored in green if user has write permission on the current dir
        # - colored in red if not
        if [[ "$LP_ENABLE_PERM" = 1 ]]; then
            if [[ -w "${PWD}" ]]; then
                LP_PERM="${LP_COLOR_WRITE}:${NO_COL}"
            else
                LP_PERM="${LP_COLOR_NOWRITE}:${NO_COL}"
            fi
        fi

        _lp_shorten_path   # set LP_PWD

        if _lp_are_vcs_enabled; then
            LP_VCS="$(_lp_git_branch_color)"
            LP_VCS_TYPE="git"
            if [[ -n "$LP_VCS" ]]; then
                # If this is a vcsh repository
                if [[ -n "$VCSH_DIRECTORY" ]]; then
                    LP_VCS_TYPE="git-vcsh"
                fi
                # If this is a git-svn repository
                if [[ -d "$(\git rev-parse --git-dir 2>/dev/null)/svn" ]]; then
                    LP_VCS_TYPE="git-svn"
                fi # git-svn
            else
                LP_VCS="$(_lp_hg_branch_color)"
                LP_VCS_TYPE="hg"
                if [[ -z "$LP_VCS" ]]; then
                    LP_VCS="$(_lp_svn_branch_color)"
                    LP_VCS_TYPE="svn"
                    if [[ -z "$LP_VCS" ]]; then
                        LP_VCS="$(_lp_fossil_branch_color)"
                        LP_VCS_TYPE="fossil"
                        if [[ -z "$LP_VCS" ]]; then
                            LP_VCS="$(_lp_bzr_branch_color)"
                            LP_VCS_TYPE="bzr"
                            if [[ -z "$LP_VCS" ]]; then
                                LP_VCS=""
                                LP_VCS_TYPE=""
                            fi # nothing
                        fi # bzr
                    fi # fossil
                fi # svn
            fi # hg

        else # if this vcs rep is disabled
            LP_VCS="" # not necessary, but more readable
            LP_VCS_TYPE="disabled"
        fi

        if [[ -z "$LP_VCS_TYPE" ]] ; then
            LP_VCS=""
        else
            LP_VCS="$(_lp_sl "${LP_VCS}")"
        fi

        # end of the prompt line: double spaces
        LP_MARK="$(_lp_sr "$(_lp_smart_mark $LP_VCS_TYPE)")"

        # The color is different if user is root
        LP_PWD="${LP_COLOR_PATH}${LP_PWD}${NO_COL}"

        LP_OLD_PWD="LP:$PWD"

    # if do not change of working directory but...
    elif [[ -n "$LP_VCS_TYPE" ]]; then # we are still in a VCS dir
        case "$LP_VCS_TYPE" in
            # git, git-svn
            git*)    LP_VCS="$(_lp_sl "$(_lp_git_branch_color)")";;
            hg)      LP_VCS="$(_lp_sl "$(_lp_hg_branch_color)")";;
            svn)     LP_VCS="$(_lp_sl "$(_lp_svn_branch_color)")";;
            fossil)  LP_VCS="$(_lp_sl "$(_lp_fossil_branch_color)")";;
            bzr)     LP_VCS="$(_lp_sl "$(_lp_bzr_branch_color)")";;
            disabled)LP_VCS="";;
        esac
    fi

    if [[ -f "$LP_PS1_FILE" ]]; then
        source "$LP_PS1_FILE"
    fi

    if [[ -z "$LP_PS1" ]] ; then
        # add title escape time, jobs, load and battery
        PS1="${LP_PS1_PREFIX}${LP_TIME}${LP_BATT}${LP_LOAD}${LP_TEMP}${LP_JOBS}"
        # add user, host and permissions colon
        PS1="${PS1}${LP_BRACKET_OPEN}${LP_USER}${LP_HOST}${LP_PERM}"

        PS1="${PS1}${LP_PWD}${LP_BRACKET_CLOSE}${LP_SCLS}${LP_VENV}${LP_PROXY}"

        # Add VCS infos
        # If root, the info has not been collected unless LP_ENABLE_VCS_ROOT
        # is set.
        PS1="${PS1}${LP_VCS}"

        # add return code and prompt mark
        PS1="${PS1}${LP_RUNTIME}${LP_ERR}${LP_MARK_PREFIX}${LP_MARK}${LP_PS1_POSTFIX}"

        # "invisible" parts
        # Get the current prompt on the fly and make it a title
        LP_TITLE="$(_lp_title "$PS1")"

        # Insert it in the prompt
        PS1="${LP_TITLE}${PS1}"

        # Glue the bash prompt always go to the first column.
        # Avoid glitches after interrupting a command with Ctrl-C
        # Does not seem to be necessary anymore?
        #PS1="\[\033[G\]${PS1}${NO_COL}"
    else
        PS1=$LP_PS1
    fi
}

prompt_tag()
{
    export LP_PS1_PREFIX="$(_lp_sr "$1")"
}

# Activate Liquid Prompt
prompt_on()
{
    # if Liquid Prompt has not been already set
    if [[ -z "$LP_OLD_PS1" ]] ; then
        LP_OLD_PS1="$PS1"
        if $_LP_SHELL_bash; then
            LP_OLD_PROMPT_COMMAND="$PROMPT_COMMAND"
            LP_OLD_SHOPT="$(shopt -p promptvars)"
        else # zsh
            LP_OLD_PROMPT_COMMAND="$(whence -f precmd)"
        fi
    fi
    if $_LP_SHELL_bash; then
        shopt -s promptvars
        PROMPT_COMMAND=_lp_set_prompt
        [[ "$LP_DEBUG_TIME" == 1 ]] && PROMPT_COMMAND="time $PROMPT_COMMAND"
    else # zsh
        # That doesn't seem to work: no time output
        #if [[ "$LP_DEBUG_TIME" == 1 ]]; then
        #    function precmd {
        #        local TIMEFMT='Liquid Prompt build time: %*E'
        #        time _lp_set_prompt
        #    }
        #else
            function precmd {
                _lp_set_prompt
            }
        #fi
    fi
}

# Come back to the old prompt
prompt_off()
{
    PS1=$LP_OLD_PS1
    if $_LP_SHELL_bash; then
        eval "$LP_OLD_SHOPT"
        PROMPT_COMMAND="$LP_OLD_PROMPT_COMMAND"
    else # zsh
        precmd() { : ; }
        eval "$LP_OLD_PROMPT_COMMAND"
    fi
}

# Use an empty prompt: just the \$ mark
prompt_OFF()
{
    PS1="\$ "
    if $_LP_SHELL_bash; then
        shopt -u promptvars
        PROMPT_COMMAND="$LP_OLD_PROMPT_COMMAND"
    else # zsh
        precmd() { : ; }
        eval "$LP_OLD_PROMPT_COMMAND"
    fi
}

# By default, sourcing liquidprompt will activate Liquid Prompt
prompt_on

# vim: set et sts=4 sw=4 tw=120 ft=sh:
