#!/bin/sh


print_ok()
{
    local OK="\\033[1;32m"
    local RAZ="\\033[0;39m"
    local cols=$1
    local name=$2
    # printf "\e${OK}%-${cols}s %-${cols}s\n${RAZ}" "$name" "OK"
    printf "${OK}%-${cols}s %-${cols}s\n${RAZ}" "$name" "OK"
}

print_no()
{
    local NOK="\\033[1;31m"
    local RAZ="\\033[0;39m"
    local cols=$1
    local name=$2
    local sub=$3
    local line=$4
    # printf "\e${NOK}%-${cols}s %-${cols}s #%-5s\n${RAZ}" "$name" "$sub" "$line"
    printf "${NOK}%-${cols}s %-${cols}s #%-5s\n${RAZ}" "$name" "$sub" "$line"
}

assert()
{
    local has=$1
    local name=$2
    local sub=$3
    local line=$4

    if [[ -z "$sub" ]]
    then
        return 1
    fi

    cols=20

    if [[ $has == 1 ]] ; then
        if [[ "$PS1" == *$sub* ]]
        then
            print_ok $cols "has $name"
        else
            print_no $cols "has $name" $sub $line
        fi
    elif [[ $has == 0 ]] ; then
        if [[ "$PS1" != *$sub* ]]
        then
            print_ok $cols " no $name"
        else
            print_no $cols " no $name" $sub $line
        fi
    else
        if [[ "$PS1" == $sub ]]
        then
            print_ok $cols " is $name"
        else
            print_no $cols " is $name" $sub $line
        fi
    fi
}

assert_has()
{

    assert 1 "$@"
}

assert_not()
{
    assert 0 "$@"
}

assert_is()
{
    assert 2 "$@"
}

log_prompt()
{
    echo -e "$PS1" 1>&2
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
    echo "fake nproc $@" 1>&2
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
            echo "2       1       fake_file"
            return 1;;
        "status" )
            echo "# Untracked";;
        "rev-list" )
            echo 111;;
    esac
}

# global variables
export http_proxy="fake"


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
    echo "0.64"
}


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
export LP_USER_ALWAYS=1


# Force erroneous command
fake_error

# Force set prompt
_lp_set_prompt


#########
# TESTS #
#########

echo "FULL PROMPT"
log_prompt

assert_has Battery_Mark     BATT    $LINENO
assert_has Battery_Level    55%    $LINENO
assert_has Load_Mark        LOAD    $LINENO
assert_has Load_Level       32%    $LINENO
assert_has User             "[\\\u"    $LINENO
if [[ $LP_HOSTNAME_ALWAYS == 0 ]] ; then
    assert_not Hostname     "\\\h"    $LINENO
else
    assert_has Hostname     "\\\h"    $LINENO
fi
assert_has Perms            :    $LINENO
assert_has Path             $(pwd | sed -e "s|$HOME|~|")    $LINENO
assert_has Proxy            proxy    $LINENO
assert_has Error            127    $LINENO
assert_has GIT_Branch       fake_test    $LINENO
assert_has GIT_Changes      "+2/-1"    $LINENO
assert_has GIT_Commits      111    $LINENO
assert_has GIT_Untrack      untracked    $LINENO
assert_has GIT_Mark         gitmark    $LINENO

# start hiding features
echo "DISABLE BATTERY"
export LP_ENABLE_BATT=0
_lp_set_prompt
log_prompt
assert_not Battery_Mark     BATT    $LINENO
assert_not Battery_level    55%    $LINENO
assert_not Error            127    $LINENO

echo "HIDE BATTERY LEVEL"
export LP_ENABLE_BATT=1
export LP_BATTERY_THRESHOLD=50
_lp_set_prompt
log_prompt
assert_has Battery_Mark     BATT    $LINENO
assert_not Battery_level    55%    $LINENO
assert_not Error            127    $LINENO

alias acpi="echo 'Battery 0: Full, 100%'"
_lp_set_prompt
log_prompt
assert_not Battery_Mark     BATT    $LINENO

echo "DISABLE LOAD"
export LP_ENABLE_LOAD=0
_lp_set_prompt
log_prompt
assert_not Load_Mark        LOAD    $LINENO
assert_not Load_Level       32%    $LINENO

echo "HIDE LOAD"
export LP_ENABLE_LOAD=1
export LP_LOAD_THRESHOLD=40
_lp_set_prompt
log_prompt
assert_not Load_Mark        LOAD    $LINENO
assert_not Load_Level       32%    $LINENO

echo "DISABLE PROXY"
export LP_ENABLE_PROXY=0
_lp_set_prompt
log_prompt
assert_not Proxy_Mark        proxy    $LINENO

echo "NO PROXY"
export LP_ENABLE_PROXY=1
export http_proxy=""
_lp_set_prompt
log_prompt
assert_not Proxy_Mark        proxy    $LINENO

echo "DISABLE GIT"
export LP_ENABLE_GIT=0
_lp_set_prompt
log_prompt
assert_not GIT_Branch       fake_test    $LINENO
assert_not GIT_Changes      "+2/-1"    $LINENO
assert_not GIT_Commits      111    $LINENO
assert_not GIT_Untrack      untracked    $LINENO
assert_not GIT_Mark         gitmark    $LINENO
assert_has User_Mark        $    $LINENO

echo "NO GIT"
export LP_ENABLE_GIT=1
alias git="echo"
_lp_set_prompt
log_prompt
assert_not GIT_Branch       fake_test    $LINENO
assert_not GIT_Changes      "+2/-1"    $LINENO
assert_not GIT_Commits      111    $LINENO
assert_not GIT_Untrack      untracked    $LINENO
assert_not GIT_Mark         gitmark    $LINENO
assert_has User_Mark        $    $LINENO

# create a deep dir tree
current=$PWD
for d in $(seq 20) ; do
    dirname=""
    for i in $(seq 5); do
         dirname="$dirname$d"
    done
    mkdir -p $dirname
    cd $dirname
done

echo "DISABLE SHORTEN PATH"
export LP_ENABLE_SHORTEN_PATH=0
_lp_set_prompt
log_prompt
assert_has Path       "$(pwd | sed -e "s|$HOME|~|")"    $LINENO

echo "ENABLE SHORTEN PATH"
export LP_ENABLE_SHORTEN_PATH=1
export LP_PATH_LENGTH=35
export LP_PATH_KEEP=1
_lp_set_prompt
log_prompt
assert_has Short_Path       " … "    $LINENO

# get back out of the deep tree
cd $current

echo "LOCAL HOST NAME"
_lp_set_prompt
log_prompt
# As the hostname is set once at the script start,
# and not re-interpret at each prompt,
# we cannot export the option in the test script.
# We thus rely on the existing config.
if [[ $LP_HOSTNAME_ALWAYS == 0 ]] ; then
    assert_not Hostname     "\\\h"    $LINENO
else
    assert_has Hostname     "\\\h"    $LINENO
fi

echo "prompt_OFF"
prompt_OFF
log_prompt
assert_is Prompt            "$ "    $LINENO

echo "prompt_on"
prompt_on
export LP_USER_ALWAYS=1
log_prompt
assert_has User             "\\\u"    $LINENO
assert_has Perms            :    $LINENO
assert_has Path             $(pwd | sed -e "s|$HOME|~|")    $LINENO
# assert_has Path             "\\\w"    $LINENO
assert_has Prompt           "$ "    $LINENO

