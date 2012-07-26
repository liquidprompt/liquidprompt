#!/bin/bash

# An intelligent and non intrusive prompt for bash

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

# 2012 (c) nojhan <nojhan@gmail.com>
# 2012 (c) Aurelien Requiem <aurelien@requiem.fr> #major rewrite and adaptation

# Below are function for having a flexible dynamic prompt for power user:
# - display the battery level (if necessary), with colormap (if any battery attached)
# - if necessary, prints a counter for jobs that are attached to the current 
#   term (e.g. xterm &) or that are sleeping (e.g. Ctrl-z)
# - display the load average, colored with a colormap
# - displays the colored login@hostname
#     - when root displays in red
#     - when user displays in green
# - displays the current path in blue
# - when user, print the colored git branch name (if in a git repository):
#     red = some changes are not commited, and yellow in parenthesis any unpushed commits (if any)
#     yellow = some commits are not pushed. Number of commits in parenthesis
#     green = no changes or commits

# Check for recent enough version of bash.
[ -z "$BASH_VERSION" -o -z "$PS1" -o -z "$TERM" ] && return;

bash=${BASH_VERSION%.*}; bmajor=${bash%.*}; bminor=${bash#*.}
if [ $bmajor -lt 3 ] || [ $bmajor -eq 3 -a $bminor -lt 2 ]; then
    unset bash bmajor bminor
    return
fi
unset bash bmajor bminor


#################
# CONFIGURATION #
#################

# Maximal value under which the battery level is displayed
# Recommended value is 75
BATTERY_THRESHOLD=75

# Minimal value after which the load average is displayed
# Recommended value is 60
LOAD_THRESHOLD=60

# The maximum percentage of the screen width used to display the path
# Recommended value is 35
PATH_LENGTH=35

###############
# OS specific #
###############

# OS detection, default to Linux
OS="Linux"
case $(uname) in
    "Linux"  ) OS="Linux"   ;;
    "FreeBSD") OS="FreeBSD" ;;
    "DragonFly") OS="FreeBSD" ;;
    "SunOS") OS="SunOS" ;;
esac

# Colors declarations
if [[ "$OS" == "FreeBSD" ]] ; then

    BLACK="\[$(tput AF 0)\]"

    GRAY="\[$(tput md ; tput AF 0)\]"
    LIGHT_GREY="\[$(tput AF 7)\]"
    WHITE="\[$(tput md ; tput AF 7)\]"

    RED="\[$(tput AF 1)\]"
    LIGHT_RED="\[$(tput md ; tput AF 1)\]"
    WARN_RED="\[$(tput AF 0 ; tput setab 1)\]"
    CRIT_RED="\[$(tput md; tput AF 7 ; tput setab 1)\]"

    GREEN="\[$(tput AF 2)\]"
    LIGHT_GREEN="\[$(tput md ; tput AF 2)\]"

    YELLOW="\[$(tput AF 3)\]"
    LIGHT_YELLOW="\[$(tput md ; tput AF 3)\]"

    BLUE="\[$(tput AF 4)\]"
    LIGHT_BLUE="\[$(tput md ; tput AF 4)\]"

    PURPLE="\[$(tput AF 5)\]"
    PINK="\[$(tput md ; tput AF 5)\]"

    CYAN="\[$(tput AF 6)\]"
    LIGHT_CYAN="\[$(tput md ; tput AF 6)\]"

    NO_COL="\[$(tput me)\]"

