Config Options
**************

.. contents::
   :local:

Almost every feature in Liquidprompt can be turned on or off using these config
options. They can either be set before sourcing Liquidprompt (in ``.bashrc`` or
``.zshrc``), or set in a Liquidprompt config file.

.. note::
   Config variables set in a config file take precedence over variables set in the
   environment or on the command line. Setting a config option on the command
   line, then running :func:`lp_activate` will overwrite that option with the
   value from the config file, if it is set there.

The config file is searched for in the following locations:

* ``~/.liquidpromptrc``
* ``$XDG_CONFIG_HOME/liquidpromptrc`` - (if :envvar:`XDG_CONFIG_HOME` is not
  set, ``~/.config`` is used)
* ``$XDG_CONFIG_DIRS/liquidpromptrc`` - :envvar:`XDG_CONFIG_DIRS` is a ``:``
  delimited array, each value is searched. (if :envvar:`XDG_CONFIG_DIRS` is not
  set, ``/etc/xdg`` is used)
* ``/etc/liquidpromptrc``

The first file found is sourced.

Liquidprompt ships with an example config file, ``liquidpromptrc-dist``. You can
start from this file for your config::

    cp ~/liquidprompt/liquidpromptrc-dist ~/.config/liquidpromptrc

In the event that you synchronize your configuration file across multiple
computers, or if you have an ``/etc/liquidpromptrc`` system-wide from which
you'd like to make minor deviations in an individual user account, you can
augment the primary config to add in any local modifications using lines such
as these::

    LOCAL_RCFILE=$HOME/.liquidpromptrc.local
    [ -f "$LOCAL_RCFILE" ] && source "$LOCAL_RCFILE"

.. note::
   The example config file does not include every config option, and the
   comments describing the options are less verbose than the descriptions on
   this page.

Each config option is documented with its default value.
Options of type ``bool`` accept values of ``1`` for true and ``0`` for false.

General
-------

.. attribute:: LP_MARK_PREFIX
   :type: string
   :value: " "

   String added directly before :attr:`LP_MARK_DEFAULT`, after all other
   parts of the prompt. Can be used to tag the prompt in a way that is less
   intrusive than :attr:`LP_PS1_PREFIX`, or add a newline before the prompt
   mark. For example::

      LP_MARK_PREFIX=$'\n'

.. attribute:: LP_PATH_CHARACTER_KEEP
   :type: int
   :value: 3

   The number of characters to save at the start and possibly the end of a
   directory name when shortening the path. See :attr:`LP_PATH_METHOD` for
   details of the specific methods.

.. attribute:: LP_PATH_DEFAULT
   :type: string

   .. deprecated:: 2.0
      Use :attr:`LP_PATH_METHOD` set to "truncate_to_last_dir" instead.

   Used to define the string used for the path. Could be used to make use of
   shell path shortening features, like ``%2~`` in Zsh to keep the last two
   directories of the path.

   :attr:`LP_ENABLE_SHORTEN_PATH` must be disabled to have any effect.

.. attribute:: LP_PATH_KEEP
   :type: int
   :value: 2

   The number of directories (counting '/') to display at the beginning of a
   shortened path.

   Set to ``1``, will display only root. Set to ``0``, will keep nothing from the
   beginning of the path.

   :attr:`LP_ENABLE_SHORTEN_PATH` must be enabled to have any effect.

   See also: :attr:`LP_PATH_LENGTH` and :attr:`LP_PATH_METHOD`.

   .. versionchanged:: 2.0
      No longer supports a value of ``-1``.

.. attribute:: LP_PATH_LENGTH
   :type: int
   :value: 35

   The maximum percentage of the terminal width used to display the path before
   removing the center portion of the path and replacing with
   :attr:`LP_MARK_SHORTEN_PATH`.

   :attr:`LP_ENABLE_SHORTEN_PATH` must be enabled to have any effect.

   .. note::
      :attr:`LP_PATH_KEEP` and :attr:`LP_PATH_METHOD` have higher precedence
      over this option. Important path parts, including directories saved by
      :attr:`LP_PATH_KEEP`, :attr:`LP_PATH_VCS_ROOT`, and the last directory,
      will always be displayed, even if the path does not fit in the maximum
      length.

