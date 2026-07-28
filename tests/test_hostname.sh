
# Error on unset variables
set -u

if [ -n "${ZSH_VERSION-}" ]; then
  SHUNIT_PARENT="$0"
  setopt shwordsplit ksh_arrays
fi

. ../liquidprompt --no-activate

function test_hostname_method_fqdn_trimmed {

  hostname() {
    printf 'foo.bar.example.com\n'
  }

  LP_HOSTNAME_ALWAYS=1
  LP_HOSTNAME_METHOD=fqdn_trimmed

  typeset lp_hostname

  LP_HOSTNAME_TRIM=2
  lp_hostname=
  _lp_hostname
  assertEquals "fqdn_trimmed trim of 2 (default)" "foo.bar" "$lp_hostname"

  LP_HOSTNAME_TRIM=1
  lp_hostname=
  _lp_hostname
  assertEquals "fqdn_trimmed trim of 1" "foo.bar.example" "$lp_hostname"

  LP_HOSTNAME_TRIM=0
  lp_hostname=
  _lp_hostname
  assertEquals "fqdn_trimmed trim of 0" "foo.bar.example.com" "$lp_hostname"

  LP_HOSTNAME_TRIM=5
  lp_hostname=
  _lp_hostname
  assertEquals "fqdn_trimmed trim longer than domain" "foo" "$lp_hostname"

  hostname() {
    return 1
  }

  HOSTNAME=srv.example.com
  LP_HOSTNAME_TRIM=2
  lp_hostname=
  _lp_hostname
  assertEquals "fqdn_trimmed fallback to full hostname" "srv" "$lp_hostname"
}

. ./shunit2
