# Error on unset variables
set -u

if [ -n "${ZSH_VERSION-}" ]; then
  SHUNIT_PARENT="$0"
  setopt shwordsplit ksh_arrays
fi

. ../liquidprompt --no-activate

LP_ENABLE_VIRTUALENV=1

test_python_venv() {
  VIRTUAL_ENV="$SHUNIT_TMPDIR/venv"
  mkdir "$VIRTUAL_ENV"

  _lp_python_env
  assertEquals "Python venv directory base name" venv "$lp_python_env"

  echo "prompt = virtualenv" > "$VIRTUAL_ENV/pyvenv.cfg"
  _lp_python_env
  assertEquals "Python venv config file basic" virtualenv "$lp_python_env"

  echo "prompt = 'my venv'" > "$VIRTUAL_ENV/pyvenv.cfg"
  _lp_python_env
  assertEquals "Python venv config file single quotes" "my venv" "$lp_python_env"

  echo 'prompt = "second venv"' > "$VIRTUAL_ENV/pyvenv.cfg"
  _lp_python_env
  assertEquals "Python venv config file double quotes" "second venv" "$lp_python_env"

  echo "prompt=virtualenv" > "$VIRTUAL_ENV/pyvenv.cfg"
  _lp_python_env
  assertEquals "Python venv config file basic" virtualenv "$lp_python_env"

  echo "prompt='my venv'" > "$VIRTUAL_ENV/pyvenv.cfg"
  _lp_python_env
  assertEquals "Python venv config file single quotes" "my venv" "$lp_python_env"

  echo 'prompt="second venv"' > "$VIRTUAL_ENV/pyvenv.cfg"
  _lp_python_env
  assertEquals "Python venv config file double quotes" "second venv" "$lp_python_env"
}

. ./shunit2