.. attribute:: LP_PATH_METHOD
   :type: string
   :value: "truncate_chars_from_path_left"

   Sets the method used for shortening the path display when it exceeds the
   maximum length set by :attr:`LP_PATH_LENGTH`.

   * **truncate_chars_from_path_left**: Truncates characters from the start of
     the path, showing consecutive directories as one shortened section. E.g. in
     a directory named ``~/MyProjects/Liquidprompt/tests``, it will be shortened
     to ``...prompt/tests``. The shortened mark is :attr:`LP_MARK_SHORTEN_PATH`.
   * **truncate_chars_from_dir_right**: Leaves the beginning of a directory name
     untouched. E.g. directories will be shortened like so: ``~/Doc.../Office``.
     How many characters will be untouched is set by
     :attr:`LP_PATH_CHARACTER_KEEP`. The shortened mark is
     :attr:`LP_MARK_SHORTEN_PATH`.
   * **truncate_chars_from_dir_middle**:  Leaves the beginning and end of a
     directory name untouched. E.g. in a directory named
     ``~/MyProjects/Office``, then it will be shortened to
     ``~/MyS...cts/Office``. How many characters will be untouched is set by
     :attr:`LP_PATH_CHARACTER_KEEP`. The shortened mark is
     :attr:`LP_MARK_SHORTEN_PATH`.
   * **truncate_chars_to_unique_dir**: Truncate each directory to the shortest
     unique starting portion of their name. E.g. in a folder
     ``~/dev/liquidprompt``, it will be shortened to ``~/d/liquidprompt`` if
     there is no other directory starting with 'd' in the home directory.
   * **truncate_to_last_dir**: Only display the last directory in the path. In
     other words, the current directory name.

   All methods (other than 'truncate_to_last_dir') start at the far left of the
   path (limited by :attr:`LP_PATH_KEEP`). Only the minimum number of
   directories needed to fit inside :attr:`LP_PATH_LENGTH` will be shortened.

   :attr:`LP_ENABLE_SHORTEN_PATH` must be enabled to have any effect.

.. attribute:: LP_PATH_VCS_ROOT
   :type: bool
   :value: 1

   Display the root directory of the current VCS repository with special
   formatting, set by :attr:`LP_COLOR_PATH_VCS_ROOT`. If
   :attr:`LP_ENABLE_SHORTEN_PATH` is enabled, also prevent the path shortening
   from shortening or hidding the VCS root directory.

.. attribute:: LP_PS1_POSTFIX
   :type: string
   :value: ""

   A string displayed at the very end of the prompt, after even the prompt mark.
   :attr:`LP_MARK_PREFIX` is an alternative that goes before the prompt mark.

.. attribute:: LP_PS1_PREFIX
   :type: string
   :value: ""

   A string displayed at the start of the prompt. Can also be set with
   :func:`prompt_tag`.

.. attribute:: LP_TIME_FORMAT
   :type: string
   :value: "%H:%M:%S"

   The formatting string passed to :manpage:`date(1)` using formatting from
   :manpage:`strftime(3)` used to display the current date and/or time.

   See also: :attr:`LP_ENABLE_TIME`.

   .. versionadded:: 2.1

Features
--------

.. attribute:: LP_DELIMITER_KUBECONTEXT
   :type: string
   :value: ""

   Delimiter to shorten the Kubernetes context.

   Usage example:

   * if your context names are dev-cluster and test-cluster,
     then set this to "-" in order to output "dev" and "test" in prompt.
   * if your context names are dev.k8s.example.com and test.k8s.example.com,
     then set this to "." in order to output "dev" and "test" in prompt.
   * if using OpenShift then set this to "/" to show only the project name
     without the cluster and user parts.

   If set to the empty string no truncating will occur (this is the default).

   See also: :attr:`LP_ENABLE_KUBECONTEXT`, :attr:`LP_COLOR_KUBECONTEXT`,
   and :attr:`LP_MARK_KUBECONTEXT`.

   .. versionadded:: 2.1

.. attribute:: LP_DISABLED_VCS_PATH
   :type: string
   :value: ""

   .. deprecated:: 2.0
      Use :attr:`LP_DISABLED_VCS_PATHS` instead.

   An colon (``:``) separated list of absolute directory paths where VCS
   features will be disabled. See :attr:`LP_DISABLED_VCS_PATHS` for more
   information.

.. attribute:: LP_DISABLED_VCS_PATHS
   :type: array<string>
   :value: ()

   An array of absolute directory paths where VCS features will be disabled.
   Generally this would be used for repositories that are large and slow, where
   generating VCS information for the prompt would impact prompt responsiveness.

   Any subdirectory under the input directory is also disabled, so setting
   "/repos" would disable VCS display when the current directory is
   "/repos/a-repo". Setting ``("/")`` would disable VCS display completely.

   An example value would be::

      LP_DISABLED_VCS_PATHS=("/a/svn/repo" "/home/me/my/large/repo")

   See also: :attr:`LP_MARK_DISABLED`.

.. attribute:: LP_ENABLE_AWS_PROFILE
   :type: bool
   :value: 1

   Display the current value of :envvar:`AWS_PROFILE` or 
   :envvar:`AWS_DEFAULT_PROFILE`. These variables are used to switch between
   configuration profiles by the `AWS CLI`_.

   .. _`AWS CLI`: https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html

   See also: :attr:`LP_COLOR_AWS_PROFILE`.

   .. versionadded:: 2.1

