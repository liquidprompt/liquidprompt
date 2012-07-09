#!/bin/bash

# An intelligent an non intrusive prompt for bash

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


# Below are function for having a flexible dynamic prompt for power user:
# - display the colored hostname when connected via ssh
# - when root, color in yellow the [username path] and in red the sharp
# - when user, print the colored git branch name (if in a git repository): 
#     red = some changes are not commited, yellow = some commits are not pushed, 
#     green = no changes or commits
# - if necessary, print a counter for jobs that are attached to the current term (e.g. xterm &)
#     or that are sleeping (e.g. Ctrl-z)
# - display the load average, colored with a colormap
# - display the battery level (if necessary), with colormap

# Some colors
BLUE="\[\033[0;34m\]"
LIGHT_GRAY="\[\033[0;37m\]"
LIGHT_GREEN="\[\033[1;32m\]"
LIGHT_BLUE="\[\033[1;34m\]"
LIGHT_CYAN="\[\033[1;36m\]"
YELLOW="\[\033[1;33m\]"
WHITE="\[\033[1;37m\]"
RED="\[\033[0;31m\]"
NO_COL="\[\033[00m\]"


#################
# Where are we? #
#################

THIS_TTY=tty`ps aux | grep $$ | grep bash | awk '{ print $7 }'`
SESS_SRC=`who | grep $THIS_TTY | awk '{ print $6 }'`

# Are we in an SSH connexion?
SSH_FLAG=0
SSH_IP=`echo $SSH_CLIENT | awk '{ print $1 }'`
if [ $SSH_IP ] ; then
  SSH_FLAG=1
fi
SSH2_IP=`echo $SSH2_CLIENT | awk '{ print $1 }'`
if [ $SSH2_IP ] ; then
  SSH_FLAG=1
fi
if [ $SSH_FLAG -eq 1 ] ; then
  CONN=ssh
elif [ -z $SESS_SRC ] ; then
  CONN=lcl
elif [ $SESS_SRC = "(:0.0)" -o $SESS_SRC = "" ] ; then
  CONN=lcl
else
  CONN=tel
fi


###############
# Who are we? #
###############

if [ `/usr/bin/whoami` = "root" ] ; then
  USR=u_root
else
  USR=nou_root
fi


#####################################
# Count the number of attached jobs #
#####################################

# Either attached running jobs (started with $ myjob &)
# or attached stopped jobs (suspended with Ctrl-Z)
jobcount()
{
    rep=""
    running=`jobs -r | wc -l | tr -d " "`
    stopped=`jobs -s | wc -l | tr -d " "`

    if [ $running != "0" -a $stopped != "0" ] ; then
        rep=" ${running}r/${stopped}s"

    elif [ $running != "0" -a $stopped == "0" ] ; then
        rep=" ${running}r"

    elif [ $running == "0" -a $stopped != "0" ] ; then
        rep=" ${stopped}s"
    fi

    echo -ne "$rep"
}

######################
# GIT branch display #
######################

# Get the branch name of the current directory
git_branch()
{
    if git rev-parse --git-dir >/dev/null 2>&1 ; then
        gitver=$(git branch 2>/dev/null| sed -n '/^\*/s/^\* //p')
    else
        return 0
    fi
    echo -e "$gitver"
}

# Set a color depending on the branch state:
# - green if the repository is up to date
# - yellow if there is some commits not pushed
# - red if there is changes to commit
git_branch_color()
{
    if git rev-parse --git-dir >/dev/null 2>&1 ; then
        red=`tput setaf 1`
        green=`tput setaf 2`
        yellow=`tput setaf 3`
     
        color=""
        if git diff --quiet 2>/dev/null >&2 ; then
            branch="$(git_branch)"
            has_commit=`git rev-list origin/$branch..$branch`
            if [ "$has_commit" != "" ] ; then
                color="${yellow}" # some commits to push
            else
                color="${green}" # nothing to commit or push
            fi
        else
            color="${red}" # changes to commit
        fi
    else
        return 0
    fi
    echo -ne $color
}


##################
# Battery status #
##################

# Get the battery status in percent
battery()
{
    command -v acpi >/dev/null 2>&1 || { echo -n ""; return; }
    bat=`acpi --battery | sed "s/^Battery .*, \([0-9]*\)%.*$/\1/"`
    if [ ${bat} -lt 90 ] ; then
        echo -n " ${bat}%"
    else
        echo -n ""
    fi
}

