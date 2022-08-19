
# Error on unset variables
set -u

. ../liquidprompt --no-activate

typeset -a ssh_values remotehost_values ps_outputs values

# Add test cases to these arrays like below

ssh_values+=(
""
)
remotehost_values+=(
"localhost"
)
ps_outputs+=(
"login"
)
values+=(tel)

ssh_values+=(
"localhost 65116 22"
)
remotehost_values+=(
""
)
ps_outputs+=(
"sshd"
)
values+=(ssh)

ssh_values+=(
"localhost 65116 22"
)
remotehost_values+=(
"localhost"
)
ps_outputs+=(
"sshd"
)
values+=(ssh)

ssh_values+=(
""
)
remotehost_values+=(
""
)
ps_outputs+=(
"su"
)
values+=(su)

ssh_values+=(
""
)
remotehost_values+=(
""
)
ps_outputs+=(
"sudo"
)
values+=(su)

ssh_values+=(
""
)
remotehost_values+=(
""
)
ps_outputs+=(
"bash"
)
values+=(lcl)

ssh_values+=(
""
)
remotehost_values+=(
""
)
ps_outputs+=(
"-bash"
)
values+=(lcl)

ssh_values+=(
""
)
remotehost_values+=(
""
)
ps_outputs+=(
""
)
values+=(lcl)


function test_connection {
  local SSH_CLIENT REMOTEHOST SSH2_CLIENT="" SSH_TTY=""

  ps() {
    printf '%s\n' "$__ps_output"
  }

  for (( index=0; index < ${#values[@]}; index++ )); do
    SSH_CLIENT=${ssh_values[$index]}
    REMOTEHOST=${remotehost_values[$index]}
    __ps_output=${ps_outputs[$index]}

    _lp_connection
    assertEquals "Connection output at index ${index}" "${values[$index]}" "$lp_connection"
  done
}

if [ -n "${ZSH_VERSION-}" ]; then
  SHUNIT_PARENT="$0"
  setopt shwordsplit ksh_arrays
fi

. ./shunit2