.. attribute:: LP_ENABLE_BATT
   :type: bool
   :value: 1

   Display the status of the battery, if there is one, using color and marks.
   Add battery percentage colored with :attr:`LP_COLORMAP` if
   :attr:`LP_PERCENTS_ALWAYS` is enabled.

   Will be disabled if ``acpi`` is not found on Linux, or ``pmset`` is not
   found on MacOS.

   See also: :attr:`LP_BATTERY_THRESHOLD`, :attr:`LP_MARK_BATTERY`,
   :attr:`LP_MARK_ADAPTER`, :attr:`LP_COLOR_CHARGING_ABOVE`,
   :attr:`LP_COLOR_CHARGING_UNDER`, :attr:`LP_COLOR_DISCHARGING_ABOVE`, and
   :attr:`LP_COLOR_DISCHARGING_UNDER`.

.. attribute:: LP_ENABLE_BZR
   :type: bool
   :value: 1

   Display VCS information inside `Bazaar <https://bazaar.canonical.com/>`_
   repositories.

   Will be disabled if ``bzr`` is not found.

   See also: :attr:`LP_MARK_BZR`.

.. attribute:: LP_ENABLE_COLOR
   :type: bool
   :value: 1

   Use terminal formatting when displaying the prompt.

   .. note::
      Not all formatting is correctly disabled if this option is disabled.

   Will be disabled if ``tput`` is not found.

   .. versionadded:: 2.0

.. attribute:: LP_ENABLE_DETACHED_SESSIONS
   :type: bool
   :value: 1

   Display the number of detached multiplexer sessions.

   Will be disabled if neither ``screen`` nor ``tmux`` are found.

   .. note::
      This can be slow on some machines, and prompt speed can be greatly
      improved by disabling it.

   See also: :attr:`LP_COLOR_JOB_D`.

   .. versionadded:: 2.0

.. attribute:: LP_ENABLE_DIRSTACK
   :type: bool
   :value: 0

   Display the size of the directory stack if it is greater than ``1``.

   See also: :attr:`LP_MARK_DIRSTACK` and :attr:`LP_COLOR_DIRSTACK`.

   .. versionadded:: 2.0

.. attribute:: LP_ENABLE_ERROR
   :type: bool
   :value: 1

   Display the last command error code if it is not ``0``.

   See also: :attr:`LP_COLOR_ERR`.

   .. versionadded:: 2.0

.. attribute:: LP_ENABLE_FOSSIL
   :type: bool
   :value: 1

   Display VCS information inside `Fossil <https://www.fossil-scm.org/>`_
   repositories.

   Will be disabled if ``fossil`` is not found.

   See also: :attr:`LP_MARK_FOSSIL`.

.. attribute:: LP_ENABLE_FQDN
   :type: bool
   :value: 0

   Use the fully qualified domain name (FQDN) instead of the short hostname when
   the hostname is displayed.

   See also: :attr:`LP_HOSTNAME_ALWAYS`.

.. attribute:: LP_ENABLE_GIT
   :type: bool
   :value: 1

   Display VCS information inside `Git <https://git-scm.com/>`_ repositories.

   Will be disabled if ``git`` is not found.

   See also: :attr:`LP_MARK_GIT`.

.. attribute:: LP_ENABLE_HG
   :type: bool
   :value: 1

   Display VCS information inside `Mercurial <https://www.mercurial-scm.org/>`_
   repositories.

   Will be disabled if ``hg`` is not found.

   See also: :attr:`LP_MARK_HG`.

.. attribute:: LP_ENABLE_JOBS
   :type: bool
   :value: 1

   Display the number of running and sleeping shell jobs.

   See also: :attr:`LP_COLOR_JOB_R` and :attr:`LP_COLOR_JOB_Z`.

.. attribute:: LP_ENABLE_KUBECONTEXT
   :type: bool
   :value: 0

   Display the current `Kubernetes <https://kubernetes.io/>`_ `context`_.

   .. _`context`: https://kubernetes.io/docs/tasks/access-application-cluster/configure-access-multiple-clusters/

   See also: :attr:`LP_DELIMITER_KUBECONTEXT`, :attr:`LP_COLOR_KUBECONTEXT`,
   and :attr:`LP_MARK_KUBECONTEXT`.

   .. versionadded:: 2.1

.. attribute:: LP_ENABLE_LOAD
   :type: bool
   :value: 1

   Display the load average over the past 1 minutes when above the threshold.

   See also: :attr:`LP_LOAD_THRESHOLD`, :attr:`LP_LOAD_CAP`,
   :attr:`LP_MARK_LOAD`, :attr:`LP_PERCENTS_ALWAYS`, and :attr:`LP_COLORMAP`.

.. attribute:: LP_ENABLE_PERM
   :type: bool
   :value: 1

   Display a colored :attr:`LP_MARK_PERM` in the prompt to show when the user
   does not have write permission to the current directory.

   See also: :attr:`LP_COLOR_WRITE` and :attr:`LP_COLOR_NOWRITE`.

.. attribute:: LP_ENABLE_PROXY
   :type: bool
   :value: 1

   Display a :attr:`LP_MARK_PROXY` mark when an HTTP proxy is detected.

   See also: :attr:`LP_COLOR_PROXY`.

