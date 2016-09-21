assert_no_time () {
    assert_ps1_plain_is "0.64 ${DETACHED_SESSION_COUNT}d [$_LP_USER_SYMBOL:/tmp/liquidprompt-tests] 2s $_LP_MARK_SYMBOL "
}

assert_time () {
    assert_ps1_plain_is "$_LP_TIME_SYMBOL 0.64 ${DETACHED_SESSION_COUNT}d [$_LP_USER_SYMBOL:/tmp/liquidprompt-tests] 2s $_LP_MARK_SYMBOL "
}

assert_analog () {
    assert_ps1_plain_is "$1  0.64 ${DETACHED_SESSION_COUNT}d [$_LP_USER_SYMBOL:/tmp/liquidprompt-tests] 2s $_LP_MARK_SYMBOL "
}

# by default, time is not enabled and it may *NOT* be enabled post sourcing.
(
source "$SCRIPT_DIR/tests/support/mocked-liquidprompt.sh"
LP_ENABLE_TIME=1
eval_prompt 'LP_ENABLE_TIME=1 after source'
assert_no_time
)

# testing the default, digital time is simple since it uses a ps1 symbol that
# the shell will substitute
(
LP_ENABLE_TIME=1
source "$SCRIPT_DIR/tests/support/mocked-liquidprompt.sh"
eval_prompt 'LP_ENABLE_TIME=1'
assert_time
)

LP_ENABLE_TIME=1
LP_TIME_ANALOG=1
source "$SCRIPT_DIR/tests/support/mocked-liquidprompt.sh"

ONE_OCLOCK=🕐 
ONE_THIRTY=🕜 
TWO_OCLOCK=🕑 
TWO_THIRTY=🕝 
THREE_OCLOCK=🕒 
THREE_THIRTY=🕞 
FOUR_OCLOCK=🕓 
FOUR_THIRTY=🕟 
FIVE_OCLOCK=🕔 
FIVE_THIRTY=🕠 
SIX_OCLOCK=🕕 
SIX_THIRTY=🕡 
SEVEN_OCLOCK=🕖 
SEVEN_THIRTY=🕢 
EIGHT_OCLOCK=🕗 
EIGHT_THIRTY=🕣 
NINE_OCLOCK=🕘 
NINE_THIRTY=🕤 
TEN_OCLOCK=🕙 
TEN_THIRTY=🕥 
ELEVEN_OCLOCK=🕚
ELEVEN_THIRTY=🕦
TWELVE_OCLOCK=🕛 
TWELVE_THIRTY=🕧 

function get_h_key () {
    case "$1" in
        1) echo ONE;;
        2) echo TWO;;
        3) echo THREE;;
        4) echo FOUR;;
        5) echo FIVE;;
        6) echo SIX;;
        7) echo SEVEN;;
        8) echo EIGHT;;
        9) echo NINE;;
       10) echo TEN;;
       11) echo ELEVEN;;
       12) echo TWELVE;;
       1*) get_h_key $((($1 - 12)));;
       2*) get_h_key $((($1 - 12)));;
        *) return 1 ;;
    esac
}

select_clock () {
    local h_key m_key

    if [ $2 -ge 15 ] && [ $2 -le 44  ]; then
        h_key="$(get_h_key "$1")"
        m_key=THIRTY
    else
        if [ $2 -ge 45 ]; then
            h_key="$(get_h_key "$((($1 + 1)))")"
        else
            h_key="$(get_h_key "$1")"
        fi
        m_key=OCLOCK
    fi

    eval "echo \$${h_key}_${m_key}"
}

for h in {1..25}; do
    echo "checking hour: $h"
    for m in 14 15 16 28 29 30 44 45 46 58 59 0; do
        function date { echo "hh=${h} mm=${m}"; }
        eval_prompt "analog time - $h:$m"
        _lp_time # why do i have to call this manually?
        assert_analog "$(select_clock "$h" "$m")"
        ((ix++))
    done
done
