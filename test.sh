#!/bin/sh

assert()
{
    local name=$1
    local sub=$2

    if [[ -z "$sub" ]]
    then
        return 1
    fi

    local OK="\\033[1;32m"
    local NOK="\\033[1;31m"
    local RAZ="\\033[0;39m"

    if [[ "$PS1" == *$sub* ]]
    then
        echo -e "${OK}$name\tOK${RAZ}"
    else
        echo -e "${NOK}$name\tNO${RAZ}\t$sub"
    fi
}


#####################
# REDEFINE COMMANDS #
#####################

command()
{
    echo "fake command $@" 1>&2
    echo "/bin/fake"
}

uname()
{
    echo "fake uname $@" 1>&2
    echo Linux
}

nproc()
{
    echo "fake uname $@" 1>&2
    echo 2
}

# battery
acpi()
{
    echo "fake acpi $@" 1>&2
    echo 'Battery 0: Discharging, 55%, 01:39:34 remaining'
}


git()
{
    echo "fake git $@" 1>&2
    case $1 in
        "rev-parse" )
            echo ".git";;
        "branch" )
            echo "* fake_test";;
        "diff" )
            echo "";;
        "status" )
            echo "# Untracked";;
        "rev-list" )
            echo "111";;
    esac
}

# global variables
export http_proxy="fake"


################
# ADHOC CONFIG #
################

export LP_BATTERY_THRESHOLD=60
export LP_LOAD_THRESHOLD=1
export LP_MARK_PROXY="proxy"
export LP_MARK_BATTERY="BATT"
export LP_MARK_LOAD="LOAD"
export LP_MARK_UNTRACKED="untracked"
export LP_MARK_GIT="gitmark"


##########################
# Call the liquid prompt #
##########################

# As if we were in an interactive shell
export PS1="fake prompt \$"
# load functions
source ./liquidprompt

# Force liquid prompt function redefinition
_lp_cpu_load()
{
    echo "fake _lp_cpu_load $@" 1>&2
    echo "64"
}

# Force erroneous command
fake_error

# Force set prompt
_lp_set_prompt


#########
# TESTS #
#########

echo -e "$PS1"

assert Battery BATT55%
assert Load LOAD32%
assert User "[\\\u"
assert Perms :
assert Path $(pwd | sed -e "s|$HOME|~|")
assert Proxy proxy
assert Error 127
echo GIT
assert Branch fake_test
assert Commits 111
assert Untrack untracked
assert Mark gitmark