.. attribute:: LP_ENABLE_RUNTIME
   :type: bool
   :value: 1

   Display runtime of the previous command if over :attr:`LP_RUNTIME_THRESHOLD`.

   See also: :attr:`LP_COLOR_RUNTIME`.

.. attribute:: LP_ENABLE_RUNTIME_BELL
   :type: bool
   :value: 0

   Ring the terminal bell if the previous command ran longer than
   :attr:`LP_RUNTIME_BELL_THRESHOLD`.

   .. versionadded:: 1.12

.. attribute:: LP_ENABLE_SCLS
   :type: bool
   :value: 1

   Display the currently activated `Red Hat Software Collection`_.

   See also: :attr:`LP_COLOR_VIRTUALENV`.

   .. _`Red Hat Software Collection`: https://developers.redhat.com/products/softwarecollections/overview

.. attribute:: LP_ENABLE_SCREEN_TITLE
   :type: bool
   :value: 0

   Set the terminal title while in a terminal multiplexer.

   :attr:`LP_ENABLE_TITLE` must be enabled to have any effect.

.. attribute:: LP_ENABLE_SHORTEN_PATH
   :type: bool
   :value: 1

   Use the shorten path feature if the path is too long to fit in the prompt
   line.

   See also: :attr:`LP_PATH_METHOD`, :attr:`LP_PATH_LENGTH`,
   :attr:`LP_PATH_KEEP`, :attr:`LP_PATH_CHARACTER_KEEP`, and
   :attr:`LP_MARK_SHORTEN_PATH`.

.. attribute:: LP_ENABLE_SSH_COLORS
   :type: bool
   :value: 0

   Replace :attr:`LP_COLOR_SSH` with a color based on the hash of the hostname.
   This can give each host a "color feel" to help distinguish them.

   See also: :attr:`LP_HOSTNAME_ALWAYS`.

.. attribute:: LP_ENABLE_SUDO
   :type: bool
   :value: 0

   Check if the user has valid ``sudo`` credentials, and display an indicating
   mark or color.

   Will be disabled if ``sudo`` is not found.

   .. warning::
      Each evocation of ``sudo`` by default writes to the syslog, and this will
      run ``sudo`` once each prompt. This is likely to make your sysadmin hate
      you.

   See also: :attr:`LP_COLOR_MARK_SUDO`.

.. attribute:: LP_ENABLE_SVN
   :type: bool
   :value: 1

   Display VCS information inside `Subversion <https://subversion.apache.org/>`_
   repositories.

   Will be disabled if ``svn`` is not found.

   See also: :attr:`LP_MARK_SVN`.

.. attribute:: LP_ENABLE_TEMP
   :type: bool
   :value: 1

   Display the highest system temperature if above the threshold.

   Will be disabled if neither ``sensors`` nor ``acpi`` are found.

   See also: :attr:`LP_TEMP_THRESHOLD`, :attr:`LP_MARK_TEMP`, and
   :attr:`LP_COLORMAP`.

.. attribute:: LP_ENABLE_TIME
   :type: bool
   :value: 0

   Displays the time at which the prompt was shown. The format can be configured
   with :attr:`LP_TIME_FORMAT`.

   See also: :attr:`LP_TIME_ANALOG` and :attr:`LP_COLOR_TIME`.

.. attribute:: LP_ENABLE_TITLE
   :type: bool
   :value: 0

   Set the terminal title to part or all of the prompt string, depending on the
   theme.

   Must be enabled to be able to set the manual title with :func:`lp_title`.

   .. warning::
      This may not work properly on exotic terminals. Please report any issues.

.. attribute:: LP_ENABLE_VCS_ROOT
   :type: bool
   :value: 0

   Enable VCS features when running as root. This is disabled by default for
   security.

.. attribute:: LP_ENABLE_VIRTUALENV
   :type: bool
   :value: 1

   Display the currently activated Python_ or Conda_ virtual environment.

   See also: :attr:`LP_COLOR_VIRTUALENV`.

   .. _Python: https://docs.python.org/tutorial/venv.html
   .. _Conda: https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html

.. attribute:: LP_HOSTNAME_ALWAYS
   :type: int
   :value: 0

   Determine when the hostname should be displayed. Valid values are:

   * ``0`` - show the hostname, except when locally connected
   * ``1`` - always show the hostname
   * ``-1`` - never show the hostname

   See also: :attr:`LP_COLOR_HOST` and :attr:`LP_ENABLE_SSH_COLORS`.

.. attribute:: LP_PERCENTS_ALWAYS
   :type: bool
   :value: 1

   Display the actual values of load and batteries along with their
   corresponding marks. Disable to only print the colored marks.

.. attribute:: LP_TIME_ANALOG
   :type: bool
   :value: 0

   Shows the time using an analog clock instead of numeric values. The analog
   clock is "accurate" to the nearest half hour. You must have a unicode-capable
   terminal and a font with the "CLOCK" characters (U+1F550 - U+1F567).

   Will only have an effect if :attr:`LP_ENABLE_TIME` is enabled.

