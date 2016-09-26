#!/bin/bash

export SCRIPT_DIR
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/.."

# the shell to test: driven by CI
export TEST_SHELL=${TEST_SHELL:-bash}
export TEST_CONNECTION=${TEST_CONNECTION:-lcl}

export OS=
case "$(uname)" in
    Darwin) OS=osx ;;
    Linux)  OS=linux ;;
    *)      OS=unknown ;;
esac

function setup
{
    export TMP_DIR="$BATS_TMPDIR/liquidprompt-tests"
    rm -rf "$TMP_DIR"
    mkdir -p "$TMP_DIR"

    # on OSX, we are handed a deep path to some /var/private/tmp/ directory
    # which throws off assertions about path shortening in the various test
    # cases.
    if [[ "$OS" == osx ]]
    then
        rm -f /tmp/liquidprompt-tests
        ln -s "$TMP_DIR" /tmp/liquidprompt-tests
        TMP_DIR=/tmp/liquidprompt-tests
    fi

    cd "$TMP_DIR"
    export GIT_CEILING_DIRECTORY="$TMP_DIR"

    function run_shell {
        _run_shell "$TEST_SHELL" "$@"
    }

} >&2

function teardown
{
    set -eo pipefail
    rm -rf "$TMP_DIR"
} >&2

function _run_shell
{
    local -r shell="$1"; shift
    local script cmd env_mod
    if [[ -n "$1" ]]; then
        script="$1"
        shift
    fi

    case "$shell" in
        bash) cmd='bash --norc -i' ;;
        zsh)  cmd='zsh -fi' ;;
        *)    echo >&2 "unsupported shell: $shell"; return 1;;
    esac

    # export a select of env vars subset to the test shell
    for v in SCRIPT_DIR TEST_SHELL TEST_CONNECTION; do
        env_mod="$env_mod $v=${!v}"
    done

    cmd="$env_mod $cmd"

    if [[ -n "$script" ]]; then
        cmd="$cmd ${SCRIPT_DIR}/$script"
    else
        cmd="$cmd -c $(cat)"
    fi

    eval "$cmd" "$@"
}