# Compute a gradient of background/forground colors depending on the battery status
battery_color()
{
    gray=0
    red=1
    green=2
    yellow=3
    blue=4
    magenta=5
    cyan=6
    white=7
    bat=$(battery)
    if [ "$bat" != "" ] ; then
        if [ ${bat} -gt 80 ] ; then
            tput bold ; tput setaf ${gray}
        elif [ ${bat} -le 80 ] && [ ${bat} -gt 60 ] ; then
            tput bold ; tput setaf ${green}
        elif [ ${bat} -le 60 ] && [ ${bat} -gt 40 ] ; then
            tput bold ; tput setaf ${yellow}
        elif [ ${bat} -le 40 ] && [ ${bat} -gt 20 ] ; then
            tput bold ; tput setaf ${red}
        elif [ ${bat} -le 20 ] && [ ${bat} -gt 0 ] ; then
            tput setaf ${gray} ; tput setab ${red}
        else
            tput bold ; tput setaf ${white} ; tput setab ${red}
        fi
    else
        echo -n ""
    fi
}


###############
# System load #
###############

# Get the load average
load_out()
{
    load=`uptime | sed -e "s/.*load average: \(.*\...\), \(.*\...\), \(.*\...\).*/\1/" -e "s/ //g"`
    tmp=$(echo $load*100 | bc)
    load100=${tmp%.*}
    if [ ${load100} -gt 50 ] ; then
        echo -n $load
    else
        echo -n ""
    fi
}

# Compute a gradient of background/forground colors depending on the battery status
load_color()
{
  gray=0
  red=1
  green=2
  yellow=3
  blue=4
  magenta=5
  cyan=6
  white=7

  # Colour progression is important ...
  #   bold gray -> bold green -> bold yellow -> bold red -> 
  #   black on red -> bold white on red
  #
  # Then we have to choose the values at which the colours switch, with
  # anything past yellow being pretty important.

  load=$(load_out)
  if [ "$load" != "" ] ; then

      tmp=$(echo $load*100 | bc)
      load100=${tmp%.*}

      if [ ${load100} -lt 70 ] ; then
        tput bold ; tput setaf ${gray}
      elif [ ${load100} -ge 70 ] && [ ${load100} -lt 120 ] ; then
        tput bold ; tput setaf ${green}
      elif [ ${load100} -ge 120 ] && [ ${load100} -lt 200 ] ; then
        tput bold ; tput setaf ${yellow}
      elif [ ${load100} -ge 200 ] && [ ${load100} -lt 300 ] ; then
        tput bold ; tput setaf ${red}
      elif [ ${load100} -ge 300 ] && [ ${load100} -lt 500 ] ; then
        tput setaf ${gray} ; tput setab ${red}
      else
        tput bold ; tput setaf ${white} ; tput setab ${red}
      fi
  fi
}


########################
# Construct the prompt #
########################

# different colors depending on connexion type and user
if [ $CONN = lcl -a $USR = nou_root ] ; then
  PS1="${WHITE}[\u \w]${NO_COL}"
elif [ $CONN = lcl -a $USR = u_root ] ; then
  PS1="${YELLOW}[\w]${NO_COL}" # no user name if we are local root
elif [ $CONN = tel -a $USR = nou_root ] ; then
  PS1="[\u${LIGHT_GREEN}@\h${NO_COL} \w]${NO_COL}"
elif [ $CONN = tel -a $USR = u_root ] ; then
  PS1="${RED}[\u @${YELLOW}\h${RED} \w]${NO_COL}"
elif [ $CONN = ssh -a $USR = nou_root ] ; then
  PS1="[\u @${LIGHT_BLUE}\h${NO_COL} \w]${NO_COL}"
elif [ $CONN = ssh -a $USR = u_root ] ; then
  PS1="${RED}[\u @${LIGHT_BLUE}\h${RED} \w]${NO_COL}"
fi

# add job count
PS1="$PS1${LIGHT_BLUE}\$(jobcount)${NO_COL}"

if [ $USR = nou_root ] ; then
    # add git branch and status
    PS1="$PS1 \$(git_branch_color)\$(git_branch)${NO_COL}"
fi

# add prompt mark
if [ $USR = nou_root ] ; then
    PS1="$PS1${WHITE}\\$ ${NO_COL}"
elif [ $USR = u_root ] ; then
    PS1="$PS1${RED}\\$ ${NO_COL}"
fi

# add battery status
PS1="\[\$(battery_color)\]\$(battery) ${NO_COL}$PS1"

# add colored load average
PS1="\[\$(load_color)\]\$(load_out)${NO_COL}$PS1"

# Glue the bash prompt always go to the first column .
# Avoid glitches after interrupting a command with Ctrl-C
PS1="\[\033[G\]$PS1"