.. attribute:: LP_USER_ALWAYS
   :type: int
   :value: 1

   Determine when the username should be displayed. Valid values are:

   * ``0`` - show the username, except when the user is the login user
   * ``1`` - always show the username
   * ``-1`` - never show the username

   See also: :attr:`LP_COLOR_USER_LOGGED`, :attr:`LP_COLOR_USER_ALT`, and
   :attr:`LP_COLOR_USER_ROOT`.

   .. versionchanged:: 2.0
      The ``-1`` option was added.

Thresholds
----------

.. attribute:: LP_BATTERY_THRESHOLD
   :type: int
   :value: 75

   The percentage threshold that the battery level needs to fall below before
   it will be displayed in :attr:`LP_COLOR_CHARGING_UNDER` or
   :attr:`LP_COLOR_DISCHARGING_UNDER` color. Otherwise, it will be displayed in
   :attr:`LP_COLOR_CHARGING_ABOVE` or :attr:`LP_COLOR_DISCHARGING_ABOVE` color.

   :attr:`LP_ENABLE_BATT` must be enabled to have any effect.

.. attribute:: LP_LOAD_CAP
   :type: float
   :value: 2.0

   The value for load average per CPU to display with the max color scaling.
   Values above this number will still be displayed, but the colors will not
   increase in intensity.

   :attr:`LP_ENABLE_LOAD` must be enabled to have any effect.

   See also: :attr:`LP_COLORMAP`.

   .. versionadded:: 2.0

.. attribute:: LP_LOAD_THRESHOLD
   :type: float
   :value: 0.60

   Display the load average per CPU when above this threshold. For historical
   reasons, this number must have a decimal point ('.'), or it will be treated
   as a percentage.

   :attr:`LP_ENABLE_LOAD` must be enabled to have any effect.

   .. versionchanged:: 2.0
      Accepts float values of actual load averages.
      Integer values of centiload are still accepted, but deprecated.

.. attribute:: LP_RUNTIME_THRESHOLD
   :type: int
   :value: 2

   Time in seconds that a command must run longer than for its runtime to be
   displayed.

   :attr:`LP_ENABLE_RUNTIME` must be enabled to have any effect.

.. attribute:: LP_RUNTIME_BELL_THRESHOLD
   :type: int
   :value: 10

   Time in seconds that a command must run longer than for the terminal bell to
   be rung.

   :attr:`LP_ENABLE_RUNTIME_BELL` must be enabled to have any effect.

   .. versionadded:: 1.12

.. attribute:: LP_TEMP_THRESHOLD
   :type: int
   :value: 60

   Display the highest system temperature when the temperature is above this
   threshold (in degrees Celsius).

   :attr:`LP_ENABLE_TEMP` must be enabled to have any effect.

Marks
-----

.. attribute:: LP_MARK_ADAPTER
   :type: string
   :value: "⏚"

   Mark used for battery display when charging.

   See also: :attr:`LP_ENABLE_BATT`.

.. attribute:: LP_MARK_BATTERY
   :type: string
   :value: "⌁"

   Mark used for battery display when on battery power.

   See also: :attr:`LP_ENABLE_BATT`.

.. attribute:: LP_MARK_BRACKET_CLOSE
   :type: string
   :value: "]"

   Mark used for closing core prompt brackets. Used by the default theme for
   enclosing user, host, and current working directory sections.

   See also: :attr:`LP_MARK_BRACKET_OPEN`.

.. attribute:: LP_MARK_BRACKET_OPEN
   :type: string
   :value: "["

   Mark used for opening core prompt brackets. Used by the default theme for
   enclosing user, host, and current working directory sections.

   See also: :attr:`LP_MARK_BRACKET_CLOSE`.

.. attribute:: LP_MARK_BZR
   :type: string
   :value: "⚯"

   Mark used instead of :attr:`LP_MARK_DEFAULT` to indicate that the current
   directory is inside of a Bazaar repository.

   See also: :attr:`LP_ENABLE_BZR`.

.. attribute:: LP_MARK_DEFAULT
   :type: string
   :value: "$" (Bash) or "%" (Zsh)

   Mark used to indicate that the prompt is ready for user input, unless some
   other context overrides it, like a VCS repository.

.. attribute:: LP_MARK_DIRSTACK
   :type: string
   :value: "⚞"

   Mark used to indicate the size of the directory stack. Here are some
   alternative marks you might like: ⚟ = ≡ ≣

   See also: :attr:`LP_ENABLE_DIRSTACK` and :attr:`LP_COLOR_DIRSTACK`.

   .. versionadded:: 2.0

.. attribute:: LP_MARK_DISABLED
   :type: string
   :value: "⌀"

   Mark used instead of :attr:`LP_MARK_DEFAULT` to indicate that the current
   directory is disabled for VCS display through :attr:`LP_DISABLED_VCS_PATHS`.

.. attribute:: LP_MARK_FOSSIL
   :type: string
   :value: "⌘"

   Mark used instead of :attr:`LP_MARK_DEFAULT` to indicate that the current
   directory is inside of a Fossil repository.

   See also: :attr:`LP_ENABLE_FOSSIL`.

