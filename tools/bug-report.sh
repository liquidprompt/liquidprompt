
# Do NOT error on failed commands
set +e

if ! (return 0 2>/dev/null); then
  printf 'Error: script must be sourced to load config options correctly
  Ex: source %s\n' "$0" >&2
  exit 1
fi

report="bug-report.txt"

if [[ -f "$report" ]]; then
  printf '"%s" already exists, refusing to overwrite!\n' "$report" >&2
  return 1
fi

(
  if [[ -n "${ZSH_VERSION-}" ]]; then
      printf -- '---Shell: Zsh\n\n'
      typeset -m PS1
      typeset -m 'LP_*'

    SCRIPT_DIR="${0:A:h}"
  else
    printf -- '---Shell: Bash\n\n'

    printf 'PROMPT_COMMAND:\n'
    printf '%q\n' "${PROMPT_COMMAND[@]}"
    printf '\n'

    vars="$(compgen -A variable LP_)"
    IFS=$'\n'
    for var in PS1 $vars; do
      printf '%s=%s\n' "$var" "${!var}"
    done

    SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
  fi

  printf -- '\n---Git details:\ngit describe: "%s"\ngit rev-parse: "%s"\n\n' \
    "$(git describe 2>/dev/null)" "$(git rev-parse HEAD 2>/dev/null)"

  "${SCRIPT_DIR}/external-tool-tester.sh"
) >>"$report"

printf 'Bug report written to %s\nAttach the file in a GitHub issue comment.\n' "$report" >&2
