
# Error on unset variables
set -u

if [ -n "${ZSH_VERSION-}" ]; then
  SHUNIT_PARENT="$0"
  setopt shwordsplit
fi

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
  . ./tools/theme-preview.sh unfold ./themes/unfold/unfold.theme --reproducible
  . ./tools/theme-preview.sh unfold ./themes/unfold/unfold.theme --config-file contrib/presets/colors/256-colors-dark.conf
  . ./tools/theme-preview.sh --template-file=templates/minimal/minimal.ps1
}

function test_external_tool_tester {
  . ./tools/external-tool-tester.sh >/dev/null
}

function test_config_from_doc {
  . ./tools/config-from-doc.sh >/dev/null
}

. ./shunit2