.. attribute:: LP_MARK_GIT
   :type: string
   :value: "±"

   Mark used instead of :attr:`LP_MARK_DEFAULT` to indicate that the current
   directory is inside of a Git repository.

   See also: :attr:`LP_ENABLE_GIT`.

.. attribute:: LP_MARK_HG
   :type: string
   :value: "☿"

   Mark used instead of :attr:`LP_MARK_DEFAULT` to indicate that the current
   directory is inside of a Mercurial repository.

   See also: :attr:`LP_ENABLE_HG`.

.. attribute:: LP_MARK_KUBECONTEXT
   :type: string
   :value: "⎈"

   Mark used to prefix the current Kubernetes context.

   Used to visually distinguish the Kubernetes context from other
   context fields like the Python virtual environment (see
   :attr:`LP_ENABLE_VIRTUALENV`) and the Red Hat Software Collection
   (see :attr:`LP_ENABLE_SCLS`).

   The display of Unicode characters varies among Terminal and Font settings,
   so you might try alternative marks. Single symbol alternatives to the
   default "⎈" (U+2388, Helm Symbol) are "☸" (U+2638, Wheel of Dharma)
   or "κ" (U+03BA, Greek Small Letter Kappa).

   See also: :attr:`LP_ENABLE_KUBECONTEXT`.

   .. versionadded:: 2.1

.. attribute:: LP_MARK_LOAD
   :type: string
   :value: "⌂"

   Mark used before displaying load average.

   See also: :attr:`LP_ENABLE_LOAD`.

.. attribute:: LP_MARK_PERM
   :type: string
   :value: ":"

   Mark used by default separate hostname and current working directory, and is
   colored to indicate user permissions on the current directory.

   Is still used (without colors) if :attr:`LP_ENABLE_PERM` is disabled.

   .. versionadded:: 1.12

.. attribute:: LP_MARK_PROXY
   :type: string
   :value: "↥"

   Mark used to indicate a proxy is active.

   See also: :attr:`LP_ENABLE_PROXY`.

.. attribute:: LP_MARK_SHORTEN_PATH
   :type: string
   :value: " … "

   Mark used to indicate a portion of the path was hidden to save space. Not all
   shortening methods use this mark, some only use
   :attr:`LP_COLOR_PATH_SHORTENED`.

   See also: :attr:`LP_ENABLE_SHORTEN_PATH`, :attr:`LP_PATH_METHOD`.

.. attribute:: LP_MARK_STASH
   :type: string
   :value: "+"

   Mark used to indicate at least one stash or shelve exists in the current
   repository.

.. attribute:: LP_MARK_SVN
   :type: string
   :value: "‡"

   Mark used instead of :attr:`LP_MARK_DEFAULT` to indicate that the current
   directory is inside of a Subversion repository.

   See also: :attr:`LP_ENABLE_SVN`.

.. attribute:: LP_MARK_TEMP
   :type: string
   :value: "θ"

   Mark used before displaying temperature.

   See also: :attr:`LP_ENABLE_TEMP`.

.. attribute:: LP_MARK_UNTRACKED
   :type: string
   :value: "*"

   Mark used to indicate untracked or extra files exist in the current
   repository.

.. attribute:: LP_MARK_VCSH
   :type: string
   :value: "|"

   Mark used instead of :attr:`LP_MARK_DEFAULT` to indicate that the current
   directory is inside of a `VCSH <https://github.com/RichiH/vcsh>`_ repository.

   Since VCSH repositories are Git repositories under the hood,
   :attr:`LP_MARK_GIT` is surrounded in this mark.

Colors
------

These color strings will be used without modification, so they need to be valid
terminal escape sequences, either generated with :func:`lp_terminal_format` or
using the ``$COLOR`` variables.

Valid preset color variables are:

* ``BOLD`` - bold formatting only.
* ``BLACK``
* ``BOLD_GRAY`` - actually bold black
* ``RED``
* ``BOLD_RED``
* ``GREEN``
* ``BOLD_GREEN``
* ``YELLOW``
* ``BOLD_YELLOW``
* ``BLUE``
* ``BOLD_BLUE``
* ``PURPLE`` or ``MAGENTA``
* ``BOLD_PURPLE``, ``BOLD_MAGENTA`` or ``PINK``
* ``CYAN``
* ``BOLD_CYAN``
* ``WHITE``
* ``BOLD_WHITE``
* ``WARN_RED`` - black foreground, red background
* ``CRIT_RED`` - white foreground, red background
* ``DANGER_RED`` - yellow foreground, red background

.. attribute:: LP_COLORMAP
   :type: array<string>

   An array of colors that is used by the battery, load, and temperature
   features to indicate the severity level of their status. A normal or low
   status will use the first index, while the last index is the most severe.

   The default array is::

      (
          ""
          $GREEN
          $BOLD_GREEN
          $YELLOW
          $BOLD_YELLOW
          $RED
          $BOLD_RED
          $WARN_RED
          $CRIT_RED
          $DANGER_RED
      )

   See also: :attr:`LP_ENABLE_BATT`, :attr:`LP_ENABLE_LOAD`, and
   :attr:`LP_ENABLE_TEMP`.

