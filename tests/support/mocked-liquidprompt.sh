#-------------------------------------------------------------------------------
# Definitions *PRIOIR* to sourcing liquidprompt
#...............................................................................
_lp_connection()
{
    echo "$TEST_CONNECTION";
}

DETACHED_SESSION_COUNT_TMUX=2
DETACHED_SESSION_COUNT_SCREEN=2
DETACHED_SESSION_COUNT=4

_tmux="$(which tmux)"
function tmux
{
    if [[ "$1" == list-sessions ]]; then
        for i in eval "echo {1..$DETACHED_JOB_COUNT_TMUX}"; do
            echo 'detached'
        done
    else
        "$_tmux" "$@"
    fi
}

_screen="$(which screen)"
function screen
{
    if [[ "$1" == -ls ]]; then
        for i in eval "echo {1..$DETACHED_JOB_COUNT_SCREEN}"; do
            echo 'Detach)'
        done
    else
        "$_screen" "$@"
    fi
}


source "$SCRIPT_DIR/liquidprompt"
source "$SCRIPT_DIR/tests/support/assert.sh"

#-------------------------------------------------------------------------------
# Definitions *AFTER* sourcing liquidprompt
#...............................................................................

_lp_runtime ()
{
    echo '2s'
}

_lp_cpu_load ()
{
    echo '0.64'
}
