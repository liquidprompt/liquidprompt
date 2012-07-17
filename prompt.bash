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
[ -z "$BASH_VERSION" -o -z "$PS1" ] && return;

bash=${BASH_VERSION%.*}; bmajor=${bash%.*}; bminor=${bash#*.}
if [ $bmajor -lt 3 ] || [ $bmajor -eq 3 -a $bminor -lt 2 ]; then
	unset bash bmajor bminor
	return
fi
unset bash bmajor bminor


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


__CPUNUM=$(grep ^processor /proc/cpuinfo | wc -l)

#####################################
# Count the number of attached jobs #
#####################################

# Either attached running jobs (started with $ myjob &)
# or attached stopped jobs (suspended with Ctrl-Z)
__jobcount_color()
{
	running=`jobs -r | wc -l | tr -d " "`
	stopped=`jobs -s | wc -l | tr -d " "`

	if [ $running != "0" -a $stopped != "0" ]
	then
		rep="${NO_COL}[${YELLOW}${running}r${NO_COL}/${LIGHT_YELLOW}${stopped}s${NO_COL}]"
	elif [ $running != "0" -a $stopped == "0" ]
	then
		rep="${NO_COL}[${YELLOW}${running}r${NO_COL}]"
	elif [ $running == "0" -a $stopped != "0" ]
	then
		rep="${NO_COL}[${LIGHT_YELLOW}${stopped}s${NO_COL}]"
	fi
	echo -ne "$rep"
}

######################
# GIT branch display #
######################

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
				ret=" ${RED}${branch}${NO_COL}(${YELLOW}$has_commit${NO_COL})" # changes to commit and commits to push
			else
				ret=" ${RED}${branch}${NO_COL}" # changes to commit
			fi
		else
			if [ "$has_commit" -gt "0" ] ; then
				# some commit(s) to push
				ret=" ${YELLOW}${branch}${NO_COL}(${YELLOW}$has_commit${NO_COL})" 
			else
				ret=" ${GREEN}${branch}${NO_COL}" # nothing to commit or push
			fi
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
	if [ ${bat} -lt 90 ] ; then
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
	if [ "$?" = "1" ] ; then return; fi;	# no battery support

	if [ "$bat" != "" ] ; then
		if [ ${bat} -gt 75 ]; then
		       	return;	# nothing displayed above 75%
		fi

		ret="${NO_COL}[battery="
		if [ ${bat} -le 75 ] && [ ${bat} -gt 50 ] ; then
			ret="${ret}${LIGHT_GREEN}"
		elif [ ${bat} -le 40 ] && [ ${bat} -gt 20 ] ; then
			ret="${ret}${LIGHT_YELLOW}"
		elif [ ${bat} -le 20 ] && [ ${bat} -gt 10 ] ; then
			ret="${ret}${LIGHT_RED}"
		elif [ ${bat} -le 10 ] && ${bat} -gt 5 ] ; then
			ret="${ret}${WARN_RED}"
		else
			ret="${ret}${CRIT_RED}"
		fi

		echo -ne "${ret}${bat}%${NO_COL}]"
	fi
}


###############
# System load #
###############

# Get the load average
__load()
{
	load=$(awk '{print $1}' /proc/loadavg)
	echo -n "$load"
}

# Compute a gradient of background/forground colors depending on the battery status
__load_color()
{
	# Colour progression is important ...
	#   bold gray -> bold green -> bold yellow -> bold red ->
	#   black on red -> bold white on red
	#
	# Then we have to choose the values at which the colours switch, with
	# anything past yellow being pretty important.

	loadval=$(__load)
	load=$(echo $loadval | sed -E 's/(^0| .*|\.)//g;s/^0*//g' )
	if [ -z "$load" ]; then
		load=0
	fi
	let "load=$load/$__CPUNUM"

	if [ "$load" -ge "60" ]
	then
		ret="${NO_COL}["
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
		ret="${ret}cpu=$load%${NO_COL}]"
		echo -ne "${ret}"
	fi
}

__smart_prompt()
{
	if [ "$EUID" -ne "0" ]
	then
		git log -1 >/dev/null 2>&1
		if [ "$?" -eq "0" ]
		then
			echo -n '±'
		else
			echo -n '$'
		fi
	else
		echo -n '#'
	fi
}

__return_value()
{
	if [ "$1" -ne "0" ]
	then
		echo -ne "${NO_COL}[${PURPLE}\\\$?=$1${NO_COL}]"
	fi
}

__set_bash_prompt()
{
	__RETURN="`__return_value $?`"
	__LOAD="`__load_color`"
	__JOBS="`__jobcount_color`"
	__BATT="`__battery_color`"
	__GIT="`__git_branch_color`"
	__PROMPT="`__smart_prompt`"
	PS1="${__BATT}${__LOAD}${__JOBS}"
	if [ "$EUID" -ne "0" ]
	then
		PS1="${PS1}${LIGHT_GREEN}\u@\h${NO_COL}:${LIGHT_BLUE}\w${NO_COL}"
		PS1="${PS1}${__GIT}"
	else
		PS1="${PS1}${LIGHT_RED}\u@\h${NO_COL}:${LIGHT_BLUE}\w${NO_COL}"
	fi
	PS1="${PS1}${__RETURN}${__PROMPT} "

	# Glue the bash prompt always go to the first column .
	# Avoid glitches after interrupting a command with Ctrl-C
	PS1="\[\033[G\]${PS1}${NO_COL}"
}
########################
# Construct the prompt #
########################

PROMPT_COMMAND=__set_bash_prompt

