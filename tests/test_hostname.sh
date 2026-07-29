
# Error on unset variables
set -u

if [ -n "${ZSH_VERSION-}" ]; then
  SHUNIT_PARENT="$0"
  setopt shwordsplit ksh_arrays
fi

. ../liquidprompt --no-activate

# Liquidprompt depends on PS1 being set to detect if it has installed itself.
PS1="$ "

function test_hostname_method_fqdn_trim {

  hostname() {
    printf 'foo.bar.example.com\n'
  }

  LP_HOSTNAME_ALWAYS=1
  LP_HOSTNAME_METHOD=fqdn

  typeset lp_hostname

  LP_HOSTNAME_TRIM=0
  lp_hostname=
  _lp_hostname
  assertEquals "fqdn trim of 0 (default)" "foo.bar.example.com" "$lp_hostname"

  LP_HOSTNAME_TRIM=1
  lp_hostname=
  _lp_hostname
  assertEquals "fqdn trim of 1" "foo.bar.example" "$lp_hostname"

  LP_HOSTNAME_TRIM=2
  lp_hostname=
  _lp_hostname
  assertEquals "fqdn trim of 2" "foo.bar" "$lp_hostname"

  LP_HOSTNAME_TRIM=5
  lp_hostname=
  _lp_hostname
  assertEquals "fqdn trim longer than domain" "foo" "$lp_hostname"

  LP_HOSTNAME_TRIM=-1
  lp_hostname=
  _lp_hostname
  assertEquals "fqdn trim of -1 keeps first section" "foo" "$lp_hostname"

  LP_HOSTNAME_TRIM=-2
  lp_hostname=
  _lp_hostname
  assertEquals "fqdn trim of -2 keeps two sections" "foo.bar" "$lp_hostname"

  LP_HOSTNAME_TRIM=-4
  lp_hostname=
  _lp_hostname
  assertEquals "fqdn trim of -4 keeps all sections" "foo.bar.example.com" "$lp_hostname"

  LP_HOSTNAME_TRIM=-5
  lp_hostname=
  _lp_hostname
  assertEquals "fqdn negative trim longer than domain" "foo.bar.example.com" "$lp_hostname"

  LP_HOSTNAME_TRIM=example.com
  lp_hostname=
  _lp_hostname
  assertEquals "fqdn trim of matching domain string" "foo.bar" "$lp_hostname"

  LP_HOSTNAME_TRIM=.example.com
  lp_hostname=
  _lp_hostname
  assertEquals "fqdn trim of domain string with leading dot" "foo.bar" "$lp_hostname"

  LP_HOSTNAME_TRIM=example.org
  lp_hostname=
  _lp_hostname
  assertEquals "fqdn trim of non-matching domain string" "foo.bar.example.com" "$lp_hostname"

  LP_HOSTNAME_TRIM=foo.bar.example.com
  lp_hostname=
  _lp_hostname
  assertEquals "fqdn trim of entire hostname string" "foo.bar.example.com" "$lp_hostname"

  hostname() {
    return 1
  }

  HOSTNAME=srv.example.com
  LP_HOSTNAME_TRIM=2
  lp_hostname=
  _lp_hostname
  assertEquals "fqdn trim fallback to full hostname" "srv" "$lp_hostname"
}

function test_hostname_method_full_trim {

  LP_HOSTNAME_ALWAYS=1
  LP_HOSTNAME_METHOD=full
  HOSTNAME=foo.bar.example.com

  typeset lp_hostname

  LP_HOSTNAME_TRIM=0
  lp_hostname=
  _lp_hostname
  assertEquals "full trim of 0 (default)" "foo.bar.example.com" "$lp_hostname"

  LP_HOSTNAME_TRIM=2
  lp_hostname=
  _lp_hostname
  assertEquals "full trim of 2" "foo.bar" "$lp_hostname"

  LP_HOSTNAME_TRIM=example.com
  lp_hostname=
  _lp_hostname
  assertEquals "full trim of matching domain string" "foo.bar" "$lp_hostname"

  LP_HOSTNAME_TRIM=-1
  lp_hostname=
  _lp_hostname
  assertEquals "full trim of -1 keeps first section" "foo" "$lp_hostname"
}

function test_hostname_method_short_trim {

  LP_HOSTNAME_ALWAYS=1
  LP_HOSTNAME_METHOD=short
  LP_HOSTNAME_TRIM=2
  HOSTNAME=foo.bar.example.com

  # short is aliased to full with LP_HOSTNAME_TRIM=-1 at config load
  lp_activate --no-config

  assertEquals "short is aliased to full" "full" "$LP_HOSTNAME_METHOD"
  assertEquals "short overrides LP_HOSTNAME_TRIM" "-1" "$LP_HOSTNAME_TRIM"

  typeset lp_hostname
  lp_hostname=
  _lp_hostname
  assertEquals "short shows the first section" "foo" "$lp_hostname"
}

. ./shunit2
