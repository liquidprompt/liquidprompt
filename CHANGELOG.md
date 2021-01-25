# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.12.1] - 2020-10-25
### Fixed
- **fossil**: fossil 1.11+ maching any directory as a valid repo and printing
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
- **jobs**: mispelled variable local declaration ([#564])
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
  in 2.0]). ([6961f99])

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
- **zsh**: explicitely set the shell options we need (instead of relying on
  the shell default settings) ([282359a])

## [1.9] - 2014-11-12 - dolmen (Olivier Mengué)
### Added
- **temp/linux** guard against any future language change of the `acpi`
  command ([1c65748])
- **vcsh**: vcsh support ([#148], [#287], [e927985])
- **venv**: support for Software Collections ([#299], [#300], [cc1be7e])

### Fixed
- **general**: lots of varable quoting fixes
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

[Unreleased]: https://github.com/nojhan/liquidprompt/compare/v_1.11...master
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
[#450]: https://github.com/nojhan/liquidprompt/issues/450
[#451]: https://github.com/nojhan/liquidprompt/issues/451
[#455]: https://github.com/nojhan/liquidprompt/pull/455
[#461]: https://github.com/nojhan/liquidprompt/issues/461
[#462]: https://github.com/nojhan/liquidprompt/pull/462
[#463]: https://github.com/nojhan/liquidprompt/issues/463
[#472]: https://github.com/nojhan/liquidprompt/issues/472
[#474]: https://github.com/nojhan/liquidprompt/issues/474
[#476]: https://github.com/nojhan/liquidprompt/pull/476
[#479]: https://github.com/nojhan/liquidprompt/issues/479
[#480]: https://github.com/nojhan/liquidprompt/pull/480
[#497]: https://github.com/nojhan/liquidprompt/pull/497
[#499]: https://github.com/nojhan/liquidprompt/issues/499
[#501]: https://github.com/nojhan/liquidprompt/issues/501
[#503]: https://github.com/nojhan/liquidprompt/pull/503
[#508]: https://github.com/nojhan/liquidprompt/pull/508
[#509]: https://github.com/nojhan/liquidprompt/pull/509
[#517]: https://github.com/nojhan/liquidprompt/issues/517
[#522]: https://github.com/nojhan/liquidprompt/issues/522
[#523]: https://github.com/nojhan/liquidprompt/pull/523
[#548]: https://github.com/nojhan/liquidprompt/issues/548
[#549]: https://github.com/nojhan/liquidprompt/pull/549
[#563]: https://github.com/nojhan/liquidprompt/issues/563
[#564]: https://github.com/nojhan/liquidprompt/issues/564
[#571]: https://github.com/nojhan/liquidprompt/pull/571
[#582]: https://github.com/nojhan/liquidprompt/pull/582
[#604]: https://github.com/nojhan/liquidprompt/pull/604
[#605]: https://github.com/nojhan/liquidprompt/pull/605
[#613]: https://github.com/nojhan/liquidprompt/issues/613
[#614]: https://github.com/nojhan/liquidprompt/issues/614
[#615]: https://github.com/nojhan/liquidprompt/issues/615
[#626]: https://github.com/nojhan/liquidprompt/issues/626

[0234a58]: https://github.com/nojhan/liquidprompt/commit/0234a581d023fb6c40e5339f6dcbd619a33b4553
[02bc49e]: https://github.com/nojhan/liquidprompt/commit/02bc49edf306749c47d7a389dc916cb68e992cc8
[03c73fe]: https://github.com/nojhan/liquidprompt/commit/03c73fe05e5a3b48252a9f527e6e62666afbd726
[0548290]: https://github.com/nojhan/liquidprompt/commit/05482901fe86788032ab4089525c415384937a24
[07be967]: https://github.com/nojhan/liquidprompt/commit/07be96765bbd742c5c2846ef6adbb0c253948216
[07d18d4]: https://github.com/nojhan/liquidprompt/commit/07d18d4ca3f4a77377591d62dc054e00f4616cc7
[0e0cc12]: https://github.com/nojhan/liquidprompt/commit/0e0cc12fabc474b6c0cfed7abf80c9f61efb68fc
[0e0cc87]: https://github.com/nojhan/liquidprompt/commit/0e0cc870c2dcf3fbfed1b2e187e918d74dd6d3db
[0f80162]: https://github.com/nojhan/liquidprompt/commit/0f80162f1f22277e497b69f243894a87fcaec643
[1c65748]: https://github.com/nojhan/liquidprompt/commit/1c657481fd3481720b54187f9aa464df0e62a3f2
[1fc0308]: https://github.com/nojhan/liquidprompt/commit/1fc030813069ebc0cfc0542d049a9e4998100490
[282359a]: https://github.com/nojhan/liquidprompt/commit/282359a4b7c80a6032ec043eddb1bf378084e64e
[3079299]: https://github.com/nojhan/liquidprompt/commit/3079299f816ee2d893c2b7c2284e9e6034164d16
[3fadce9]: https://github.com/nojhan/liquidprompt/commit/3fadce962396d6d3a1f7c2c8e23c1d9fdc22c098
[454112f]: https://github.com/nojhan/liquidprompt/commit/454112f385c49e0bdf408ffd6123f8eaa39d0b0c
[4572bd0]: https://github.com/nojhan/liquidprompt/commit/4572bd02fa289b989de3d24e246be187dbd25f65
[48f1b02]: https://github.com/nojhan/liquidprompt/commit/48f1b022dd078ce45f786a28dbe75a8acea37031
[5425a5e]: https://github.com/nojhan/liquidprompt/commit/5425a5eb56433d4332441d37eae69d159ab456c1
[5813a71]: https://github.com/nojhan/liquidprompt/commit/5813a710fc0feb2970e1d1e6615f822777b111c7
[5cfd2c2]: https://github.com/nojhan/liquidprompt/commit/5cfd2c2e7a892d1435cfd7b61cce697d5658db5c
[5ee3c53]: https://github.com/nojhan/liquidprompt/commit/5ee3c53cbbc95b5288fe5baf5a3c5b21d2a7212d
[5f8fcc4]: https://github.com/nojhan/liquidprompt/commit/5f8fcc46eade20015291833118055b7cd76a5c0a
[5fa9054]: https://github.com/nojhan/liquidprompt/commit/5fa905481c9c7c4579cadc0065648b6617b9c775
[62f0270]: https://github.com/nojhan/liquidprompt/commit/62f0270888ec668ec50df2af826727ca8ba9d6c6
[64029ad]: https://github.com/nojhan/liquidprompt/commit/64029ad75d108a0619958c337fd64fe18560988e
[695d629]: https://github.com/nojhan/liquidprompt/commit/695d629dd5cf7109e8892075d4cf7fadd8c17d94
[6961f99]: https://github.com/nojhan/liquidprompt/commit/6961f998b83f491995ce731bd232c5170cf4be5f
[7402f79]: https://github.com/nojhan/liquidprompt/commit/7402f79a7518e74e16d36c74e8b5943d11f390d7
[7602c09]: https://github.com/nojhan/liquidprompt/commit/7602c09fd7754f371db98bfad15bc075ef1ec93a
[782fad0]: https://github.com/nojhan/liquidprompt/commit/782fad08fd37cbf2144ea203430f37608b156ae8
[7e7734e]: https://github.com/nojhan/liquidprompt/commit/7e7734e6247a1b32d636b5e39fe99d8d23dde669
[81b080e]: https://github.com/nojhan/liquidprompt/commit/81b080e2a6e6c24a3bab9348c187fb308c25ffe8
[8605378]: https://github.com/nojhan/liquidprompt/commit/86053782d08b0d41ca69f4f45dde9ce619db1008
[89540d3]: https://github.com/nojhan/liquidprompt/commit/89540d312543b897b3c116370deabdfe9db15dcb
[8da3314]: https://github.com/nojhan/liquidprompt/commit/8da33144c89075dfd2309feaa718ccf3fe693ff6
[93df016]: https://github.com/nojhan/liquidprompt/commit/93df0169499c4ca8563add267e95dcd343d95f12
[9633ac8]: https://github.com/nojhan/liquidprompt/commit/9633ac83cad5f5702c1e853940c0ab2e166961bf
[9c1c8a3]: https://github.com/nojhan/liquidprompt/commit/9c1c8a378846c23e0a39be2aadd11531c2ecf196
[a70e80f]: https://github.com/nojhan/liquidprompt/commit/a70e80f0f501031ef97ea8baf88ca6d7ef56ad8a
[a8114dd]: https://github.com/nojhan/liquidprompt/commit/a8114dd9550e2e7fd33b93eb7885de08b3e64933
[a8571bb]: https://github.com/nojhan/liquidprompt/commit/a8571bb2920d9f11006754e634304242d929db57
[a97c0da]: https://github.com/nojhan/liquidprompt/commit/a97c0da0e6a6f037a6038c427a51a9ee840b45f2
[aa870b5]: https://github.com/nojhan/liquidprompt/commit/aa870b54d27cd6deda50a24f2030511d8a23c45e
[b53e53b]: https://github.com/nojhan/liquidprompt/commit/b53e53b6a5a5b783896b8fd75d341dbb1d7d5e5c
[c3d4970]: https://github.com/nojhan/liquidprompt/commit/c3d49708e598a79eca50caa0f96fca6230ce204e
[c98f16d]: https://github.com/nojhan/liquidprompt/commit/c98f16d52f9cc22723679124c3d64b06cbcb6e6e
[c9bdefe]: https://github.com/nojhan/liquidprompt/commit/c9bdefe020c30bb053c0815a1633e5e3be25e4ef
[cc1be7e]: https://github.com/nojhan/liquidprompt/commit/cc1be7e29d1b7fa6ef25e960e02da6612ff8bde9
[cf01d02]: https://github.com/nojhan/liquidprompt/commit/cf01d02445c38ee9504bad00f079af080a7bdfe2
[d485ed1]: https://github.com/nojhan/liquidprompt/commit/d485ed191fb6b896290a32848c4fefd0342e2046
[d62bf31]: https://github.com/nojhan/liquidprompt/commit/d62bf310d0d5a30fac6d047f03d832b81070c884
[d9cb55d]: https://github.com/nojhan/liquidprompt/commit/d9cb55da834720ac3cd4893bb4a35808ab67d376
[dc7be25]: https://github.com/nojhan/liquidprompt/commit/dc7be2540d677600a484dcd0c2d05dc0945382e5
[dd9a024]: https://github.com/nojhan/liquidprompt/commit/dd9a024b485d9c017aa935809bd20e7436dff46c
[e927985]: https://github.com/nojhan/liquidprompt/commit/e9279856c4af191d501e8e46898dde3b4447e6dd
[e9c35dd]: https://github.com/nojhan/liquidprompt/commit/e9c35ddeb473da1ac24eb27331b8974f3ba05237
[eb6dafc]: https://github.com/nojhan/liquidprompt/commit/eb6dafc314a3dc1fc5ca560d79c408db81af0288
[ed4f383]: https://github.com/nojhan/liquidprompt/commit/ed4f3832fe2f7380ec1b7949777fffe2a7f63f34
[ee63435]: https://github.com/nojhan/liquidprompt/commit/ee6343567d2178cd57daa89498868be6ea2ef156
[f436867]: https://github.com/nojhan/liquidprompt/commit/f4368670bf258257fece5611a9aad17e88f10b5a
[fabc775]: https://github.com/nojhan/liquidprompt/commit/fabc775cb8bfe1be5a39cf577d2d2187398881b0
[fdbd7ca]: https://github.com/nojhan/liquidprompt/commit/fdbd7ca545a2847fb3e862a6088740aa2a06c799
[fefbe01]: https://github.com/nojhan/liquidprompt/commit/fefbe01d9830a9033bdb008c454c0d0590548638
