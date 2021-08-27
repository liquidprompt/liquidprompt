# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Added
- **aws**: AWS profile display ([#496], [#679], [4c8ac92])
- **bash**: Compatibility with bash-preexec ([#672])
- **env**: Return unescaped hostname in `_lp_hostname()` ([#665], [a23af79])
- **env**: Return unescaped username in `_lp_username()` ([#665], [a23af79])
- **k8s**: kubectl current context display ([#578], [#673], [#681], [d41b5c8])
- **path**: Return unescaped path in *lp_path* in `_lp_path_format()` ([a23af79])
- **ruby**: Ruby environment display ([#628], [239a574], [#676])
- **terraform**: Terraform workspace support ([#669])
- **title**: Title command feature ([#609], [#665], [0c23a33], [a23af79])

### Fixed
- **color**: `LP_COLORMAP` reverting to default value ([145f146])
- **docs**: Outdated link to Symbola font project page ([#662])
- **docs**: Small typos and license clarification ([#664], [#678], [66d1d2b])
- **path**: Add `__lp_escape()` calls to `_lp_path_format()` ([36ab8fa], [a23af79])
- **powerline**: First character color issue in Zsh and Bash-3.2 ([70ce708])
- **powerline**: Array issues in Bash-3.2 ([77dc561])
- **ruby**: Zsh crash on rbenv output parse ([#667])
- **zsh**: `local` bugs in Zsh-5.0 ([7db4ada])

### Changed
- **general**: Directly generate prompt mark instead of escape code ([#665], [1a22e1e])
- **general**: Remove backslash escaping from Zsh `__lp_escape()` ([658ce84])
- **general**: Refactor internal shell hooking implementation ([0ce7646])
- **bash**: Avoid setting any shell options ([#663], [a1d0a54])
- **env**: Lookup hostname instead of escape code ([#665], [0368523])
- **env**: Lookup username instead of escape code ([#665], [61df03a])
- **time**: Call `date` to generate time instead of escape code ([#665], [dd1f8f8])
- **tests**: All included themes run through theme-preview tester ([3b75185])
- **tests**: test.sh accepts shells as arguments ([9a2c067])
- **zsh**: Avoid setting any shell options except for promptpercent ([58969b2])

## [2.0.2] - 2021-02-22
### Fixed
- **git**: Git worktrees not being detected ([#658])

## [2.0.1] - 2021-02-07
### Added
- **docs**: Example for `lp_terminal_format()` ([#657], [954bace])
- **tests**: Tests for tools/theme-preview.sh and tools/external-tool-tester.sh ([e121179])

### Fixed
- **general**: Unset errors in liquidprompt and theme-preview on Bash-3.2 ([#656], [e121179])
- **general**: Unset errors in liquidprompt in Zsh when no terminal attached ([dc11eb4])
- **general**: Unset errors in liquidprompt on Windows ([461f0ee])
- **color**: Background of path always black, ignoring terminal background setting ([#657], [58693b0])
- **tools**: Make theme-preview.sh work in Zsh ([e121179])

### Changed
- **color**: `LP_COLOR_PATH` changed to `$NO_COL`, to follow terminal default
  foreground ([58693b0])
- **color**: `LP_COLOR_PATH_SEPARATOR` and 'LP_COLOR_PATH_SHORTENED` changed
  from light grey to grey, to be neutral on both light and dark backgrounds ([58693b0])
- **color**: `LP_COLOR_PATH_LAST_DIR` and 'LP_COLOR_PATH_VCS_ROOT` changed
  from bold white to `$BOLD`, to follow terminal default foreground ([58693b0])

## [2.0.0] - 2021-02-05
### BREAKING CHANGES
Note: these breaking changes are the only reason that this version is so much
faster. They are also on private functions and variables, which the end user
was not supposed to use. If you were using them, see the
[upgrade notes](https://liquidprompt.readthedocs.io/en/stable/upgrading/v2.0.html)
for help.

- **general**: `$_LP_SHELL_bash` and `$_LP_SHELL_zsh` contain `1` or `0` instead of `true`
  or `false` ([f681cdf])
- **general**: `_lp_color_map()` return changed from stdout to `$ret` ([e843ccf])
- **general**: `_lp_escape()` renamed to `__lp_escape()` and return changed from stdout to
  `$ret` ([f3404f9])
- **general**: `_lp_set_prompt()` renamed to `__lp_set_prompt()` ([decaece])
- **general**: `_lp_source_config()` renamed to `__lp_source_config()` ([decaece])
- **battery**: `_lp_battery()` return changed from stdout to `$lp_battery` ([3f57231])
- **battery**: `_lp_battery_color()` return changed from stdout to `$lp_battery_color` ([3f57231])
- **env**: `$lp_err` renamed to `$lp_error` ([63b9f73])
- **env**: `_lp_connection()` return changed from stdout to `$lp_connection` ([edc490f])
- **git**: `_lp_git_head_status()` return changed from stdout to `$lp_vcs_head_status` ([7c21470])
- **jobs**: `_lp_jobcount_color()` return changed from stdout to `$lp_jobcount_color` ([73f2057])
- **load**: `_lp_load_color()` return changed from stdout to `$lp_load_color` ([8a987f4])
- **path**: `_lp_get_home_tilde_collapsed()` renamed to `__lp_pwd_tilde()` and return changed from
  stdout to `$lp_pwd_tilde` ([28c13f2])
- **path**: `_lp_set_dirtrim()` renamed to `__lp_set_dirtrim()` ([decaece])
- **path**: `_lp_shorten_path()` replaced by `_lp_path_format()` ([decaece], [a35032f], [ae769dc])
- **runtime**: `_lp_runtime()` renamed to `_lp_runtime_color()` and return changed from stdout to
  `$lp_runtime_color` ([0f0fd37])
- **runtime**: `_lp_runtime_after()` renamed to `__lp_runtime_after()` ([decaece])
- **runtime**: `_lp_runtime_before()` renamed to `__lp_runtime_before()` ([decaece])
- **temperature**: `_lp_temp_acpi()` renamed to `__lp_temp_acpi()` and return changed from
  `$temperature` to `$lp_temperature` ([69c75a3])
- **temperature**: `_lp_temp_detect()` renamed to `__lp_temp_detect()` ([69c75a3])
- **temperature**: `_lp_temp_sensors()` renamed to `__lp_temp_sensors()` and return changed from
  `$temperature` to `$lp_temperature` ([69c75a3])
- **temperature**: `_lp_temperature()` changed to data function, replaced by
  `_lp_temperature_color()` and return changed from stdout to `$lp_temperature_color` ([69c75a3])
- **time**: `_lp_time()` split into `_lp_time()`, `_lp_time_color()`, `_lp_analog_time()`, and
  `_lp_analog_time_color()` ([8cb609d])
- **vcs**: `_lp_<vcs>_branch()` return changed from stdout to `$lp_vcs_branch` ([f3404f9])
- **vcs**: `_lp_<vcs>_branch_color()` functions removed, replaced by
  `_lp_vcs_details_color()` ([cafb8b2], [bf2b9c6], [1a9fcd0], [4fff496], [b523025])
- **vcs**: `_lp_smart_mark()` return changed from stdout to `$lp_smart_mark` ([9c6d073])
- **vcs**: `_lp_upwards_find()` removed, replaced by `_lp_find_vcs()` ([f434b6d])

### Deprecated
- **path**: `LP_PATH_DEFAULT` is replaced by `LP_PATH_METHOD` ([ae769dc])
- **title**: `_lp_title()` is replaced by `_lp_formatted_title()` ([46df995], [9604203], [#581])
- **utils**: `_lp_bool()` is replaced by manually storing return codes ([82ee823]).
- **utils**: `_lp_sb()` is replaced by data functions indicating if they
  returned data or not ([82ee823]).
- **utils**: `_lp_sl()` is replaced by data functions indicating if they
  returned data or not ([82ee823]).
- **utils**: `_lp_sr()` is replaced by data functions indicating if they
  returned data or not ([82ee823]).
- **vcs**: `$LP_DISABLED_VCS_PATH` variable is replaced by a
  `$LP_DISABLED_VCS_PATHS` array variable. A warning will be displayed at
  startup if your config still uses the old variable, but a compatibility shim
  is active. See the upgrade notes for help ([cad6286])

### Added
- **general**: Sphinx documentation ([0d420d2], [c7b5003], [b523025], [f9fd12e])
- **general**: Manual pages built from documentation ([#637], [13e128b])
- **general**: Command line flag `--no-activate` to skip auto shell activation when sourcing
  liquidprompt ([e122d21])
- **general**: `lp_activate()` function to reload config without needing to re-source
  liquidprompt ([e1f8bd5], [22dd760])
- **bzr**: `_lp_bzr_active()` data function ([b523025])
- **bzr**: `_lp_bzr_commit_id()` data function ([b523025])
- **bzr**: `_lp_bzr_stash_count()` data function ([b523025])
- **bzr**: `_lp_bzr_tag()` data function ([b523025])
- **bzr**: `_lp_bzr_uncommitted_files()` data function ([b523025])
- **bzr**: `_lp_bzr_uncommitted_lines()` data function ([b523025])
- **bzr**: `_lp_bzr_untracked_files()` data function ([b523025])
- **color**: `lp_terminal_format()` util function ([#486], [09cfced])
- **cpu**: Internal function `__lp_cpu_count()` to count CPU cores ([e5047c0])
- **dirstack**: Directory stack data source ([#625], [f35d9ac])
- **env**: `$LP_ENABLE_ERROR` config option ([#543], [63b9f73])
- **env**: `_lp_chroot()` data function ([c946155])
- **env**: `_lp_connected_display()` data function ([c946155])
- **env**: `_lp_error()` data function ([63b9f73])
- **env**: `_lp_hostname()` data function ([8de1a72], [6ea54e9])
- **env**: `_lp_hostname_color()` theme function ([c946155], [8de1a72], [b1a3145])
- **env**: `_lp_http_proxy()` data function ([78dee3c])
- **env**: `_lp_http_proxy_color()` theme function ([78dee3c])
- **env**: `_lp_multiplexer()` data function ([0200b99], [230c9d7])
- **env**: `_lp_python_env()` data function ([03434d3])
- **env**: `_lp_python_env_color()` theme function ([03434d3])
- **env**: `_lp_software_collections()` data function ([f4afc5d])
- **env**: `_lp_software_collections_color()` theme function ([f4afc5d])
- **env**: `_lp_sudo_active()` data function ([9ba5d28])
- **env**: `_lp_sudo_active_color()` theme function ([9ba5d28])
- **env**: `_lp_user()` data function ([9ba5d28])
- **env**: `_lp_username()` data function ([debb794])
- **env**: `_lp_username_color()` theme function ([afe3195])
- **fossil**: `_lp_fossil_active()` data function ([bf2b9c6])
- **fossil**: `_lp_fossil_commit_id()` data function ([bf2b9c6])
- **fossil**: `_lp_fossil_head_status()` data function ([bf2b9c6])
- **fossil**: `_lp_fossil_stash_count()` data function ([bf2b9c6])
- **fossil**: `_lp_fossil_uncommitted_files()` data function ([bf2b9c6])
- **fossil**: `_lp_fossil_uncommitted_lines()` data function ([bf2b9c6])
- **fossil**: `_lp_fossil_untracked_files()` data function ([bf2b9c6])
- **git**: `_lp_git_active()` data function ([70b4ef6])
- **git**: `_lp_git_commit_id()` data function ([70b4ef6])
- **git**: `_lp_git_commits_off_remote()` data function ([309b443])
- **git**: `_lp_git_staged_files()` data function ([#644], [9038ec8])
- **git**: `_lp_git_staged_lines()` data function ([#644], [9038ec8])
- **git**: `_lp_git_stash_count()` data function ([fe9919f], [bb19836])
- **git**: `_lp_git_tag()` data function ([70b4ef6], [#506])
- **git**: `_lp_git_uncommitted_files()` data function ([67dc0a9])
- **git**: `_lp_git_uncommitted_lines()` data function ([70b4ef6])
- **git**: `_lp_git_unstaged_files()` data function ([67dc0a9])
- **git**: `_lp_git_unstaged_lines()` data function ([70b4ef6])
- **git**: `_lp_git_untracked_files()` data function ([fe9919f])
- **git**: Caching for diff data functions that share targets (`files()` + `lines()`) ([8bf1772])
- **hg**: `_lp_hg_active()` data function ([1a9fcd0])
- **hg**: `_lp_hg_bookmark()` data function ([f4636e6])
- **hg**: `_lp_hg_commit_id()` data function ([1a9fcd0])
- **hg**: `_lp_hg_head_status()` data function ([1a9fcd0])
- **hg**: `_lp_hg_stash_count()` data function ([1a9fcd0])
- **hg**: `_lp_hg_tag()` data function ([1a9fcd0])
- **hg**: `_lp_hg_uncommitted_files()` data function ([1a9fcd0])
- **hg**: `_lp_hg_uncommitted_lines()` data function ([1a9fcd0])
- **hg**: `_lp_hg_untracked_files()` data function ([1a9fcd0])
- **hostname**: `__lp_hostname_hash()` internal function ([8f730c8])
- **jobs**: `$LP_ENABLE_DETACHED_SESSIONS` config option, separate from jobs ([f9038e0], [862dcfb], [#552])
- **jobs**: `_lp_detached_sessions()` data function ([73f2057], [862dcfb])
- **jobs**: `_lp_jobcount()` data function ([73f2057])
- **load**: `LP_LOAD_CAP` config option ([#650], [#530], [e058b61])
- **load**: `_lp_load()` data function ([8a987f4])
- **path**: `LP_COLOR_PATH_LAST_DIR` config option ([ae769dc])
- **path**: `LP_COLOR_PATH_SEPARATOR` config option ([ae769dc])
- **path**: `LP_COLOR_PATH_SHORTENED` config option ([ae769dc])
- **path**: `LP_COLOR_PATH_VCS_ROOT` config option ([ae769dc])
- **path**: `LP_PATH_CHARACTER_KEEP` config option ([ae769dc])
- **path**: `LP_PATH_METHOD` config option ([ae769dc])
- **path**: `LP_PATH_VCS_ROOT` config option ([ae769dc])
- **path**: `_lp_path_format()` data function ([#648], [#349], [#149], [ae769dc])
- **path**: `__lp_end_path_left_shortening()` internal function ([ae769dc])
- **path**: `__lp_get_unique_directory()` internal function ([ae769dc])
- **runtime**: `_lp_runtime_format()` data function ([0f0fd37])
- **svn**: `_lp_svn_active()` data function ([4fff496])
- **svn**: `_lp_svn_commit_id()` data function ([4fff496])
- **svn**: `_lp_svn_uncommitted_files()` data function ([4fff496])
- **svn**: `_lp_svn_uncommitted_lines()` data function ([4fff496])
- **svn**: `_lp_svn_untracked_files()` data function ([4fff496])
- **temperature**: `_lp_temperature()` as data function ([69c75a3])
- **terminal**: `_lp_terminal_device()` data function ([5076dbe])
- **tests**: Shunit2 testing suite ([#469], [46918f6], [44e3a6f], [1fe1559])
- **tests**: Tests to check if a shell supports all features that Liquidprompt
  needs ([46918f6], [5a9293d], [1fe1559])
- **tests**: Tests for `_lp_as_text()` ([6cdb860])
- **tests**: Tests for `_lp_battery()`/`acpi` ([cef9cb1])
- **tests**: Tests for `_lp_battery()`/`pmset` ([c0e74b8], [9e205f5], [37db052])
- **tests**: Tests for `_lp_connection()`/`who`+`ps` ([23eb3f2], [37db052], [cef9cb1])
- **tests**: Tests for `__lp_cpu_count()`/`ncpu` ([37db052])
- **tests**: Tests for `_lp_cpu_load()`/`sysctl` ([37db052])
- **tests**: Tests for `_lp_detached_sessions()`/`screen`+`tmux` ([23eb3f2], [37db052], [cef9cb1])
- **tests**: Tests for `__lp_hostname_hash()` internal function ([8f730c8], [37db052])
- **tests**: Tests for `__lp_is_function()` util function ([9b40ca1])
- **tests**: Tests for `__lp_line_count()` util function ([a314677])
- **tests**: Tests for `__lp_pwd_tilde()` path function ([28c13f2])
- **tests**: Tests for `__lp_temp_sensors()`/`sensors` ([23eb3f2], [cef9cb1])
- **tests**: Tests for `_lp_terminal_device()` data function ([5076dbe], [37db052], [cef9cb1])
- **tests**: Github Actions build file ([#469], [05e0a50])
- **tests**: Github Actions documentation linting ([#649], [30f977b])
- **theme**: `__lp_theme_bash_complete()` to complete themes in Bash for `lp_theme()` ([884c069])
- **theme**: `__lp_theme_list()` to list themes loaded in function memory ([884c069])
- **theme**: `__lp_theme_zsh_complete()` to complete themes in Zsh for `lp_theme()` ([884c069])
- **theme**: `_lp_default_theme_activate()` theme function ([40c4331], [45f8091])
- **theme**: `_lp_default_theme_directory()` theme function ([40c4331], [45f8091])
- **theme**: `_lp_default_theme_prompt()` theme function ([40c4331], [45f8091], [acb5430])
- **theme**: `_lp_default_theme_prompt_data()` theme function ([acb5430])
- **theme**: `_lp_default_theme_prompt_template()` theme function ([acb5430])
- **theme**: `lp_theme()` to switch themes without resourcing any
  files ([45f8091], [884c069], [#592])
- **theme**: `alternate_vcs`, the default theme with modified VCS display ([#635], [#524], [2d659f0])
- **theme**: `powerline_full`, the default theme order in Powerline style ([bcefaf3])
- **theme**: `powerline`, a clone of the Powerline prompt ([af8382b], [8de1a72], [5ef795d], [#520])
- **time**: `_lp_analog_time()` data function ([8cb609d], [bc120d5])
- **time**: `_lp_analog_time_color()` theme function ([8cb609d], [bc120d5])
- **time**: `_lp_time()` data function ([bc120d5])
- **time**: `_lp_time_color()` theme function ([bc120d5])
- **title**: `lp_formatted_title()` sets persistent title stripping terminal formatting
  sequences ([46df995], [9604203])
- **title**: `_lp_raw_title()` sets persistent title without stripping terminal formatting
  sequences ([46df995])
- **title**: `lp_title()` sets a manual title that overrides the theme set title ([46df995], [#609])
- **tools**: `external-tool-tester.sh` script to generate test data ([b699dea], [9a00ead], [4b7fd88])
- **tools**: `theme-preview.sh` script to generate standard prompt previews ([0b94b74])
- **utils**: `__lp_is_function()` util function ([9b40ca1])
- **utils**: `__lp_line_count()` util function ([a314677])
- **vcs**: `_lp_find_vcs()` to quickly find nearest VCS repo ([f434b6d], [#524])
- **vcs**: `_lp_vcs_active()` data function ([cafb8b2], [#524])
- **vcs**: `_lp_vcs_bookmark()` data function ([f4636e6], [#524])
- **vcs**: `_lp_vcs_branch()` data function ([cafb8b2], [#524])
- **vcs**: `_lp_vcs_commit_id()` data function ([cafb8b2], [#524])
- **vcs**: `_lp_vcs_commits_off_remote()` data function ([cafb8b2], [#524])
- **vcs**: `_lp_vcs_details_color()` to format VCS details regardless of VCS
  type ([cafb8b2], [f4636e6], [5c56e65], [#524])
- **vcs**: `_lp_vcs_head_status()` data function ([cafb8b2], [#524])
- **vcs**: `_lp_vcs_stash_count()` data function ([cafb8b2], [#524])
- **vcs**: `_lp_vcs_tag()` data function ([cafb8b2], [#506], [#524])
- **vcs**: `_lp_vcs_uncommitted_files()` data function ([cafb8b2], [#524])
- **vcs**: `_lp_vcs_uncommitted_lines()` data function ([cafb8b2], [#524])
- **vcs**: `_lp_vcs_unstaged_files()` data function ([cafb8b2], [#524])
- **vcs**: `_lp_vcs_unstaged_lines()` data function ([cafb8b2], [#524])
- **vcs**: `_lp_vcs_untracked_files()` data function ([cafb8b2], [#524])

### Fixed
- **general**: Issues with custom `$IFS` ([e48856b], [4ebc26e])
- **general**: Liquidprompt is now `set -u` compatible ([#354], [a8aa8c9], [cb9d71b])
- **acpi**: Temperature check printed each temp twice, slowing down check ([cf8bf97])
- **acpi**: Temperature check used extended sed syntax without declaring extended language ([eb30942])
- **battery**: Color display would break with custom `$LP_COLORMAP` array ([f3f20ec])
- **runtime**: DEBUG trap was not unset if `$LP_ENABLE_RUNTIME_BELL` was disabled ([cb9d71b])
- **sensors**: Redirect sensors error output to `/dev/null` ([#445], [4a52696])
- **time**: Add default value for `$LP_TIME_ANALOG` ([f8c1c47])
- **vcs**: VCS display for new VCS works without needing to change directories ([f434b6d])

### Changed
- **general**: Exit if shell is in interactive mode ([f2276fc])
- **general**: Load all functions at source time, not only ones enabled by the
  config ([e1f8bd5], [8cb609d])
- **general**: Remove subshells to improve speed ([#607], [9ba6e86], [e2ba86e])
- **general**: Remove uses of eval improve speed and security ([4fff496], [1a56d58])
- **color**: Better handling when `tput` is not found ([09cfced])
- **fossil**: Remove `sed` call in `_lp_fossil_branch()` ([6d94db6])
- **git**: `_lp_git_branch()` only returns a matching branch, not a fallback commit ID. Use
  `_lp_git_commit_id()` instead ([70b4ef6])
- **git**: `_lp_git_head_status()` add more matches from official git prompt, as well as details
  for partial rebases ([#527], [5c56e65])
- **jobs**: Use `__lp_line_count()` instead of `wc -l` for data function ([fb123f4])
- **load**: Display actual load average instead of normalized ([#650], [#530], [e058b61])
- **load**: `LP_LOAD_THRESHOLD` accepts floats of actual load average instead of integer centiload ([#650], [#530], [e058b61])
- **load**: Default color scale cap from 1.0 to 2.0 ([#650], [#530], [5069c22])
- **path**: `LP_COLOR_PATH` default changed from `$BOLD` to `lp_terminal_format 255 0 0 0 7` (no longer bold) ([ae769dc])
- **runtime**: Save bell escape sequence on startup to save time when sending bell to terminal
  with runtime bell ([3e615cd])
- **svn**: `_lp_svn_branch()` prefixes tag with "tag/", no longer returns current directory if no
  match found ([4fff496])
- **zsh**: Add check for Zsh >= 5.0, the versions now officially supported ([5bd80ce])

### Removed
- **tests**: `pmset-simulator` file, now integrated into `pmset` tests above ([c0e74b8])
- **tests**: `test.sh` file, unit tests integrated into `acpi` tests above ([f445eff])
- **vcsh**: `$LP_ENABLE_VCSH` config option, which did nothing ([f86a097])

## [1.12.1] - 2020-10-25
### Fixed
- **fossil**: fossil 2.11+ matching any directory as a valid repo and printing
  3 error messages ([#626])

## [1.12.0] - 2020-07-17
### Added
- **color**: Add `$MAGENTA`, `$BOLD_PURPLE`, and `$BOLD_MAGENTA` ([3fadce9])
- **color**: Add warning when `tput` is not available ([#615])
- **path**: Allow to customize the symbol before the path that shows if the
  directory is writable: `$LP_MARK_PERM` ([#430])
- **runtime**: `$LP_RUNTIME_BELL` and `$LP_RUNTIME_BELL_THRESHOLD` to ring bell
  for slow commands ([#571])

### Fixed
- **general**: use `LC_ALL=C` everywhere parsable output is needed ([#548], [#549])
- **general**: set specific `IFS` everywhere it is used ([#613])
- **bash**: workaround broken .bashrc that export `$PROMPT_COMMAND`, we now
  unexport it on startup ([#450], [#463], [#474])
- **bash**: handle unset `$_LP_RUNTIME_LAST_SECONDS` when `set -u` is set ([#605])
- **bash**: use `$BASH_VERSINFO` for when there is a non-numeric
  suffix ([#522], [0234a58])
- **battery/OS X**: newer versions of OS X failing to parse ([#476], [fefbe01])
- **color**: `$LP_COLORMAP` would break if customized with a different sized
  array ([a70e80f])
- **color**: `_lp_color_map()` would return nothing if the passed in value was
  outside the scale range ([a70e80f], [#455], [#499], [#604])
- **cpu/SunOS**: failing math operation on load average ([#479], [#480])
- **fossil**: improve branch name detection, don't match tags ([#497])
- **git**: remove `-E` from grep check for portablility ([#508])
- **git**: modifications incorrectly showing as untracked files ([#509])
- **git**: changed line check failing if file named "HEAD" existed ([#517])
- **hg**: modifications incorrectly showing as untracked files ([#509])
- **hostname**: regression in `$LP_ENABLE_FQDN` implementation ([#472])
- **hostname/SunOS**: `$LP_COLOR_HOST_HASH` erroring ([#461], [#462], [9c1c8a3])
- **jobs**: misspelled variable local declaration ([#564])
- **root**: `$LP_MARK_DEFAULT` being ignored if root ([#501], [5ee3c53])
- **runtime**: when runtime enabled, `$_` would evaluate as
  `_lp_runtime_before` ([#451])
- **runtime**: when running a multipart command line (with pipes or `;`),
  runtime would never show. Now shows runtime of whole pipeline ([#614])
- **tmux**: tmux not showing as multiplexer if custom `$TERM` set ([#563])

### Changed
- **battery**: hide battery symbol when neither charging nor discharging ([#582])
- **color**: optimize `tput` color gen ([d62bf31])
- **git**: faster `git stash` check ([#503], [93df016])

## [1.11] - 2016-06-25 - dolmen (Olivier Mengué)
### Fixed
- **OS X**: sudo feature fixed ([#443])
- **OS X**: battery level restored ([#444])

## [1.10] - 2016-05-30 - dolmen (Olivier Mengué)
### BREAKING CHANGES
- **config**: Many `$LP_ENABLE_*` settings are now static (their effect applies
  when liquidprompt is loaded, and changing them at the prompt does nothing)
  to improve speed.
- **screen**: `$LP_SCREEN_TITLE_OPEN` and `$LP_SCREEN_TITLE_CLOSE` are now
  removed to simplify the code ([#371])
- **zsh**: option 'nopromptsubst' is enabled for security reasons. This will
  unfortunately also affect evaluations of other prompt contexts such as
  RPS1. ([282359a], [#432])

### Deprecated
- **color**: `$LP_COLORMAP_x` variables are replaced by a single `$LP_COLORMAP`
  array variable. A warning will be displayed at startup if your config still
  uses the old variables, but a compatibility shim is active (will be removed
  in v2.1). ([6961f99])

### Added
- **git**: show the number of commits behind the remote ([#110], [#269], [48f1b02])
- **git**: show the rebasing/merging/cherry-picking state ([#409], [5cfd2c2])
- **hostname**: `$LP_ENABLE_FQDN` to show the fully qualified domain name of
  the host ([#254], [#277], [695d629])
- **hostname**: `LP_HOSTNAME_ALWAYS=-1` to always hide the
  hostname ([#406], [d9cb55d])
- **python**: add support for Conda (CONDA_DEFAULT_ENV) ([#425], [07be967])
- **sudo**: the color of the prompt mark is now dynamic and changes to
  `$LP_COLOR_MARK_SUDO` (default: bold red) as long as your sudo credentials
  are cached. Requires sudo 1.7.0+. This feature must be enabled with
  `LP_ENABLE_SUDO=1`. Use `sudo -K` to revoke your credentials early. This
  feature is disabled by default as there is no way to detect if the user has
  sudo rights without triggering a security alert that will annoy the
  sysadmin ([#335], [#345], [a8571bb])
- **tty**: `$LP_TTYN`: the basename of the terminal ([#357], [a97c0da], [f436867])
- **zsh**: run duration of the last command (`LP_ENABLE_RUNTIME`) is now
  supported ([#404], [#355])

### Fixed
- **general**: last statement of liquidprompt did not return 0 ([#360], [#361])
- **general**: better support for `set -u` ([a8114dd])
- **bash**: bash 3 compatibility, remove `function` syntax ([#313], [3079299])
- **battery/OS X**: handle battery edge cases. We now have a pmset simulator to
  better detect regressions ([#326], [fabc775])
- **compat**: broken path inside Midnight Commander ([#288])
- **config**: Use $XDG_CONFIG_HOME to locate the config ([#415], [#420], [#427])
- **cpu**: fix the scale that was incorrectly 0-200 (not an ideal
  fix) ([#391], [e9c35dd])
- **examples**: example.bashrc major fixes ([fdbd7ca])
- **fossil/OS X**: tag regexp to work on darwin ([#390])
- **git**: broken git work directory detection caused by typo ([64029ad])
- **grep**: clear GREP_OPTIONS and skip `grep` aliases ([#340], [#372])
- **path**: issues when $PWD contains spaces or special chars ([#369], [0e0cc12])
- **path**: escaping of special chars from $PWD (well, almost, see [#389])
- **path**: fix path growing with extra color codes each time directory is
  changed ([b53e53b])
- **temp**: try each backend (acpi/sensors) once to check it works at startup
  and disable the feature if none works. ([#410], [#319], [#381], [#387])
- **temp**: the 'sensors' command now uses the '-u' option ("raw
  output") that is easier to parse. This format is at least 7 years
  old. ([#379], [#380])
- **temp**: fix failing regex on bash ([1fc0308])
- **term**: fix detection of connection source for tmux ([#304], [#407])
- **title**: terminal sequences that were sent in the title text (the escaping
  algorithm is rewritten and now just correct) ([#416], [8605378])
- **zsh**: enable word splitting to fix `$LP_DISABLED_VCS_PATH` ([#423])
- **zsh**: fix `LP_PATH_KEEP=-1` not working ([#433])
- **zsh**: fix title escapes in zsh inside tmux/screen ([#370], [#371])
- **zsh**: rename `$status` variable in `_lp_battery()` ([#334], [0f80162])
- **zsh**: save and restore a prompt set with zsh' promptinit ([02bc49e])
- **zsh**: use zsh style symbol when `prompt_OFF()` ([eb6dafc])

### Changed
- **bash**: disable parameter expansion in PS1 ([c3d4970])
- **clock**: complete rewrite of analog clock for speed and
  correctness ([#365], [0548290])
- **dist**: Move dist/ to contrib/dist/ as files there are unmaintained ([cf01d02])
- **jobs**: optimize job count, espceially when disabled ([aa870b5])
- **path**: optimize implementation in case of `LP_PATH_KEEP=-1`: `$LP_PWD`
  becomes static ([7602c09], [#256])
- **path**: optimize implementation in case `LP_ENABLE_SHORTEN_PATH=0` on bash
  with `$PROMPT_DIRTRIM` ([8da3314])
- **runtime**: refactor runtime system ([03c73fe], [d485ed1])
- **zsh**: disable `$PROMPT_COMMAND` hacks and only use zsh built in
  hooks ([5fa9054])
- **zsh**: disable existing hooks at startup ([454112f])
- **zsh**: explicitly set the shell options we need (instead of relying on
  the shell default settings) ([282359a])

## [1.9] - 2014-11-12 - dolmen (Olivier Mengué)
### Added
- **temp/linux** guard against any future language change of the `acpi`
  command ([1c65748])
- **vcsh**: vcsh support ([#148], [#287], [e927985])
- **venv**: support for Software Collections ([#299], [#300], [cc1be7e])

### Fixed
- **general**: lots of variable quoting fixes
- **general**: save user IFS and restore it to avoid echo ([#267], [782fad0])
- **bash**: save and set shell option promptvars ([62f0270])
- **bash**: workaround broken pattern substitution in bash
  4.2 ([#289], [#294], [#302], [5813a71])
- **battery**: general fixes ([#265])
- **battery/OS X**: fix for computers without battery (like iMacs) ([#317])
- **bazar**: `_lp_bzr_branch_color()` for zsh ([#301], [#303])
- **clock**: fix analog clock hour for 12AM and 12PM ([#273])
- **color**: fix `tput` usage on BSDs ([4572bd0])
- **git**: count merge commits when checking differences with remote
  branch ([7e7734e])
- **git**: use --porcelain for `git status` ([#270], [89540d3])
- **hostname**: fix colorization for SSH ([9633ac8])
- **jobs**: fix when screen/tmux are not installed ([#304], [07d18d4])
- **mark**: losing space when `$LP_MARK_DEFAULT` not quoted ([#268], [c9bdefe])
- **screen**: counting screen sessions running with extra
  parameters ([#261], [5f8fcc4])
- **svn**: fix branch/tag name extraction ([#117], [#237], [c98f16d])
- **svn**: support paths that are not branches or trunk ([#293], [5425a5e])
- **temp/linux** fix for negative temperature values ([#308], [7402f79])
- **term**: fix `$TERM` check ([#291], [dc7be25])
- **zsh**: make `$LP_OLD_PROMPT_COMMAND` work ([81b080e])

### Changed
- **general**: apply some shellcheck.com suggestions
- **color**: optimize colormap when `LP_PERCENT_ALWAYS=1` ([ee63435])
- **fossil**: cleanup and optimization ([#274])
- **git**: minor optimization ([#266])
- **git**: simplify working tree detection ([0e0cc87])
- **hg**: disabled `hg outgoing` because it is slow ([#217])
- **hg**: general cleanup for speed and fixes ([dd9a024])

### Removed
- **general**: `$LP_LIQUIDPROMPT`, use `$LP_OLD_PS1` for the same check ([ed4f383])

## [1.8] - 2014-01-15 - dolmen (Olivier Mengué)

## [1.7] - 2013-11-30 - nojhan

## [1.6] - 2013-05-14 - nojhan

## [1.5] - 2013-04-20 - nojhan

## [1.4] - 2013-04-11 - nojhan

## [1.3] - 2013-03-11 - nojhan

## [1.2] - 2013-01-16 - nojhan

## [1.1] - 2012-08-16 - nojhan

## [1.0] - 2012-08-10 - nojhan

[Unreleased]: https://github.com/nojhan/liquidprompt/compare/v2.0.2...master
[2.0.2]: https://github.com/nojhan/liquidprompt/releases/tag/v2.0.2
[2.0.1]: https://github.com/nojhan/liquidprompt/releases/tag/v2.0.1
[2.0.0]: https://github.com/nojhan/liquidprompt/releases/tag/v2.0.0
[1.12.1]: https://github.com/nojhan/liquidprompt/releases/tag/v1.12.1
[1.12.0]: https://github.com/nojhan/liquidprompt/releases/tag/v1.12.0
[1.11]: https://github.com/nojhan/liquidprompt/releases/tag/v_1.11
[1.10]: https://github.com/nojhan/liquidprompt/releases/tag/v_1.10
[1.9]: https://github.com/nojhan/liquidprompt/releases/tag/v_1.9
[1.8]: https://github.com/nojhan/liquidprompt/releases/tag/v_1.8
[1.7]: https://github.com/nojhan/liquidprompt/releases/tag/v_1.7
[1.6]: https://github.com/nojhan/liquidprompt/releases/tag/v_1.6
[1.5]: https://github.com/nojhan/liquidprompt/releases/tag/v_1.5
[1.4]: https://github.com/nojhan/liquidprompt/releases/tag/v_1.4
[1.3]: https://github.com/nojhan/liquidprompt/releases/tag/v_1.3
[1.2]: https://github.com/nojhan/liquidprompt/releases/tag/v_1.2
[1.1]: https://github.com/nojhan/liquidprompt/releases/tag/v_1.1
[1.0]: https://github.com/nojhan/liquidprompt/releases/tag/v_1.0

[#110]: https://github.com/nojhan/liquidprompt/issues/110
[#117]: https://github.com/nojhan/liquidprompt/issues/117
[#148]: https://github.com/nojhan/liquidprompt/issues/148
[#149]: https://github.com/nojhan/liquidprompt/issues/149
[#217]: https://github.com/nojhan/liquidprompt/issues/217
[#237]: https://github.com/nojhan/liquidprompt/issues/237
[#254]: https://github.com/nojhan/liquidprompt/pull/254
[#256]: https://github.com/nojhan/liquidprompt/issues/256
[#261]: https://github.com/nojhan/liquidprompt/pull/261
[#265]: https://github.com/nojhan/liquidprompt/pull/265
[#266]: https://github.com/nojhan/liquidprompt/pull/266
[#267]: https://github.com/nojhan/liquidprompt/pull/267
[#268]: https://github.com/nojhan/liquidprompt/pull/268
[#269]: https://github.com/nojhan/liquidprompt/pull/269
[#270]: https://github.com/nojhan/liquidprompt/pull/270
[#273]: https://github.com/nojhan/liquidprompt/pull/273
[#274]: https://github.com/nojhan/liquidprompt/pull/274
[#277]: https://github.com/nojhan/liquidprompt/pull/277
[#287]: https://github.com/nojhan/liquidprompt/pull/287
[#288]: https://github.com/nojhan/liquidprompt/issues/288
[#289]: https://github.com/nojhan/liquidprompt/issues/289
[#291]: https://github.com/nojhan/liquidprompt/issues/291
[#293]: https://github.com/nojhan/liquidprompt/pull/293
[#294]: https://github.com/nojhan/liquidprompt/pull/294
[#299]: https://github.com/nojhan/liquidprompt/pull/299
[#300]: https://github.com/nojhan/liquidprompt/pull/300
[#301]: https://github.com/nojhan/liquidprompt/issues/301
[#302]: https://github.com/nojhan/liquidprompt/pull/302
[#303]: https://github.com/nojhan/liquidprompt/pull/303
[#304]: https://github.com/nojhan/liquidprompt/issues/304
[#308]: https://github.com/nojhan/liquidprompt/pull/308
[#313]: https://github.com/nojhan/liquidprompt/pull/313
[#317]: https://github.com/nojhan/liquidprompt/pull/317
[#319]: https://github.com/nojhan/liquidprompt/pull/319
[#326]: https://github.com/nojhan/liquidprompt/issues/326
[#334]: https://github.com/nojhan/liquidprompt/pull/334
[#335]: https://github.com/nojhan/liquidprompt/issues/335
[#340]: https://github.com/nojhan/liquidprompt/pull/340
[#345]: https://github.com/nojhan/liquidprompt/issues/345
[#349]: https://github.com/nojhan/liquidprompt/issues/349
[#354]: https://github.com/nojhan/liquidprompt/issues/354
[#355]: https://github.com/nojhan/liquidprompt/pull/355
[#357]: https://github.com/nojhan/liquidprompt/pull/357
[#360]: https://github.com/nojhan/liquidprompt/issues/360
[#361]: https://github.com/nojhan/liquidprompt/pull/361
[#365]: https://github.com/nojhan/liquidprompt/pull/365
[#369]: https://github.com/nojhan/liquidprompt/pull/369
[#370]: https://github.com/nojhan/liquidprompt/issues/370
[#371]: https://github.com/nojhan/liquidprompt/pull/371
[#372]: https://github.com/nojhan/liquidprompt/pull/372
[#379]: https://github.com/nojhan/liquidprompt/issues/379
[#380]: https://github.com/nojhan/liquidprompt/pull/380
[#381]: https://github.com/nojhan/liquidprompt/pull/381
[#387]: https://github.com/nojhan/liquidprompt/pull/387
[#389]: https://github.com/nojhan/liquidprompt/issues/389
[#390]: https://github.com/nojhan/liquidprompt/pull/390
[#391]: https://github.com/nojhan/liquidprompt/pull/391
[#404]: https://github.com/nojhan/liquidprompt/pull/404
[#406]: https://github.com/nojhan/liquidprompt/pull/406
[#407]: https://github.com/nojhan/liquidprompt/issues/407
[#409]: https://github.com/nojhan/liquidprompt/pull/409
[#410]: https://github.com/nojhan/liquidprompt/issues/410
[#415]: https://github.com/nojhan/liquidprompt/issues/415
[#416]: https://github.com/nojhan/liquidprompt/pull/416
[#420]: https://github.com/nojhan/liquidprompt/issues/420
[#423]: https://github.com/nojhan/liquidprompt/pull/423
[#425]: https://github.com/nojhan/liquidprompt/pull/425
[#427]: https://github.com/nojhan/liquidprompt/pull/427
[#430]: https://github.com/nojhan/liquidprompt/pull/430
[#432]: https://github.com/nojhan/liquidprompt/pull/432
[#433]: https://github.com/nojhan/liquidprompt/pull/433
[#443]: https://github.com/nojhan/liquidprompt/pull/443
[#444]: https://github.com/nojhan/liquidprompt/pull/444
[#445]: https://github.com/nojhan/liquidprompt/issues/445
[#450]: https://github.com/nojhan/liquidprompt/issues/450
[#451]: https://github.com/nojhan/liquidprompt/issues/451
[#455]: https://github.com/nojhan/liquidprompt/pull/455
[#461]: https://github.com/nojhan/liquidprompt/issues/461
[#462]: https://github.com/nojhan/liquidprompt/pull/462
[#463]: https://github.com/nojhan/liquidprompt/issues/463
[#469]: https://github.com/nojhan/liquidprompt/issues/469
[#472]: https://github.com/nojhan/liquidprompt/issues/472
[#474]: https://github.com/nojhan/liquidprompt/issues/474
[#476]: https://github.com/nojhan/liquidprompt/pull/476
[#479]: https://github.com/nojhan/liquidprompt/issues/479
[#480]: https://github.com/nojhan/liquidprompt/pull/480
[#486]: https://github.com/nojhan/liquidprompt/issues/486
[#496]: https://github.com/nojhan/liquidprompt/pull/496
[#497]: https://github.com/nojhan/liquidprompt/pull/497
[#499]: https://github.com/nojhan/liquidprompt/issues/499
[#501]: https://github.com/nojhan/liquidprompt/issues/501
[#503]: https://github.com/nojhan/liquidprompt/pull/503
[#506]: https://github.com/nojhan/liquidprompt/issues/506
[#508]: https://github.com/nojhan/liquidprompt/pull/508
[#509]: https://github.com/nojhan/liquidprompt/pull/509
[#517]: https://github.com/nojhan/liquidprompt/issues/517
[#520]: https://github.com/nojhan/liquidprompt/issues/520
[#522]: https://github.com/nojhan/liquidprompt/issues/522
[#523]: https://github.com/nojhan/liquidprompt/pull/523
[#524]: https://github.com/nojhan/liquidprompt/issues/524
[#524]: https://github.com/nojhan/liquidprompt/issues/524
[#527]: https://github.com/nojhan/liquidprompt/issues/527
[#530]: https://github.com/nojhan/liquidprompt/issues/530
[#543]: https://github.com/nojhan/liquidprompt/issues/543
[#548]: https://github.com/nojhan/liquidprompt/issues/548
[#549]: https://github.com/nojhan/liquidprompt/pull/549
[#552]: https://github.com/nojhan/liquidprompt/issues/552
[#563]: https://github.com/nojhan/liquidprompt/issues/563
[#564]: https://github.com/nojhan/liquidprompt/issues/564
[#571]: https://github.com/nojhan/liquidprompt/pull/571
[#578]: https://github.com/nojhan/liquidprompt/pull/578
[#581]: https://github.com/nojhan/liquidprompt/issues/581
[#582]: https://github.com/nojhan/liquidprompt/pull/582
[#592]: https://github.com/nojhan/liquidprompt/issues/592
[#604]: https://github.com/nojhan/liquidprompt/pull/604
[#605]: https://github.com/nojhan/liquidprompt/pull/605
[#607]: https://github.com/nojhan/liquidprompt/issues/607
[#609]: https://github.com/nojhan/liquidprompt/issues/609
[#613]: https://github.com/nojhan/liquidprompt/issues/613
[#614]: https://github.com/nojhan/liquidprompt/issues/614
[#615]: https://github.com/nojhan/liquidprompt/issues/615
[#625]: https://github.com/nojhan/liquidprompt/pull/625
[#626]: https://github.com/nojhan/liquidprompt/issues/626
[#628]: https://github.com/nojhan/liquidprompt/pull/628
[#635]: https://github.com/nojhan/liquidprompt/pull/635
[#637]: https://github.com/nojhan/liquidprompt/pull/637
[#644]: https://github.com/nojhan/liquidprompt/issues/644
[#648]: https://github.com/nojhan/liquidprompt/pull/648
[#649]: https://github.com/nojhan/liquidprompt/pull/649
[#650]: https://github.com/nojhan/liquidprompt/pull/650
[#656]: https://github.com/nojhan/liquidprompt/issues/656
[#657]: https://github.com/nojhan/liquidprompt/issues/657
[#658]: https://github.com/nojhan/liquidprompt/issues/658
[#662]: https://github.com/nojhan/liquidprompt/pull/662
[#663]: https://github.com/nojhan/liquidprompt/pull/663
[#664]: https://github.com/nojhan/liquidprompt/pull/664
[#665]: https://github.com/nojhan/liquidprompt/pull/665
[#667]: https://github.com/nojhan/liquidprompt/issues/667
[#669]: https://github.com/nojhan/liquidprompt/pull/669
[#672]: https://github.com/nojhan/liquidprompt/pull/672
[#673]: https://github.com/nojhan/liquidprompt/pull/673
[#676]: https://github.com/nojhan/liquidprompt/issues/676
[#678]: https://github.com/nojhan/liquidprompt/pull/678
[#679]: https://github.com/nojhan/liquidprompt/pull/679
[#681]: https://github.com/nojhan/liquidprompt/pull/681

[0200b99]: https://github.com/nojhan/liquidprompt/commit/0200b99ebd8485ba8ba2c91da7703e87c40ec15d
[0234a58]: https://github.com/nojhan/liquidprompt/commit/0234a581d023fb6c40e5339f6dcbd619a33b4553
[02bc49e]: https://github.com/nojhan/liquidprompt/commit/02bc49edf306749c47d7a389dc916cb68e992cc8
[03434d3]: https://github.com/nojhan/liquidprompt/commit/03434d388686792b6ed2aa0bf0e09851c90a7479
[0368523]: https://github.com/nojhan/liquidprompt/commit/036852371680a9e92d7e341be604088e8dc0519b
[03c73fe]: https://github.com/nojhan/liquidprompt/commit/03c73fe05e5a3b48252a9f527e6e62666afbd726
[0548290]: https://github.com/nojhan/liquidprompt/commit/05482901fe86788032ab4089525c415384937a24
[05e0a50]: https://github.com/nojhan/liquidprompt/commit/05e0a502e8ae4e2a4711f5222f39c2589c6f582f
[07be967]: https://github.com/nojhan/liquidprompt/commit/07be96765bbd742c5c2846ef6adbb0c253948216
[07d18d4]: https://github.com/nojhan/liquidprompt/commit/07d18d4ca3f4a77377591d62dc054e00f4616cc7
[09cfced]: https://github.com/nojhan/liquidprompt/commit/09cfced24745dd7aea086a292ab042f070ce4fbb
[0b94b74]: https://github.com/nojhan/liquidprompt/commit/0b94b74d02046077a21d3fb83842c6a1fe74f6e5
[0c23a33]: https://github.com/nojhan/liquidprompt/commit/0c23a33eacc6ced0febc1a750c748010c3a87ad5
[0ce7646]: https://github.com/nojhan/liquidprompt/commit/0ce764653a5f000598b6ad11c974fcefb65832da
[0d420d2]: https://github.com/nojhan/liquidprompt/commit/0d420d2f3ac84a83e150110f9e09fc21e919df7f
[0e0cc12]: https://github.com/nojhan/liquidprompt/commit/0e0cc12fabc474b6c0cfed7abf80c9f61efb68fc
[0e0cc87]: https://github.com/nojhan/liquidprompt/commit/0e0cc870c2dcf3fbfed1b2e187e918d74dd6d3db
[0f0fd37]: https://github.com/nojhan/liquidprompt/commit/0f0fd3739a8dd9821b34b78859de13b47b2d856d
[0f80162]: https://github.com/nojhan/liquidprompt/commit/0f80162f1f22277e497b69f243894a87fcaec643
[13e128b]: https://github.com/nojhan/liquidprompt/commit/13e128bb320034a0303f7354fad66a5674c6b4da
[145f146]: https://github.com/nojhan/liquidprompt/commit/145f146e9cb4fb3c30a22e6c35529120f4650a28
[1a22e1e]: https://github.com/nojhan/liquidprompt/commit/1a22e1ec54ad46a311ed9bdd65ed2bd1459e606e
[1a56d58]: https://github.com/nojhan/liquidprompt/commit/1a56d58d4e63f395545fed820278c5b4561dfa95
[1a9fcd0]: https://github.com/nojhan/liquidprompt/commit/1a9fcd0944711ccab20045e5a3f3bde9d7f0ec59
[1c65748]: https://github.com/nojhan/liquidprompt/commit/1c657481fd3481720b54187f9aa464df0e62a3f2
[1fc0308]: https://github.com/nojhan/liquidprompt/commit/1fc030813069ebc0cfc0542d049a9e4998100490
[1fe1559]: https://github.com/nojhan/liquidprompt/commit/1fe1559ebb18ae2ff39e1c4703a06d35f0f6538f
[22dd760]: https://github.com/nojhan/liquidprompt/commit/22dd760926c3a7b8e4f4fa28902d43b06e68e6a8
[230c9d7]: https://github.com/nojhan/liquidprompt/commit/230c9d7d45c10b8f319b9d5c64b4fd59261c8008
[239a574]: https://github.com/nojhan/liquidprompt/commit/239a5740866962a40a614057065188810830207d
[23eb3f2]: https://github.com/nojhan/liquidprompt/commit/23eb3f23b633a8e849f91867948c96976108df6b
[282359a]: https://github.com/nojhan/liquidprompt/commit/282359a4b7c80a6032ec043eddb1bf378084e64e
[28c13f2]: https://github.com/nojhan/liquidprompt/commit/28c13f27e652b84373a7c73389cbd0a5a10b88c3
[2d659f0]: https://github.com/nojhan/liquidprompt/commit/2d659f04628a804409e6262733f0f909c3c2675b
[3079299]: https://github.com/nojhan/liquidprompt/commit/3079299f816ee2d893c2b7c2284e9e6034164d16
[309b443]: https://github.com/nojhan/liquidprompt/commit/309b443461a25f552754663d3d67a5ee0f97571f
[30f977b]: https://github.com/nojhan/liquidprompt/commit/30f977b09f6ee36c38e1ec07a272b5b0e621729f
[36ab8fa]: https://github.com/nojhan/liquidprompt/commit/36ab8fa8ff7c27284163aebbfcb9f82fc2f572ac
[37db052]: https://github.com/nojhan/liquidprompt/commit/37db052c18d99fc36f4c4a4ede798155e519e2ca
[3b75185]: https://github.com/nojhan/liquidprompt/commit/3b751856bfe701f38f842e8ae96d803a3990f13d
[3e615cd]: https://github.com/nojhan/liquidprompt/commit/3e615cded01b583870a7e6e9529f341280eb40a6
[3f57231]: https://github.com/nojhan/liquidprompt/commit/3f57231d73112ea1090e3a607539e515f21de794
[3fadce9]: https://github.com/nojhan/liquidprompt/commit/3fadce962396d6d3a1f7c2c8e23c1d9fdc22c098
[40c4331]: https://github.com/nojhan/liquidprompt/commit/40c4331f6eda1cb836e8ae62426cb7755fdec371
[44e3a6f]: https://github.com/nojhan/liquidprompt/commit/44e3a6fe8ea9aa61f7cedb32286eb321fc93c6ed
[454112f]: https://github.com/nojhan/liquidprompt/commit/454112f385c49e0bdf408ffd6123f8eaa39d0b0c
[4572bd0]: https://github.com/nojhan/liquidprompt/commit/4572bd02fa289b989de3d24e246be187dbd25f65
[45f8091]: https://github.com/nojhan/liquidprompt/commit/45f80913da7aaf869a80288c5433c4d71ffc28c4
[461f0ee]: https://github.com/nojhan/liquidprompt/commit/461f0ee05e1466a0f14afebcbc2aaeabe711e38a
[46918f6]: https://github.com/nojhan/liquidprompt/commit/46918f62ef80f26bec379a5542d669654e5e3280
[46df995]: https://github.com/nojhan/liquidprompt/commit/46df99503698c838ad6bb9c030a271e9fda87b15
[48f1b02]: https://github.com/nojhan/liquidprompt/commit/48f1b022dd078ce45f786a28dbe75a8acea37031
[4a52696]: https://github.com/nojhan/liquidprompt/commit/4a526965cba546978423a4d51bfbb0a2d1000246
[4b7fd88]: https://github.com/nojhan/liquidprompt/commit/4b7fd88da0777d005d67d28d285be9255f1666c7
[4c8ac92]: https://github.com/nojhan/liquidprompt/commit/4c8ac9219f4191a458a9d472360f54d24060f2d6
[4ebc26e]: https://github.com/nojhan/liquidprompt/commit/4ebc26e92be20ddf5d068fb25d2cecfcf479c1ea
[4fff496]: https://github.com/nojhan/liquidprompt/commit/4fff49644a86fe93f1373825f09e1b1fdfb20f54
[5069c22]: https://github.com/nojhan/liquidprompt/commit/5069c22dbece5ef8726b1393df5ae91550a2b3fe
[5076dbe]: https://github.com/nojhan/liquidprompt/commit/5076dbe68788586f317c4d0590e1ea60e4dec07a
[5425a5e]: https://github.com/nojhan/liquidprompt/commit/5425a5eb56433d4332441d37eae69d159ab456c1
[5813a71]: https://github.com/nojhan/liquidprompt/commit/5813a710fc0feb2970e1d1e6615f822777b111c7
[58693b0]: https://github.com/nojhan/liquidprompt/commit/58693b0664964e2a06b46fa8d5bdffd23ada417f
[58969b2]: https://github.com/nojhan/liquidprompt/commit/58969b205f484dbf9ac5c151db81a2cc4c3762d6
[5a9293d]: https://github.com/nojhan/liquidprompt/commit/5a9293db78cad4739f2b105e1c438d21372c25f1
[5bd80ce]: https://github.com/nojhan/liquidprompt/commit/5bd80ce1da07adc501a46c375eae0ca741f3960e
[5c56e65]: https://github.com/nojhan/liquidprompt/commit/5c56e65888d92f9f0239096c02ac86e568d53ad1
[5cfd2c2]: https://github.com/nojhan/liquidprompt/commit/5cfd2c2e7a892d1435cfd7b61cce697d5658db5c
[5ee3c53]: https://github.com/nojhan/liquidprompt/commit/5ee3c53cbbc95b5288fe5baf5a3c5b21d2a7212d
[5ef795d]: https://github.com/nojhan/liquidprompt/commit/5ef795d262839e99183db00a3dc7572e06f9b610
[5f8fcc4]: https://github.com/nojhan/liquidprompt/commit/5f8fcc46eade20015291833118055b7cd76a5c0a
[5fa9054]: https://github.com/nojhan/liquidprompt/commit/5fa905481c9c7c4579cadc0065648b6617b9c775
[61df03a]: https://github.com/nojhan/liquidprompt/commit/61df03a02367e29f80d470196b4cc193729ef37a
[62f0270]: https://github.com/nojhan/liquidprompt/commit/62f0270888ec668ec50df2af826727ca8ba9d6c6
[63b9f73]: https://github.com/nojhan/liquidprompt/commit/63b9f73d72218d4e72c0d43bc6a60a82ea0e15e8
[64029ad]: https://github.com/nojhan/liquidprompt/commit/64029ad75d108a0619958c337fd64fe18560988e
[658ce84]: https://github.com/nojhan/liquidprompt/commit/658ce84cc81c283b840355b4f1afdac035abd3b7
[66d1d2b]: https://github.com/nojhan/liquidprompt/commit/66d1d2ba3baade138d7470317aca527c138732fe
[67dc0a9]: https://github.com/nojhan/liquidprompt/commit/67dc0a9ae9eebf0c2b85b4ee6fc2d6b5562b6412
[695d629]: https://github.com/nojhan/liquidprompt/commit/695d629dd5cf7109e8892075d4cf7fadd8c17d94
[6961f99]: https://github.com/nojhan/liquidprompt/commit/6961f998b83f491995ce731bd232c5170cf4be5f
[69c75a3]: https://github.com/nojhan/liquidprompt/commit/69c75a3e6c4998d682e480fb3df935e4eb224444
[6cdb860]: https://github.com/nojhan/liquidprompt/commit/6cdb86006e4d2ad6dee06e60e229842144305594
[6d94db6]: https://github.com/nojhan/liquidprompt/commit/6d94db6de7de879c14da842df535163a57dce638
[6ea54e9]: https://github.com/nojhan/liquidprompt/commit/6ea54e91f84be1c491314c3680e82b06d769218e
[70b4ef6]: https://github.com/nojhan/liquidprompt/commit/70b4ef65c034c5050173dbe70178b459e5acddc2
[70ce708]: https://github.com/nojhan/liquidprompt/commit/70ce708b8142d71647c14817cb40801c5dfdb756
[73f2057]: https://github.com/nojhan/liquidprompt/commit/73f205748fe6f09abcfe01ec150a456518aecc18
[7402f79]: https://github.com/nojhan/liquidprompt/commit/7402f79a7518e74e16d36c74e8b5943d11f390d7
[7602c09]: https://github.com/nojhan/liquidprompt/commit/7602c09fd7754f371db98bfad15bc075ef1ec93a
[77dc561]: https://github.com/nojhan/liquidprompt/commit/77dc561c707a88ab9158f3f00231137f8f34c624
[782fad0]: https://github.com/nojhan/liquidprompt/commit/782fad08fd37cbf2144ea203430f37608b156ae8
[78dee3c]: https://github.com/nojhan/liquidprompt/commit/78dee3c70ab73eee04a5e869172e5f07ac916774
[7c21470]: https://github.com/nojhan/liquidprompt/commit/7c214708d72a4fa7d298678167450693a1ffbc00
[7db4ada]: https://github.com/nojhan/liquidprompt/commit/7db4ada711c5e9859ea79a11a1d03ca7d7311547
[7e7734e]: https://github.com/nojhan/liquidprompt/commit/7e7734e6247a1b32d636b5e39fe99d8d23dde669
[81b080e]: https://github.com/nojhan/liquidprompt/commit/81b080e2a6e6c24a3bab9348c187fb308c25ffe8
[82ee823]: https://github.com/nojhan/liquidprompt/commit/82ee823e9cd2fb8581b653b38c4ea501b795a607
[8605378]: https://github.com/nojhan/liquidprompt/commit/86053782d08b0d41ca69f4f45dde9ce619db1008
[862dcfb]: https://github.com/nojhan/liquidprompt/commit/862dcfbe6c82bf4e4125cf584a010161a533b917
[884c069]: https://github.com/nojhan/liquidprompt/commit/884c0697b71b0f87e2ea2a88159e08d33d3c6088
[89540d3]: https://github.com/nojhan/liquidprompt/commit/89540d312543b897b3c116370deabdfe9db15dcb
[8a987f4]: https://github.com/nojhan/liquidprompt/commit/8a987f436ffc6144eab1dadaacad9c460b9bfa1f
[8bf1772]: https://github.com/nojhan/liquidprompt/commit/8bf1772d771904bd2095a974b35795c9db2c96cc
[8cb609d]: https://github.com/nojhan/liquidprompt/commit/8cb609d49cc1ba92f09adc87e3fbed243d04626e
[8da3314]: https://github.com/nojhan/liquidprompt/commit/8da33144c89075dfd2309feaa718ccf3fe693ff6
[8de1a72]: https://github.com/nojhan/liquidprompt/commit/8de1a729f7190612d573218625dc1aaf4c2f78bf
[8f730c8]: https://github.com/nojhan/liquidprompt/commit/8f730c8eb7b2488093db47045db1bcd239b02b9a
[9038ec8]: https://github.com/nojhan/liquidprompt/commit/9038ec8884f11f7cf47fbfee1c86b9dbf6440307
[93df016]: https://github.com/nojhan/liquidprompt/commit/93df0169499c4ca8563add267e95dcd343d95f12
[954bace]: https://github.com/nojhan/liquidprompt/commit/954bace48637528795743785c4cc8cb42f204a7e
[9604203]: https://github.com/nojhan/liquidprompt/commit/9604203fb9f90b44a8c806f32e7746588b70a83b
[9633ac8]: https://github.com/nojhan/liquidprompt/commit/9633ac83cad5f5702c1e853940c0ab2e166961bf
[9a00ead]: https://github.com/nojhan/liquidprompt/commit/9a00eada113cb1d5e33aa177f5b9180c25d6a843
[9a2c067]: https://github.com/nojhan/liquidprompt/commit/9a2c06709544ce7609b432aa03d81f7cf4750283
[9b40ca1]: https://github.com/nojhan/liquidprompt/commit/9b40ca139a43e51b4d0fbdc780d0661bfffbf6ae
[9ba5d28]: https://github.com/nojhan/liquidprompt/commit/9ba5d2824571d41c1aa7a3573a3cf17ed729f2bb
[9ba6e86]: https://github.com/nojhan/liquidprompt/commit/9ba6e86f8200c08543502185447185a5a4089685
[9c1c8a3]: https://github.com/nojhan/liquidprompt/commit/9c1c8a378846c23e0a39be2aadd11531c2ecf196
[9c6d073]: https://github.com/nojhan/liquidprompt/commit/9c6d073e3cc7a49cfce209ce4307881d70340161
[9e205f5]: https://github.com/nojhan/liquidprompt/commit/9e205f51db459443e5c2ead0efa76f6a33c47c24
[a1d0a54]: https://github.com/nojhan/liquidprompt/commit/a1d0a54027dba5efc5acccc630b2be432e705f67
[a23af79]: https://github.com/nojhan/liquidprompt/commit/a23af79232fc3b716dc54bc3927b3e05bd777189
[a314677]: https://github.com/nojhan/liquidprompt/commit/a314677b8031804130c69de94d4604e9c319575a
[a35032f]: https://github.com/nojhan/liquidprompt/commit/a35032fe03ab3d84093141c403a7c6615f7c38d9
[a70e80f]: https://github.com/nojhan/liquidprompt/commit/a70e80f0f501031ef97ea8baf88ca6d7ef56ad8a
[a8114dd]: https://github.com/nojhan/liquidprompt/commit/a8114dd9550e2e7fd33b93eb7885de08b3e64933
[a8571bb]: https://github.com/nojhan/liquidprompt/commit/a8571bb2920d9f11006754e634304242d929db57
[a8aa8c9]: https://github.com/nojhan/liquidprompt/commit/a8aa8c94ca6b3d6486195a2d03cf7868d995f3a2
[a97c0da]: https://github.com/nojhan/liquidprompt/commit/a97c0da0e6a6f037a6038c427a51a9ee840b45f2
[aa870b5]: https://github.com/nojhan/liquidprompt/commit/aa870b54d27cd6deda50a24f2030511d8a23c45e
[acb5430]: https://github.com/nojhan/liquidprompt/commit/acb54302d9711c6b7b8b68bc8a692ef232fb09d4
[ae769dc]: https://github.com/nojhan/liquidprompt/commit/ae769dc9a71df27c24025a6bd29e840f4d97ce08
[af8382b]: https://github.com/nojhan/liquidprompt/commit/af8382b56833e8ce08834c61c70c6eda805b413f
[afe3195]: https://github.com/nojhan/liquidprompt/commit/afe319526a14e6ab73fba175c06e7a45188a37c4
[b1a3145]: https://github.com/nojhan/liquidprompt/commit/b1a3145ae5432e39ff85d144207eb490f3af341a
[b523025]: https://github.com/nojhan/liquidprompt/commit/b523025221c2c9084a933cf545fa9cb999916323
[b53e53b]: https://github.com/nojhan/liquidprompt/commit/b53e53b6a5a5b783896b8fd75d341dbb1d7d5e5c
[b699dea]: https://github.com/nojhan/liquidprompt/commit/b699dea7aec3b081292becf52fa1899fe82c3c8b
[bb19836]: https://github.com/nojhan/liquidprompt/commit/bb198362d78310905ef213bbdedce1ace5002b99
[bc120d5]: https://github.com/nojhan/liquidprompt/commit/bc120d50c265ece6158317ddea0488919e0747dd
[bcefaf3]: https://github.com/nojhan/liquidprompt/commit/bcefaf32e9e301e13706fc5c39de814c1a2630aa
[bf2b9c6]: https://github.com/nojhan/liquidprompt/commit/bf2b9c60a788c32f38078f580b79ba80540d3bdf
[c0e74b8]: https://github.com/nojhan/liquidprompt/commit/c0e74b8953db777e1ae84fa5faa3620af5247511
[c3d4970]: https://github.com/nojhan/liquidprompt/commit/c3d49708e598a79eca50caa0f96fca6230ce204e
[c7b5003]: https://github.com/nojhan/liquidprompt/commit/c7b5003616d769ac1a4edc06d28ba6b84bfe0418
[c946155]: https://github.com/nojhan/liquidprompt/commit/c9461552d9618548d4a858b0153671cf0fdbdac3
[c98f16d]: https://github.com/nojhan/liquidprompt/commit/c98f16d52f9cc22723679124c3d64b06cbcb6e6e
[c9bdefe]: https://github.com/nojhan/liquidprompt/commit/c9bdefe020c30bb053c0815a1633e5e3be25e4ef
[cad6286]: https://github.com/nojhan/liquidprompt/commit/cad6286b6f923376a05ebe8c13a4302e91a9cfe3
[cafb8b2]: https://github.com/nojhan/liquidprompt/commit/cafb8b2e5388fd9336c316248908881a8d66a4a5
[cb9d71b]: https://github.com/nojhan/liquidprompt/commit/cb9d71b952954006ebedd66a7ea63de7562f9676
[cc1be7e]: https://github.com/nojhan/liquidprompt/commit/cc1be7e29d1b7fa6ef25e960e02da6612ff8bde9
[cef9cb1]: https://github.com/nojhan/liquidprompt/commit/cef9cb1581a419f7c7248954069fd0d4e5966284
[cf01d02]: https://github.com/nojhan/liquidprompt/commit/cf01d02445c38ee9504bad00f079af080a7bdfe2
[cf8bf97]: https://github.com/nojhan/liquidprompt/commit/cf8bf97b01a83a939eadc31b9da806172c91c444
[d41b5c8]: https://github.com/nojhan/liquidprompt/commit/d41b5c8361381fcc785494f5552a2b5319c3c9d1
[d485ed1]: https://github.com/nojhan/liquidprompt/commit/d485ed191fb6b896290a32848c4fefd0342e2046
[d62bf31]: https://github.com/nojhan/liquidprompt/commit/d62bf310d0d5a30fac6d047f03d832b81070c884
[d9cb55d]: https://github.com/nojhan/liquidprompt/commit/d9cb55da834720ac3cd4893bb4a35808ab67d376
[dc11eb4]: https://github.com/nojhan/liquidprompt/commit/dc11eb48ecb133930355f396578e5c9b06b49afc
[dc7be25]: https://github.com/nojhan/liquidprompt/commit/dc7be2540d677600a484dcd0c2d05dc0945382e5
[dd1f8f8]: https://github.com/nojhan/liquidprompt/commit/dd1f8f873e6d71b9dc9d9a820cd7fe1a3f313c67
[dd9a024]: https://github.com/nojhan/liquidprompt/commit/dd9a024b485d9c017aa935809bd20e7436dff46c
[debb794]: https://github.com/nojhan/liquidprompt/commit/debb794bf2f99ab53d539e5080f0b28579333cb8
[decaece]: https://github.com/nojhan/liquidprompt/commit/decaece03b9bfe826d7f33a3fb56dfb33916884a
[e058b61]: https://github.com/nojhan/liquidprompt/commit/e058b619ce80918d3cdf924e07220a7028a8bb1b
[e121179]: https://github.com/nojhan/liquidprompt/commit/e121179d1bb943ec3673e451deac2a0577adbb75
[e122d21]: https://github.com/nojhan/liquidprompt/commit/e122d21ba14f2bdfe5fa88b70083249456c67b5b
[e1f8bd5]: https://github.com/nojhan/liquidprompt/commit/e1f8bd585d5dfc41d21d4bf88343f3a30fb3d071
[e2ba86e]: https://github.com/nojhan/liquidprompt/commit/e2ba86e0e5fc8bf5191cf8d8ac6aa1cd2b81a596
[e48856b]: https://github.com/nojhan/liquidprompt/commit/e48856b59e51731b7accab27e679154bcff53ed4
[e5047c0]: https://github.com/nojhan/liquidprompt/commit/e5047c0bbc1e95f811ae56265306851d3d5769e4
[e843ccf]: https://github.com/nojhan/liquidprompt/commit/e843ccfd7c719f84baf7e628697f78ff59703e5d
[e927985]: https://github.com/nojhan/liquidprompt/commit/e9279856c4af191d501e8e46898dde3b4447e6dd
[e9c35dd]: https://github.com/nojhan/liquidprompt/commit/e9c35ddeb473da1ac24eb27331b8974f3ba05237
[eb30942]: https://github.com/nojhan/liquidprompt/commit/eb309422009c8f8e2a105381317b71ace5d42e13
[eb6dafc]: https://github.com/nojhan/liquidprompt/commit/eb6dafc314a3dc1fc5ca560d79c408db81af0288
[ed4f383]: https://github.com/nojhan/liquidprompt/commit/ed4f3832fe2f7380ec1b7949777fffe2a7f63f34
[edc490f]: https://github.com/nojhan/liquidprompt/commit/edc490f3a3e92e9b0a94e9021a0589d64c6a7881
[ee63435]: https://github.com/nojhan/liquidprompt/commit/ee6343567d2178cd57daa89498868be6ea2ef156
[f2276fc]: https://github.com/nojhan/liquidprompt/commit/f2276fc29530fcba63bd5602364e20187a8d44c6
[f3404f9]: https://github.com/nojhan/liquidprompt/commit/f3404f99d3c08a5811eec0a8c326abe6763c6c14
[f35d9ac]: https://github.com/nojhan/liquidprompt/commit/f35d9acfddacc1f7f74174b45cf4c4aa9c84beca
[f3f20ec]: https://github.com/nojhan/liquidprompt/commit/f3f20ecbe0309842ab43d36c006e75928cd5dae4
[f434b6d]: https://github.com/nojhan/liquidprompt/commit/f434b6dc663d704e9d616b8864908371862b9e23
[f436867]: https://github.com/nojhan/liquidprompt/commit/f4368670bf258257fece5611a9aad17e88f10b5a
[f445eff]: https://github.com/nojhan/liquidprompt/commit/f445eff684558e8bf200df2f3f897c09374b7d6c
[f4636e6]: https://github.com/nojhan/liquidprompt/commit/f4636e66455a80586f20bb1ea9624a15299cea58
[f4afc5d]: https://github.com/nojhan/liquidprompt/commit/f4afc5d0a8f776c96308001fcdae4a5aa1dac2bd
[f681cdf]: https://github.com/nojhan/liquidprompt/commit/f681cdf9d8dd1d847aaf5f0b69222606a181c648
[f86a097]: https://github.com/nojhan/liquidprompt/commit/f86a097d5eb9cab2a2fbca7629e9c2c389f1e12e
[f8c1c47]: https://github.com/nojhan/liquidprompt/commit/f8c1c4770aab0a1c15f3e17b0b47a421f024f1b7
[f9038e0]: https://github.com/nojhan/liquidprompt/commit/f9038e0331df1dfedbeb442c84ec62d63a90c37d
[f9fd12e]: https://github.com/nojhan/liquidprompt/commit/f9fd12eed963ce2d64762e09b04adb06e00692a4
[fabc775]: https://github.com/nojhan/liquidprompt/commit/fabc775cb8bfe1be5a39cf577d2d2187398881b0
[fb123f4]: https://github.com/nojhan/liquidprompt/commit/fb123f4c5eee08c265eb91cc5a4d3de7e9c6c75d
[fdbd7ca]: https://github.com/nojhan/liquidprompt/commit/fdbd7ca545a2847fb3e862a6088740aa2a06c799
[fe9919f]: https://github.com/nojhan/liquidprompt/commit/fe9919f5e7dc01ba59cc85a128fea94e5b2163c4
[fefbe01]: https://github.com/nojhan/liquidprompt/commit/fefbe01d9830a9033bdb008c454c0d0590548638