.. attribute:: LP_COLOR_AWS_PROFILE
   :type: string
   :value: $YELLOW

   Color used to display the current active AWS Profile.

   See also: :attr:`LP_ENABLE_AWS_PROFILE`.

   .. versionadded:: 2.1

.. attribute:: LP_COLOR_CHANGES
   :type: string
   :value: $RED

   Color used to indicate that the current repository is not clean, or in other
   words, has changes that have not been committed.

.. attribute:: LP_COLOR_CHARGING_ABOVE
   :type: string
   :value: $GREEN

   Color used to indicate that the battery is charging and above the
   :attr:`LP_BATTERY_THRESHOLD`.

   See also: :attr:`LP_ENABLE_BATT`.

.. attribute:: LP_COLOR_CHARGING_UNDER
   :type: string
   :value: $YELLOW

   Color used to indicate that the battery is charging and under the
   :attr:`LP_BATTERY_THRESHOLD`.

   See also: :attr:`LP_ENABLE_BATT`.

.. attribute:: LP_COLOR_COMMITS_BEHIND
   :type: string
   :value: $BOLD_RED

   Color used to indicate that the current repository has a remote tracking
   branch that has commits that the local branch does not.

.. attribute:: LP_COLOR_COMMITS
   :type: string
   :value: $YELLOW

   Color used to indicate that the current repository has commits on the local
   branch that the remote tracking branch does not.

   Also used to color :attr:`LP_MARK_STASH`.

.. attribute:: LP_COLOR_DIFF
   :type: string
   :value: $PURPLE

   Color used to indicate that the current repository has lines that have been
   changed since the last commit.

.. attribute:: LP_COLOR_DIRSTACK
   :type: string
   :value: $BOLD_YELLOW

   Color used to indicate the size of the directory stack.

   See also: :attr:`LP_ENABLE_DIRSTACK` and :attr:`LP_MARK_DIRSTACK`.

   .. versionadded:: 2.0

.. attribute:: LP_COLOR_DISCHARGING_ABOVE
   :type: string
   :value: $YELLOW

   Color used to indicate that the battery is discharging and above the
   :attr:`LP_BATTERY_THRESHOLD`.

   See also: :attr:`LP_ENABLE_BATT`.

.. attribute:: LP_COLOR_DISCHARGING_UNDER
   :type: string
   :value: $RED

   Color used to indicate that the battery is discharging and above the
   :attr:`LP_BATTERY_THRESHOLD`.

   See also: :attr:`LP_ENABLE_BATT`.

.. attribute:: LP_COLOR_ERR
   :type: string
   :value: $PURPLE

   Color used to indicate the last command exited with a non-zero return code.

   See also: :attr:`LP_ENABLE_ERROR`.

.. attribute:: LP_COLOR_HOST
   :type: string
   :value: ""

   Color used for the hostname when connected locally.

   See also: :attr:`LP_HOSTNAME_ALWAYS`.

.. attribute:: LP_COLOR_IN_MULTIPLEXER
   :type: string
   :value: $BOLD_BLUE

   Color used for :attr:`LP_MARK_BRACKET_OPEN` and :attr:`LP_MARK_BRACKET_CLOSE`
   if the terminal is in a multiplexer.

.. attribute:: LP_COLOR_JOB_D
   :type: string
   :value: $YELLOW

   Color used for detached multiplexer sessions.

   See also: :attr:`LP_ENABLE_DETACHED_SESSIONS`.

.. attribute:: LP_COLOR_JOB_R
   :type: string
   :value: $BOLD_YELLOW

   Color used for running shell jobs.

   See also: :attr:`LP_ENABLE_JOBS`.

.. attribute:: LP_COLOR_JOB_Z
   :type: string
   :value: $BOLD_YELLOW

   Color used for sleeping shell jobs.

   See also: :attr:`LP_ENABLE_JOBS`.

.. attribute:: LP_COLOR_KUBECONTEXT
   :type: string
   :value: $CYAN

   Color used for the current Kubernetes context.

   See also: :attr:`LP_ENABLE_KUBECONTEXT`.

   .. versionadded:: 2.1

.. attribute:: LP_COLOR_MARK
   :type: string
   :value: $BOLD

   Color used for :attr:`LP_MARK_DEFAULT`.

.. attribute:: LP_COLOR_MARK_ROOT
   :type: string
   :value: $BOLD_RED

   Color used for :attr:`LP_MARK_DEFAULT` when the current user is root, shown
   instead of :attr:`LP_COLOR_MARK`.

.. attribute:: LP_COLOR_MARK_SUDO
   :type: string
   :value: $LP_COLOR_MARK_ROOT

   Color used for :attr:`LP_MARK_DEFAULT` when sudo is active, shown instead of
   :attr:`LP_COLOR_MARK`.

   See also: :attr:`LP_ENABLE_SUDO`.

