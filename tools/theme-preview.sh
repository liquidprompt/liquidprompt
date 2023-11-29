#!/bin/bash
#shellcheck disable=SC2317
set -u

usage() {
  printf '
Usage: %s theme [options...] [sourced files...]

Print out example prompts based on a standard set of input conditions. Designed
to showcase Liquid Prompt themes.

Options:
  -h, --help                 Print this help text.
  --reproducible             Set the terminal size to a static value. Load no
                             config files. Overrides any --config-file or
                             --user-config arguments.
  --user-config              Load the user, or if not found, the system config
                             file.
  --template-file=<filename> Load <filename> as a default theme template.
                             Implies "default" theme.
  --config-file=<filename>   Load <filename> as an additional Liquid Prompt
                             config file or config presets.

Example usage:
%s alternate_vcs themes/alternate_vcs/alternate_vcs.theme
%s unfold themes/unfold/unfold.theme --reproducible
%s unfold themes/unfold/unfold.theme --user-config --config-file contrib/presets/colors/256-colors-dark.conf
%s default --template-file templates/minimal/minimal.ps1
' 1>&2 "$0" "$0" "$0" "$0" "$0"
}

sourced_files=()
config_files=()
options_ended=false
user_config=false
reproducible=false
unset theme

while [[ -n ${1-} ]]; do
  if [[ ($1 == "--"* || $1 == "-h") && $options_ended == "false" ]]; then
    if [[ $1 == "--" ]]; then
      options_ended=true
    elif [[ $1 == "--help" || $1 == "-h" ]]; then
      usage
      exit 0
    elif [[ $1 == "--config-file" ]]; then
      config_files+=("$2")
      shift
    elif [[ $1 == "--config-file="* ]]; then
      config_files+=("${1#"--config-file="}")
    elif [[ $1 == "--template-file" ]]; then
      LP_PS1_FILE="$2"
      shift
    elif [[ $1 == "--template-file="* ]]; then
      LP_PS1_FILE="${1#"--template-file="}"
    elif [[ $1 == "--user-config" ]]; then
      user_config=true
    elif [[ $1 == "--reproducible" ]]; then
      reproducible=true
    else
      printf 'Error: unknown option "%s"\n' "$1"
      exit 1
    fi
  elif [[ -z ${theme+x} ]]; then
    theme=$1
  else
    sourced_files+=("$1")
  fi
  shift
done

if [[ -z ${theme-} ]]; then
  if [[ -n ${LP_PS1_FILE-} ]]; then
    theme=default
  else
    usage
    exit 2
  fi
fi

activate_args=()
if [[ $user_config == "false" ]]; then
  activate_args+=("--no-config")
fi
activate_args+=(${config_files[@]+"${config_files[@]}"})

if [[ $reproducible == "true" ]]; then
  # Reset args to only no config.
  activate_args=("--no-config")

  if [[ $user_config == "true" || ${#config_files[@]} -gt 0 ]]; then
    printf "WARNING: the use of '--reproducible' overrides --config-file and --user-config.\n" >&2
  fi
fi

. ./liquidprompt --no-activate

for file in ${sourced_files[@]+"${sourced_files[@]}"}; do
  # shellcheck disable=SC1090
  . "$file"
done

# Liquid Prompt depends on PS1 being set to detect if it has installed itself.
PS1="$ "

# Since the shell is not evaluating PS1, if we print the PS1 to the console,
# the shell escape sequences will not be hidden, and it will look wrong. We
# cannot strip them ahead of time, since they are required to know where to
# look to remove formatting, so we have to do it right before printing it.
__remove_shell_escapes() {  # PS1 -> PS1
  PS1="${PS1//"${_LP_OPEN_ESC}"/}"
  PS1="${PS1//"${_LP_CLOSE_ESC}"/}"
}


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
LP_ENABLE_NODE_VENV=0
LP_ENABLE_RUBY_VENV=0
LP_ENABLE_TERRAFORM=0
LP_ENABLE_SCLS=0
LP_ENABLE_VCS_ROOT=1
LP_DISABLED_VCS_PATHS=()
LP_ENABLE_TITLE=0
LP_ENABLE_SUDO=0
LP_ENABLE_COLOR=1
LP_ENABLE_ERROR=0
LP_ENABLE_SHLVL=0
LP_ENABLE_PERL_VENV=0
LP_ENABLE_AWS_PROFILE=0
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

lp_activate ${activate_args[@]+"${activate_args[@]}"}
# Only needs to be done once
lp_theme "$theme" || exit "$?"
if [[ $reproducible == "true" ]]; then
  COLUMNS=160
fi
__lp_set_prompt
__remove_shell_escapes

printf 'Short prompt:\n\n%s\n\n' "$PS1"


## Medium

# Configure options

# lp_activate() is too smart: it will disable features if the tool is not installed.
# To make sure that doesn't happen, set these config options after activation too.
_config() {
  LP_ENABLE_JOBS=1
  LP_HOSTNAME_ALWAYS=1
  LP_ENABLE_GIT=1

  if [[ $reproducible == "true" ]]; then
    COLUMNS=160
  fi
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
  SSH_CONNECTION="192.168.0.254 56314 192.168.0.1 22"
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

lp_activate ${activate_args[@]+"${activate_args[@]}"}
_config
__lp_set_prompt
__remove_shell_escapes

printf 'Medium prompt:\n\n%s\n\n' "$PS1"


## Long

# Configure options

_long_config() {
  LP_ENABLE_SHORTEN_PATH=1
  LP_PATH_LENGTH=29
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
  LP_ENABLE_SHLVL=1
  LP_ALWAYS_DISPLAY_VALUES=1
  LP_DISPLAY_VALUES_AS_PERCENTS=1

  if [[ $reproducible == "true" ]]; then
    COLUMNS=160
  fi
}
_long_config

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
_lp_shell_level() {
  lp_shell_level=2
}

# Setup Env

PWD="${HOME}/code/liquidprompt/docs/theme"

# Activate and generate

lp_activate ${activate_args[@]+"${activate_args[@]}"}
_long_config
__lp_set_prompt
__remove_shell_escapes

printf 'Long prompt:\n\n%s\n\n' "$PS1"

# vim: ft=sh et sts=2 sw=2 tw=120