else
    # default to Linux
    BLACK="\[$(tput setaf 0)\]"

    GRAY="\[$(tput bold ; tput setaf 0)\]"
    LIGHT_GREY="\[$(tput setaf 7)\]"
    WHITE="\[$(tput bold ; tput setaf 7)\]"

    RED="\[$(tput setaf 1)\]"
    LIGHT_RED="\[$(tput bold ; tput setaf 1)\]"
    WARN_RED="\[$(tput setaf 0 ; tput setab 1)\]"
    CRIT_RED="\[$(tput bold; tput setaf 7 ; tput setab 1)\]"

    GREEN="\[$(tput setaf 2)\]"
    LIGHT_GREEN="\[$(tput bold ; tput setaf 2)\]"

    YELLOW="\[$(tput setaf 3)\]"
    LIGHT_YELLOW="\[$(tput bold ; tput setaf 3)\]"

    BLUE="\[$(tput setaf 4)\]"
    LIGHT_BLUE="\[$(tput bold ; tput setaf 4)\]"

    PURPLE="\[$(tput setaf 5)\]"
    PINK="\[$(tput bold ; tput setaf 5)\]"

    CYAN="\[$(tput setaf 6)\]"
    LIGHT_CYAN="\[$(tput bold ; tput setaf 6)\]"

    NO_COL="\[$(tput sgr0)\]"

fi

# get cpu number
__cpunum_Linux()
{
    grep ^processor /proc/cpuinfo | wc -l
}

__cpunum_FreeBSD()
{
    sysctl -n hw.ncpu
}

__cpunum_SunOS()
{
    kstat -m cpu_info | grep "module: cpu_info"  | wc -l
}

__CPUNUM=$(__cpunum_$OS)


# get current load

__load_Linux()
{
    load=$(awk '{print $1}' /proc/loadavg)
    echo -n "$load"
}

__load_FreeBSD()
{
    load=$(LANG=C sysctl -n vm.loadavg | awk '{print $2}')
    echo -n "$load"
}

__load_SunOS()
{
    load=$(LANG=C uptime | awk '{print $10}'| sed -e 's/,//')
    echo -n "$load"
}


###############
# Who are we? #
###############

# Yellow for root, light grey if the user is not the login one, else no color.
__user()
{
    # if user is not root
    if [ "$EUID" -ne "0" ] ; then
        # if user is not login user
        if [[ ${USER} != "$(logname 2>/dev/null)" ]]; then
            user="${LIGHT_GREY}\u${NO_COL}"
        else
            user="\u"
        fi
    else
        user="${LIGHT_YELLOW}\u${NO_COL}"
    fi

    echo -ne $user
}


#################
# Where are we? #
#################

__connection()
{
    THIS_TTY=tty`ps aux | grep $$ | grep bash | awk '{ print $7 }'`
    SESS_SRC=`who | grep $THIS_TTY | awk '{ print $6 }'`

    # Are we in an SSH connexion?
    SSH_FLAG=0
    SSH_IP=${SSH_CLIENT%% *}
    if [ $SSH_IP ] ; then
      SSH_FLAG=1
    fi
    SSH2_IP=`echo $SSH2_CLIENT | awk '{ print $1 }'`
    if [ $SSH2_IP ] ; then
      SSH_FLAG=1
    fi

    if [ $SSH_FLAG -eq 1 ] ; then
      CONN="ssh"
    elif [ -z $SESS_SRC ] ; then
      CONN="lcl"
    elif [ $SESS_SRC = "(:0.0)" -o $SESS_SRC = "" ] ; then
      CONN="lcl"
    else
      CONN="tel"
    fi

    echo -ne $CONN
}

# Put the hostname if not locally connected
# color it in cyan within SSH, and a warning red if within telnet
# else diplay the host without color
__host_color()
{
    conn=$(__connection)

    ret="${NO_COL}"
    if [ "$conn" == "lcl" ] ; then
        ret="${ret}" # no hostname if local
    elif [ "$conn" == "ssh" ] ; then
        ret="${ret}@${LIGHT_CYAN}\h"
    elif [ "$conn" == "tel" ] ; then
        ret="${ret}@${WARN_RED}\h"
    else
        ret="${ret}@\h"
    fi

    echo -ne "${ret}${NO_COL}"
}


################
# Related jobs #
################

# Either attached running jobs (started with $ myjob &)
# or attached stopped jobs (suspended with Ctrl-Z)
__jobcount_color()
{
    running=`jobs -r | wc -l | tr -d " "`
    stopped=`jobs -s | wc -l | tr -d " "`

    if [ $running != "0" -a $stopped != "0" ]
    then
        rep="${NO_COL}${YELLOW}${running}r${NO_COL}/${LIGHT_YELLOW}${stopped}s${NO_COL}"
    elif [ $running != "0" -a $stopped == "0" ]
    then
        rep="${NO_COL}${YELLOW}${running}r${NO_COL}"
    elif [ $running == "0" -a $stopped != "0" ]
    then
        rep="${NO_COL}${LIGHT_YELLOW}${stopped}s${NO_COL}"
    fi
    echo -ne "$rep"
}

