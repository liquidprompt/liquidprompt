
<!-- Provide a description here -->

<!-- Related issue: #XXX -->


# Technical checklist:

- code follows our [shell standards](https://github.com/liquidprompt/liquidprompt/wiki/Shell-standards):
    - [ ] correct use of `IFS`
    - [ ] careful quoting
    - [ ] cautious array access
    - [ ] portable array indexing with `_LP_FIRST_INDEX`
    - [ ] printing a "%" character is done with `_LP_PERCENT`
    - [ ] functions/variable naming conventions
    - [ ] functions have local variables
    - [ ] data functions have optimization guards (early exits)
    - [ ] subshells are avoided as much as possible
    - [ ] string substitutions may be done differently in Bash and Zsh (use `_LP_SHELL_*`)
- tests and checks have been added, ran, and their warnings fixed:
    - [ ] unit tests have been updated (see `tests/test_*.sh` files)
    - [ ] ran `tests.sh`
    - [ ] ran `shellcheck.sh` (requires [shellcheck](https://github.com/koalaman/shellcheck#user-content-installing)).
- documentation have been updated accordingly:
    - [ ] functions and attributes are documented in alphabetical order
    - [ ] new sections are documented in the default theme
    - [ ] tag `.. versionadded:: X.Y` or `.. versionchanged:: Y.Z`
    - [ ] functions signatures have arguments, returned code, and set value(s)
    - [ ] attributes have types and defaults
    - [ ] ran `docs/docs-lint.sh` (requires Python 3 and `requirements.txt`
          installed (`cd docs/; python3 -m venv venv; . venv/bin/activate; pip install -r requirements.txt`))


