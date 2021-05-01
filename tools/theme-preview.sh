#!/bin/bash
set -u

. ./liquidprompt --no-activate

# If a theme was given, use the theme and source all other arguments.
if [[ -z ${1-} || $1 == --help ]]; then
  printf '
Usage: %s theme [sourced files...]

Print out example prompts based on a standard set of input conditions. Designed
to showcase Liquidprompt themes.

Example usage: %s powerline themes/powerline/powerline.theme
' "$0" "$0"
  exit 1

else
  theme=$1
  shift

  for file in "$@"; do
    . "$file"
  done
fi

# Liquidprompt depends on PS1 being set to detect if it has installed itself.
PS1="$ "

# Since the shell is not evaluating PS1, we don't need these.
_LP_OPEN_ESC=""
_LP_CLOSE_ESC=""


## Short

# Configure options

LP_ENABLE_PERM=0
LP_ENABLE_SHORTEN_PATH=0
LP_ENABLE_PROXY=0
LP_ENABLE_TEMP=0
LP_ENABLE_JOBS=0
LP_ENABLE_DETACHED_SESSIONS=0
LP_ENABLE_LOAD=0
LP_ENABLE_BATT=0
LP_ENABLE_GIT=0
LP_ENABLE_SVN=0
LP_ENABLE_FOSSIL=0
LP_ENABLE_HG=0
LP_ENABLE_BZR=0
LP_ENABLE_TIME=0
LP_ENABLE_RUNTIME=0
LP_ENABLE_RUNTIME_BELL=0
LP_ENABLE_VIRTUALENV=0
LP_ENABLE_TERRAFORM=0
LP_ENABLE_SCLS=0
LP_ENABLE_VCS_ROOT=1
LP_DISABLED_VCS_PATHS=()
LP_ENABLE_TITLE=0
LP_ENABLE_SUDO=0
LP_ENABLE_COLOR=1
LP_ENABLE_ERROR=0
LP_USER_ALWAYS=1
LP_HOSTNAME_ALWAYS=-1

LP_MARK_DEFAULT='$'

# Stub data functions

_lp_username() {
  lp_username=user
}

# Setup Env

HOME=/home/user
PWD=$HOME

# Activate and generate

lp_activate --no-config
# Only needs to be done once
lp_theme "$theme" || exit "$?"
__lp_set_prompt

printf 'Short prompt:\n\n  %s  \n\n' "$PS1"


## Medium

# Configure options

# lp_activate() is too smart: it will disable features if the tool is not installed.
# To make sure that doesn't happen, set these config options after activation too.
_config() {
  LP_ENABLE_JOBS=1
  LP_HOSTNAME_ALWAYS=1
  LP_ENABLE_GIT=1
}
_config

# Stub data functions

_lp_jobcount() {
  lp_running_jobs=1
  lp_stopped_jobs=0
}
_lp_hostname() {
  _lp_connection
  lp_hostname=server
}
_lp_connection() {
  lp_connection=ssh
}
_lp_connected_display() { return 1; }
_lp_find_vcs() {
  lp_vcs_type=git
  lp_vcs_root=$PWD
}
_lp_git_active() { return 0; }
_lp_git_branch() {
  lp_vcs_branch=main
}
_lp_git_bookmark() { return 2; }
_lp_git_tag() { return 2; }
_lp_git_commit_id() { return 2; }
_lp_git_head_status() { return 2; }
_lp_git_stash_count() { return 2; }
_lp_git_commits_off_remote() { return 2; }
_lp_git_untracked_files() { return 2; }
_lp_git_uncommitted_files() { return 2; }
_lp_git_uncommitted_lines() { return 2; }
_lp_git_unstaged_files() { return 2; }
_lp_git_unstaged_lines() { return 2; }

# Setup Env

PWD=$HOME/liquidprompt

# Activate and generate

lp_activate --no-config
_config
__lp_set_prompt

printf 'Medium prompt:\n\n  %s  \n\n' "$PS1"


## Long

# Configure options

_config() {
  LP_ENABLE_SHORTEN_PATH=1
  LP_PATH_LENGTH=29
  COLUMNS=100
  LP_PATH_KEEP=1
  LP_PATH_VCS_ROOT=1
  LP_ENABLE_TIME=1
  LP_TIME_ANALOG=1
  LP_ENABLE_BATT=1
  LP_ENABLE_LOAD=1
  LP_ENABLE_TEMP=1
  LP_ENABLE_DETACHED_SESSIONS=1
  LP_ENABLE_PERM=1
  LP_ENABLE_VIRTUALENV=1
  LP_ENABLE_RUNTIME=1
  LP_ENABLE_ERROR=1
  LP_ENABLE_DIRSTACK=1
  LP_PERCENTS_ALWAYS=1
}
_config

# Stub data functions

_lp_analog_time() {
  lp_analog_time="🕤"
}
_lp_battery() {
  lp_battery=24
}
_lp_load() {
  lp_load=1.68
  lp_load_adjusted=42
}
_lp_temperature() {
  lp_temperature=90
}
_lp_detached_sessions() {
  lp_detached_sessions=3
}
_lp_jobcount() {
  lp_running_jobs=2
  lp_stopped_jobs=1
}
_lp_python_env() {
  lp_python_env=pyenv
}
_lp_find_vcs() {
  lp_vcs_type=git
  lp_vcs_root="${HOME}/code/liquidprompt"
}
_lp_git_uncommitted_files() {
  lp_vcs_uncommitted_files=2
}
_lp_git_uncommitted_lines() {
  lp_vcs_uncommitted_i_lines=10
  lp_vcs_uncommitted_d_lines=5
}
_lp_git_commits_off_remote() {
  lp_vcs_commit_ahead=3
  lp_vcs_commit_behind=1
}
_lp_git_stash_count() {
  lp_vcs_stash_count=1
}
_lp_git_untracked_files() {
  lp_vcs_untracked_files=1
}
_lp_runtime_format() {
  lp_runtime_format=20s
}
_lp_error() {
  lp_error=125
}
_lp_dirstack() {
  lp_dirstack=3
}

# Setup Env

PWD="${HOME}/code/liquidprompt/docs/theme"

# Activate and generate

lp_activate --no-config
_config
__lp_set_prompt

printf 'Long prompt:\n\n  %s  \n\n' "$PS1"