# Display the return value of the last command, if different from zero
__return_value()
{
    if [ "$1" -ne "0" ]
    then
        echo -ne "$1"
    fi
}


######################
# VCS branch display #
######################

# GIT #

# Get the branch name of the current directory
__git_branch()
{
    if git rev-parse --git-dir >/dev/null 2>&1 && [ ! -z "`git branch`" ]; then
        echo -n "$(git branch 2>/dev/null | sed -n '/^\*/s/^\* //p;')"
    fi
}

# Set a color depending on the branch state:
# - green if the repository is up to date
# - yellow if there is some commits not pushed
# - red if there is changes to commit
__git_branch_color()
{
    command -v git >/dev/null 2>&1 || return 1;
    branch=$(__git_branch)
    if [ ! -z "$branch" ] ; then

        git diff --quiet >/dev/null 2>&1
        GD=$?
        git diff --cached --quiet >/dev/null 2>&1
        GDC=$?

        has_commit=$(git rev-list --no-merges --count origin/${branch}..${branch} 2>/dev/null)
        if [ -z "$has_commit" ]; then
            has_commit=0
        fi
        if [ "$GD" -eq 1 -o "$GDC" -eq "1" ]; then
            if [ "$has_commit" -gt "0" ] ; then
                # changes to commit and commits to push
                ret="${RED}${branch}${NO_COL}(${YELLOW}$has_commit${NO_COL})"
            else
                ret="${RED}${branch}${NO_COL}" # changes to commit
            fi
        else
            if [ "$has_commit" -gt "0" ] ; then
                # some commit(s) to push
                ret="${YELLOW}${branch}${NO_COL}(${YELLOW}$has_commit${NO_COL})"
            else
                ret="${GREEN}${branch}${NO_COL}" # nothing to commit or push
            fi
        fi
        echo -ne "$ret"
    fi
}


# MERCURIAL #

# Get the branch name of the current directory
__hg_branch()
{
    branch="$(hg branch 2>/dev/null)"
    if [ $? -eq 0 ] && [ ! -z "`hg branch`" ]; then
        echo -n "$(hg branch)"
    fi
}

# Set a color depending on the branch state:
# - green if the repository is up to date
# - red if there is changes to commit
# - TODO: yellow if there is some commits not pushed
__hg_branch_color()
{
    command -v hg >/dev/null 2>&1 || return 1;
    branch=$(__hg_branch)
    if [ ! -z "$branch" ] ; then
        if [ $(hg status --quiet -n | wc -l | sed -e "s/ //g") = 0 ] ; then
            ret="${GREEN}${branch}${NO_COL}"
        else
            ret="${RED}${branch}${NO_COL}" # changes to commit
        fi
        echo -ne "$ret"
    fi
}

# Simple BASH function that shortens
# a very long path for display by removing
# the left most parts and replacing them
# with a leading ...
#
# the first argument is the path
#
# the second argument is the maximum allowed
# length including the '/'s and ...
# http://hbfs.wordpress.com/2009/09/01/short-pwd-in-bash-prompts/
#
__shorten_path()
{
    local p="$1"
    local len="${#p}"
    local len_percent=$2
    local max_len=$(($COLUMNS*$len_percent/100))

    if [ "$len" -gt "$max_len" ]
    then
        # finds all the '/' in
        # the path and stores their
        # positions
        #
        local pos=()
        for ((i=0;i<len;i++))
        do
            if [ "${p:i:1}" == "/" ]
            then
                pos=(${pos[@]} $i)
            fi
        done
        pos=(${pos[@]} $len)

        # we have the '/'s, let's find the
        # left-most that doesn't break the
        # length limit
        #
        local i=0
        while [ "$((len-pos[i]))" -gt "$((max_len-3))" ]
        do
            i=$((i+1))
        done

        # let us check if it's OK to
        # print the whole thing
        #
        if [ "${pos[i]}" -eq "0" ]
        then
            # the path is shorter than
            # the maximum allowed length,
            # so no need for ...
            #
            echo "$p"

        elif [ "${pos[i]}" = "$len" ]
        then
            # constraints are broken because
            # the maximum allowed size is smaller
            # than the last part of the path, plus
            # '...'
            #
            echo "…${p:((len-max_len+3))}"
        else
            # constraints are satisfied, at least
            # some parts of the path, plus ..., are
            # shorter than the maximum allowed size
            #
            echo "…${p:pos[i]}"
        fi
    else
        echo "$p"
    fi
}


