#!/bin/bash

if [[ -n ${1+x} ]]; then
  shells=("$@")
else
  shells=(bash zsh)
fi

cd "${0%/*}/tests"

if [ ! -r shunit2 ]; then
  curl https://raw.githubusercontent.com/kward/shunit2/v2.1.8/shunit2 -O
fi

typeset -a testing_shells

for shell in "${shells[@]}"; do
  if command -v "$shell" >/dev/null; then
    testing_shells+=("$shell")
    printf 'shell "%s": version "%s"\n' "$shell" "$("$shell" --version)"
  else
    printf "Cannot find shell '%s', skipping tests\n" "$shell" >&2
  fi
done

typeset -i fail=0

for test_file in ./test_*.sh; do
  for shell in "${testing_shells[@]}"; do
    printf "\nRunning shell '%s' with test '%s'\n" "$shell" "$test_file"
    "$shell" "$test_file" || fail+=1
  done
done

exit "$fail"
