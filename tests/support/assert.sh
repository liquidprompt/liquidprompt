function _invalid_assert {
    echo >&2 'No has test run yet. call "eval_prompt" first.'
    return 1
}

function assert_ps1_has       { _invalid_assert; }
function assert_ps1_not       { _invalid_assert; }
function assert_ps1_is        { _invalid_assert; }
function assert_ps1_plain_has { _invalid_assert; }
function assert_ps1_plain_not { _invalid_assert; }
function assert_ps1_plain_is  { _invalid_assert; }
function shift_ps1            { _invalid_assert; }

function eval_prompt
{
    if [[ -n "$1" ]]; then
        echo "...check: $1"
    fi

    export _TEST_LP_PS1 _TEST_LP_PS1_PLAIN
    _lp_set_prompt
    _TEST_LP_PS1="$PS1"
    _TEST_LP_PS1_PLAIN="$(strip_colors <<< "$_TEST_LP_PS1")"

    function assert_ps1_not       { _assert_hard "$_TEST_LP_PS1" 0 "$@"; }
    function assert_ps1_has       { _assert_hard "$_TEST_LP_PS1" 1 "$@"; }
    function assert_ps1_is        { _assert_hard "$_TEST_LP_PS1" 2 "$@"; }
    function assert_ps1_plain_not { _assert_hard "$_TEST_LP_PS1_PLAIN" 0 "$@"; }
    function assert_ps1_plain_has { _assert_hard "$_TEST_LP_PS1_PLAIN" 1 "$@"; }
    function assert_ps1_plain_is  { _assert_hard "$_TEST_LP_PS1_PLAIN" 2 "$@"; }
}

function strip_colors
{
    perl -pe 's/\e\[?.*?[\@-~]//g' \
        | sed -e '
            s|\\\[||g; s|\\]||g
            s|%{||g;   s|%}||g
            s|||g
        '
}

function _assert_hard {
    _assert "$@" || exit $?
}

function _assert
{
    local -r ps1=$1
    local -r mode=$2

    if [[ "$mode" == 2 ]]; then
        local -r sub=$3
    else
        local -r name=$3
        local -r sub=$4
    fi

    if [[ -z "$sub" ]]; then
        echo '_assert: no substring to given to test'
        return 1
    fi

    case "$mode" in
        0) # does NOT contain
            if grep -qE "$sub" <<< "$ps1"; then
                echo "Expected PS1 to NOT contain $name \"$sub\" - got: \"$ps1\""
                return 1
            fi
        ;;
        1) # does contain
            if ! grep -qE "$sub" <<< "$ps1"; then
                echo "Expected PS1 to contain $name \"$sub\" - got: \"$ps1\""
                return 1
            fi
        ;;
        2) # exact match
            if [[ ! "$ps1" == "$sub" ]]; then
                echo "Expected PS1 to equal \"$sub\" - got: \"$ps1\""
                return 1
            fi
        ;;
    esac
}