# SUBVERSION #

# Get the branch name of the current directory
# For the first level of the repository, gives the repository name
__svn_branch()
{
    if [ -d ".svn" ] ; then
        root=$(svn info --xml 2>/dev/null | grep "^<root>" | sed "s/^.*\/\([[:alpha:]]*\)<\/root>$/\1/")
        branch=$(svn info --xml 2>/dev/null | grep "^<url>" | sed "s/.*\/$root\/\([[:alpha:]]*\).*<\/url>$/\1/")
        if [[ "$branch" == "<url>"* ]] ; then
            echo -n $root
        else
            echo -n $branch
        fi
    fi
}

# Set a color depending on the branch state:
# - green if the repository is up to date
# - red if there is changes to commit
# Note that, due to subversion way of managing changes,
# informations are only displayed for the CURRENT directory.
__svn_branch_color()
{
    command -v svn >/dev/null 2>&1 || return 1;
    branch=$(__svn_branch)
    if [ ! -z "$branch" ] ; then
        commits=$(svn status | grep -v "?" | wc -l)
        if [ $commits = 0 ] ; then
            ret="${GREEN}${branch}${NO_COL}"
        else
            ret="${RED}${branch}${NO_COL}(${YELLOW}$commits${NO_COL})" # changes to commit
        fi
        echo -ne "$ret"
    fi
}


##################
# Battery status #
##################

# Get the battery status in percent
# returns 1 if no battery support
__battery()
{
    command -v acpi >/dev/null 2>&1 || return 1;
    bat=`acpi --battery 2>/dev/null | sed "s/^Battery .*, \([0-9]*\)%.*$/\1/"`
    if [ "${bat}" == "" ] ; then
        return 1
       fi
    if [ ${bat} -le $BATTERY_THRESHOLD ] ; then
        echo -n "${bat}"
        return 0
    else
        return 1
    fi
}

# Compute a gradient of background/foreground colors depending on the battery status
__battery_color()
{
    bat=$(__battery)
    if [ "$?" = "1" ] ; then return; fi;    # no battery support

    if [ "$bat" != "" ] ; then
        if [ ${bat} -gt $BATTERY_THRESHOLD ]; then
            return;    # nothing displayed above 75%
        fi

        ret="b${NO_COL}"
        if [ ${bat} -le 75 ] && [ ${bat} -gt 50 ] ; then
            ret="${ret}${LIGHT_GREEN}"
        elif [ ${bat} -le 40 ] && [ ${bat} -gt 20 ] ; then
            ret="${ret}${LIGHT_YELLOW}"
        elif [ ${bat} -le 20 ] && [ ${bat} -gt 10 ] ; then
            ret="${ret}${LIGHT_RED}"
        elif [ ${bat} -le 10 ] && [ ${bat} -gt 5 ] ; then
            ret="${ret}${WARN_RED}"
        else
            ret="${ret}${CRIT_RED}"
        fi

        echo -ne "${ret}${bat}%${NO_COL}"
    fi
}


###############
# System load #
###############

