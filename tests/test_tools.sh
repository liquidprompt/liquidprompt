
# Error on unset variables
set -u

LP_ROOT="${PWD%/tests}"
SSH_CONNECTION="1.2.3.4 111 5.6.7.8 222"

function setUp {
  cd "$LP_ROOT"
}

function test_theme_preview {
  # This does not really test the tool, just verify that it does not error.
  . ./tools/theme-preview.sh default
  . ./tools/theme-preview.sh powerline ./themes/powerline/powerline.theme
  . ./tools/theme-preview.sh powerline_full ./themes/powerline/powerline.theme
  . ./tools/theme-preview.sh alternate_vcs ./themes/alternate_vcs/alternate_vcs.theme
}

function test_external_tool_tester {
  . ./tools/external-tool-tester.sh >/dev/null
}

if [ -n "${ZSH_VERSION-}" ]; then
  SHUNIT_PARENT="$0"
  setopt shwordsplit
fi

. ./shunit2