.. attribute:: LP_COLOR_NOWRITE
   :type: string
   :value: $RED

   Color used for :attr:`LP_MARK_PERM` when the user does not have write
   permissions to the current working directory.

   See also: :attr:`LP_ENABLE_PERM` and :attr:`LP_COLOR_WRITE`.

.. attribute:: LP_COLOR_PATH
   :type: string
   :value: ""

   Color used for the current working directory.

   If :attr:`LP_COLOR_PATH_LAST_DIR`, :attr:`LP_COLOR_PATH_VCS_ROOT`,
   :attr:`LP_COLOR_PATH_SEPARATOR`, or :attr:`LP_COLOR_PATH_SHORTENED` are set,
   their respective sections will be colored with them instead.

   .. versionchanged:: 2.0
      Default value changed from ``$BOLD`` to the default color.

.. attribute:: LP_COLOR_PATH_LAST_DIR
   :type: string
   :value: $BOLD

   Color used for the last path segment, which corresponds to the current
   directory basename.

.. attribute:: LP_COLOR_PATH_ROOT
   :type: string
   :value: $BOLD_YELLOW

   Color used in place of :attr:`LP_COLOR_PATH` when the current user is root.

.. attribute:: LP_COLOR_PATH_SEPARATOR
   :type: string
   :value: lp_terminal_format 8 -1 0 0 -1  # Grey

   Color used for the separator ('/') between path segments. If set to the empty
   string, the separator will take the format of the path segment before it.

.. attribute:: LP_COLOR_PATH_SHORTENED
   :type: string
   :value: lp_terminal_format 8 -1 0 0 -1  # Grey

   Color used for path segments that have been shortened.

   :attr:`LP_ENABLE_SHORTEN_PATH` must be enabled to have any effect.

.. attribute:: LP_COLOR_PATH_VCS_ROOT
   :type: string
   :value: $BOLD

   Color used for the path segment corresponding to the current VCS repository
   root directory.

   :attr:`LP_PATH_VCS_ROOT` must be enabled to have any effect.

.. attribute:: LP_COLOR_PROXY
   :type: string
   :value: $BOLD_BLUE

   Color used for :attr:`LP_MARK_PROXY`.

   See also: :attr:`LP_ENABLE_PROXY`.

.. attribute:: LP_COLOR_RUNTIME
   :type: string
   :value: $YELLOW

   Color used for displaying the last command runtime.

   See also: :attr:`LP_ENABLE_RUNTIME`.

.. attribute:: LP_COLOR_SSH
   :type: string
   :value: $BLUE

   Color used for displaying the hostname when connected with SSH.

   Has no effect if :attr:`LP_ENABLE_SSH_COLORS` is enabled.

   See also: :attr:`LP_HOSTNAME_ALWAYS`.

.. attribute:: LP_COLOR_SU
   :type: string
   :value: $BOLD_YELLOW

   Color used for displaying the hostname when running under ``su`` or ``sudo``.

   See also: :attr:`LP_HOSTNAME_ALWAYS`.

.. attribute:: LP_COLOR_TELNET
   :type: string
   :value: $WARN_RED

   Color used for displaying the hostname when connected with Telnet.

   See also: :attr:`LP_HOSTNAME_ALWAYS`.

.. attribute:: LP_COLOR_TIME
   :type: string
   :value: $BLUE

   Color used for displaying the current time.

   See also: :attr:`LP_ENABLE_TIME`.

.. attribute:: LP_COLOR_UP
   :type: string
   :value: $GREEN

   Color used to indicate that the current repository is up-to-date and no
   commits differ from the remote tracking branch.

.. attribute:: LP_COLOR_USER_ALT
   :type: string
   :value: $BOLD

   Color used for displaying the username when running as a different user than
   the login user.

.. attribute:: LP_COLOR_USER_LOGGED
   :type: string
   :value: ""

   Color used for displaying the username when running as the login user.

   See also: :attr:`LP_USER_ALWAYS`.

.. attribute:: LP_COLOR_USER_ROOT
   :type: string
   :value: $BOLD_YELLOW

   Color used for displaying the username when running as root.

.. attribute:: LP_COLOR_VIRTUALENV
   :type: string
   :value: $CYAN

   Color used for displaying a Python virtual env or Red Hat Software
   Collection.

   See also: :attr:`LP_ENABLE_VIRTUALENV` and :attr:`LP_ENABLE_SCLS`.

.. attribute:: LP_COLOR_WRITE
   :type: string
   :value: $GREEN

   Color used for :attr:`LP_MARK_PERM` when the user has write permissions to
   the current working directory.

   See also: :attr:`LP_ENABLE_PERM` and :attr:`LP_COLOR_NOWRITE`.

.. attribute:: LP_COLOR_X11_OFF
   :type: string
   :value: $YELLOW

   Color used for indicating that a display is not connected.

.. attribute:: LP_COLOR_X11_ON
   :type: string
   :value: $GREEN

   Color used for indicating that a display is connected.