# Compute a gradient of background/forground colors depending on the battery status
__load_color()
{
    # Colour progression is important ...
    #   bold gray -> bold green -> bold yellow -> bold red ->
    #   black on red -> bold white on red
    #
    # Then we have to choose the values at which the colours switch, with
    # anything past yellow being pretty important.

    loadval=$(__load_$OS)
    load=$(echo $loadval | sed 's/\.//g;s/^0*//g' )
    if [ -z "$load" ]; then
        load=0
    fi
    let "load=$load/$__CPUNUM"

    if [ $load -ge $LOAD_THRESHOLD ]
    then
        ret="l${NO_COL}"
        if [ $load -lt 70 ] ; then
            ret="${ret}${LIGHT_GREY}"
        elif [ $load -ge 1 ] && [ $load -lt 80 ] ; then
            ret="${ret}${LIGHT_GREEN}"
        elif [ $load -ge 80 ] && [ $load -lt 95 ] ; then
            ret="${ret}${LIGHT_YELLOW}"
        elif [ $load -ge 95 ] && [ $load -lt 150 ] ; then
            ret="${ret}${LIGHT_RED}"
        elif [ $load -ge 150 ] && [ $load -lt 200 ] ; then
            ret="${ret}${WARN_RED}"
        else
            ret="${ret}${CRIT_RED}"
        fi
        ret="${ret}$load%${NO_COL}"
        echo -ne "${ret}"
    fi
}


##########
# DESIGN #
##########

# Set the prompt mark to ± if VCS, # if root and else $
__smart_mark()
{
    if [ "$EUID" -ne "0" ]
    then
        if [ ! -z $(__git_branch) ] || [ ! -z $(__hg_branch) ] || [ ! -z $(__svn_branch) ]; then
            echo -ne "${WHITE}±${NO_COL}"
        else
            echo -ne "${WHITE}\\\$${NO_COL}"
        fi
    else
        if [ ! -z $(__git_branch) ] || [ ! -z $(__hg_branch) ] || [ ! -z $(__svn_branch) ]; then
            echo -ne "${LIGHT_RED}±${NO_COL}"
        else
            echo -ne "${LIGHT_RED}#${NO_COL}"
        fi
    fi
}

# insert a space on the right
__sr()
{
    if [ ! -z "$1" ] ; then
        echo -n "$1 "
    fi
}

# insert a space on the left
__sl()
{
    if [ ! -z "$1" ] ; then
        echo -n " $1"
    fi
}

# insert two space, before and after
__sb()
{
    if [ ! -z "$1" ] ; then
        echo -n " $1 "
    fi
}


########################
# Construct the prompt #
########################

__set_bash_prompt()
{
    # as this get the last returned code, it should be called first
    __RET=$(__sl "`__return_value $?`")

    # left of main prompt: space at right
    __JOBS=$(__sr "`__jobcount_color`")
    __LOAD=$(__sr "`__load_color`")
    __BATT=$(__sr "`__battery_color`")

    # in main prompt: no space
    __USER="`__user`"
    __HOST="`__host_color`"

    # right of main prompt: space at left
     __GIT=$(__sl "`__git_branch_color`")
      __HG=$(__sl "`__hg_branch_color`")
     __SVN=$(__sl "`__svn_branch_color`")

    # end of the prompt line: double spaces
    __MARK=$(__sb "`__smart_mark`")

    __PWD=$(__shorten_path $PWD $PATH_LENGTH)

    # add jobs, load and battery
    PS1="${__BATT}${__LOAD}${__JOBS}"

    # if not root
    if [ "$EUID" -ne "0" ]
    then
        PS1="${PS1}[${__USER}${__HOST}:${WHITE}${__PWD}${NO_COL}]"
        PS1="${PS1}${__GIT}${__HG}${__SVN}"
    else
        PS1="${PS1}[${__USER}${__HOST}${NO_COL}:${YELLOW}${__PWD}${NO_COL}]"
        # do not add VCS infos
    fi
    PS1="${PS1}${PURPLE}${__RET}${NO_COL}${__MARK}"

    # Glue the bash prompt always go to the first column.
    # Avoid glitches after interrupting a command with Ctrl-C
    PS1="\[\033[G\]${PS1}${NO_COL}"
}

PROMPT_COMMAND=__set_bash_prompt

# vim: set ts=4 sw=4 tw=120 :
