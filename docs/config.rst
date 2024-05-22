Config Options
**************

.. contents::
   :local:

Almost every feature in Liquid Prompt can be turned on or off using these config
options. They can either be set before sourcing Liquid Prompt (in ``.bashrc`` or
``.zshrc``, or sourcing a preset), or set in a Liquid Prompt config file.

.. note::
   Config variables set in a config file take precedence over variables set in
   the environment or on the command line. Setting a config option on the
   command line, then running :func:`lp_activate` will overwrite that option
   with the value from the config file, if it is set there.

The config file is searched for in the following locations:

* ``~/.liquidpromptrc``
* ``$XDG_CONFIG_HOME/liquidpromptrc`` - (if :envvar:`XDG_CONFIG_HOME` is not
  set, ``~/.config`` is used)
* ``$XDG_CONFIG_DIRS/liquidpromptrc`` - :envvar:`XDG_CONFIG_DIRS` is a ``:``
  delimited array, each value is searched. (if :envvar:`XDG_CONFIG_DIRS` is not
  set, ``/etc/xdg`` is used)
* ``/etc/liquidpromptrc``

The first file found is sourced.

To get your own configuration, you may want to generate a default configuration
by calling the following script::

    ./tools/config-from-doc.sh > my_liquidpromptrc

Then edit the ``my_liquidpromptrc`` file to suits your needs
and copy/link it where you want.

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

Several example of configurations are given in the ``contrib/presets``
directory. Some of these presets can be combined, for instance for changing
the icons, along with the colors.

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
   mark.

   For example::

      LP_MARK_PREFIX=$'\n'

.. attribute:: LP_PATH_CHARACTER_KEEP
   :type: int
   :value: 3

   The number of characters to save at the start and possibly the end of a
   directory name when shortening the path. See :attr:`LP_PATH_METHOD` for
   details of the specific methods.

   .. versionadded:: 2.0

.. attribute:: LP_PATH_DEFAULT
   :type: string
   :value: ""

   .. deprecated:: 2.0
      Use :attr:`LP_PATH_METHOD` set to `truncate_to_last_dir` instead.

   Used to define the string used for the path. Could be used to make use of
   shell path shortening features, like ``%2~`` in Zsh to keep the last two
   directories of the path.

   :attr:`LP_ENABLE_SHORTEN_PATH` must be disabled to have any effect.

.. attribute:: LP_PATH_KEEP
   :type: int
   :value: 2

   The number of directories (counting '/') to display at the beginning of a
   shortened path.

   Set to ``1``, will display only root. Set to ``0``, will keep nothing from
   the beginning of the path.

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
     a directory named ``~/MyProjects/liquidprompt/tests``, it will be shortened
     to ``...prompt/tests``. The shortened mark is :attr:`LP_MARK_SHORTEN_PATH`.
   * **truncate_chars_from_dir_right**: Leaves the beginning of a directory name
     untouched. E.g. directories will be shortened like so: ``~/Doc.../Office``.
     How many characters will be untouched is set by
     :attr:`LP_PATH_CHARACTER_KEEP`. The shortened mark is
     :attr:`LP_MARK_SHORTEN_PATH`.
   * **truncate_chars_from_dir_middle**: Leaves the beginning and end of a
     directory name untouched. E.g. in a directory named
     ``~/MyProjects/Office``, then it will be shortened to
     ``~/MyP...cts/Office``. How many characters will be untouched is set by
     :attr:`LP_PATH_CHARACTER_KEEP`. The shortened mark is
     :attr:`LP_MARK_SHORTEN_PATH`.
   * **truncate_chars_to_unique_dir**: Truncate each directory to the shortest
     unique starting portion of their name. E.g. in a folder
     ``~/dev/liquidprompt``, it will be shortened to ``~/d/liquidprompt`` if
     there is no other directory starting with 'd' in the home directory.
   * **truncate_to_last_dir**: Only display the last directory in the path. In
     other words, the current directory name.

   All methods (other than `truncate_to_last_dir`) start at the far left of the
   path (limited by :attr:`LP_PATH_KEEP`). Only the minimum number of
   directories needed to fit inside :attr:`LP_PATH_LENGTH` will be shortened.

   :attr:`LP_ENABLE_SHORTEN_PATH` must be enabled to have any effect.

   .. versionadded:: 2.0

.. attribute:: LP_PATH_VCS_ROOT
   :type: bool
   :value: 1

   Display the root directory of the current VCS repository with special
   formatting, set by :attr:`LP_COLOR_PATH_VCS_ROOT`. If
   :attr:`LP_ENABLE_SHORTEN_PATH` is enabled, also prevent the path shortening
   from shortening or hiding the VCS root directory.

   .. versionadded:: 2.0

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

.. attribute:: LP_ALWAYS_DISPLAY_VALUES
   :type: bool
   :value: 1

   Display the actual values of load, batteries, and wifi signal strength along
   with their corresponding marks. Disable to only print the colored marks.

   See also: :attr:`LP_ENABLE_LOAD`, :attr:`LP_ENABLE_BATT`,
   :attr:`LP_ENABLE_DISK`, and :attr:`LP_ENABLE_WIFI_STRENGTH`.

   .. versionadded: 2.2

.. attribute:: LP_DELIMITER_KUBECONTEXT_PREFIX
   :type: string
   :value: ""

   Delimiter to shorten the Kubernetes context by removing a prefix.

   Usage example:

   * if your context names are `cluster-dev` and `cluster-test`,
     then set this to "-" in order to output `dev` and `test` in prompt.
   * if using AWS EKS then set this to "/" to show only the cluster name,
     without the rest of the ARN
     (``arn:aws:eks:$AWS_REGION:$ACCOUNT_ID:cluster/$CLUSTER_NAME``)
   * alternatively, if using AWS EKS, set this to ":" to show only
     `cluster/$CLUSTER_NAME`. (Note: the prefix removed is a greedy match - it
     contains all the ":"s in the input.)

   If set to the empty string no truncating will occur (this is the default).

   See also: :attr:`LP_ENABLE_KUBECONTEXT`,
   :attr:`LP_DELIMITER_KUBECONTEXT_SUFFIX`, :attr:`LP_COLOR_KUBECONTEXT`,
   and :attr:`LP_MARK_KUBECONTEXT`.

   .. versionadded:: 2.1

.. attribute:: LP_DELIMITER_KUBECONTEXT_SUFFIX
   :type: string
   :value: ""

   Delimiter to shorten the Kubernetes context by removing a suffix.

   Usage example:

   * if your context names are `dev-cluster` and `test-cluster`,
     then set this to "-" in order to output `dev` and `test` in prompt.
   * if your context names are `dev.k8s.example.com` and `test.k8s.example.com`,
     then set this to "." in order to output `dev` and `test` in prompt. (Note:
     the suffix removed is a greedy match - it contains all the "."s in the
     input.)
   * if using OpenShift then set this to "/" to show only the project name
     without the cluster and user parts.

   If set to the empty string no truncating will occur (this is the default).

   See also: :attr:`LP_ENABLE_KUBECONTEXT`,
   :attr:`LP_DELIMITER_KUBECONTEXT_PREFIX`, :attr:`LP_COLOR_KUBECONTEXT`,
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
   `/repos` would disable VCS display when the current directory is
   `/repos/a-repo`. Setting ``("/")`` would disable VCS display completely.

   An example value would be::

      LP_DISABLED_VCS_PATHS=("/a/svn/repo" "/home/me/my/large/repo")

   See also: :attr:`LP_MARK_DISABLED`.

   .. versionadded:: 2.0

.. attribute:: LP_DISPLAY_VALUES_AS_PERCENTS
   :type: bool
   :value: 0

   When displaying a value, show it as a percentage if possible.

   Used in sensors for capacities, see :attr:`LP_ENABLE_DISK`,
   :attr:`LP_ENABLE_BATT`.

   .. versionadded: 2.2

.. attribute:: LP_ENABLE_AWS_PROFILE
   :type: bool
   :value: 1

   Display the current value of :envvar:`AWS_PROFILE`,
   :envvar:`AWS_DEFAULT_PROFILE`, or :envvar:`AWS_VAULT`. AWS_PROFILE and
   AWS_DEFAULT_PROFILE are used to switch between configuration profiles by
   the `AWS CLI`_. AWS_VAULT is used by `aws-vault`_ to specify the AWS
   profile in use.

   .. _`AWS CLI`: https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html
   .. _`aws-vault`: https://github.com/99designs/aws-vault

   See also: :attr:`LP_COLOR_AWS_PROFILE`.

   .. versionadded:: 2.1

.. attribute:: LP_ENABLE_BATT
   :type: bool
   :value: 1

   Display the status of the battery, if there is one, using color and marks.
   Add battery percentage colored with :attr:`LP_COLORMAP` if
   :attr:`LP_ALWAYS_DISPLAY_VALUES` is enabled.

   Will be disabled if ``acpi`` is not found on Linux, fails to read the Linux
   sysfs system, or ``pmset`` is not found on MacOS.

   See also: :attr:`LP_BATTERY_THRESHOLD`, :attr:`LP_MARK_BATTERY`,
   :attr:`LP_MARK_ADAPTER`, :attr:`LP_COLOR_CHARGING_ABOVE`,
   :attr:`LP_COLOR_CHARGING_UNDER`, :attr:`LP_COLOR_DISCHARGING_ABOVE`, and
   :attr:`LP_COLOR_DISCHARGING_UNDER`.

.. attribute:: LP_ENABLE_BZR
   :type: bool
   :value: 1

   Display VCS information inside
   `Bazaar <https://wikipedia.org/wiki/GNU_Bazaar>`_ repositories.

   Will be disabled if ``bzr`` is not found.

   See also: :attr:`LP_MARK_BZR`.

.. attribute:: LP_ENABLE_CHROOT
   :type: bool
   :value: 1

   Display whether a *chroot* environment is active.

   .. versionadded: 2.2

.. attribute:: LP_ENABLE_CMAKE
   :type: bool
   :value: 0

   Displays the current configuration of CMake,
   if the directory contains a `CMakecache.txt`.
   Displays the compiler, the generator and the build type,
   separated by :attr:`LP_MARK_CMAKE`.

   Will be disabled if ``cmake`` is not found.

   The compiler is displayed without its path.
   The generator is displayed without space,
   and some names are shortened (`Makefiles` as `Make`
   and `Visual Studio` as `VS`), so that, for instance:
   `Unix Makefiles` will be displayed as `UnixMake`.
   Both fields are randomly colored according to their hash.

   The common build type colors can be configured:

   - *Debug*, colored with :attr:`LP_COLOR_CMAKE_DEBUG` (magenta, by default),
   - *RelWithDebInfo*, colored with :attr:`LP_COLOR_CMAKE_RWDI` (blue, by
     default),
   - *Release*, colored with :attr:`LP_COLOR_CMAKE_RELEASE` (cyan, by default),
   - any other value would be colored according to its hash.

   .. versionadded:: 2.2

.. attribute:: LP_ENABLE_COLOR
   :type: bool
   :value: 1

   Use terminal formatting when displaying the prompt.

   .. note::
      Not all formatting is correctly disabled if this option is disabled.

   Will be disabled if ``tput`` is not found.

   .. versionadded:: 2.0

.. attribute:: LP_ENABLE_CONTAINER
   :type: bool
   :value: 0

   Indicate if the shell is running in a container environment (e.g. Docker,
   Podman, LXC, Singularity, systemd-:spelling:word:`nspawn`).

   .. note::
      Containers may inherit some or even no variables from their parent shell,
      so this may behave inconsistently with different container software. For
      example, Docker does not inherit anything unless explicitly told to.
      Singularity in many configurations inherits most variables but shell
      functions and zsh hooks might not make it in. For full functionality,
      ``liquidprompt`` may need to be sourced inside the child container.

   See also: :attr:`LP_COLOR_CONTAINER`.

   .. versionadded:: 2.1

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

.. attribute:: LP_ENABLE_DISPLAY
   :type: bool
   :value: 1

   Detect if the connection has X11 support.

   In the default theme, display a green ``@`` if it does; a yellow one if not.

   See also :attr:`LP_COLOR_X11_ON` and :attr:`LP_COLOR_X11_OFF`.

   .. versionadded:: 2.2

.. attribute:: LP_ENABLE_DISK
   :type: bool
   :value: 1

   Display :attr:`LP_MARK_DISK` if the free space on the hard drive hosting the
   current directory goes below a threshold.

   Thresholds can be stated either:

   * as a percentage with :attr:`LP_DISK_THRESHOLD_PERC`,
   * or an absolute number *of kilobytes* with :attr:`LP_DISK_THRESHOLD`.

   Display will occur if one of the thresholds is met.

   If :attr:`LP_ALWAYS_DISPLAY_VALUES` is enabled, the prompt will show the
   available space along with :attr:`LP_MARK_DISK`, if disabled, it will show
   only the mark.

   The precision of the available space can be configured with
   :attr:`LP_DISK_PRECISION`.

   If :attr:`LP_DISPLAY_VALUES_AS_PERCENTS` is enabled, it will show the
   percentage, if it is disabled, it will show the absolute value in a
   human-readable form (i.e. with metric prefixed units).

   .. versionadded:: 2.2

.. attribute:: LP_ENABLE_ERROR
   :type: bool
   :value: 1

   Display the last command error code if it is not ``0``.

   See also: :attr:`LP_COLOR_ERR`.

   .. versionadded:: 2.0

.. attribute:: LP_ENABLE_ERROR_MEANING
   :type: bool
   :value: 0

   Display a guess on the last error meaning.

   .. note:: This only enable a limited subset of error codes,
             that are very probably in use on several systems.
             To enable more codes (and probably more false positives)
             see :attr:`LP_ENABLE_ERROR_MEANING_EXTENDED`.

   See also: :attr:`LP_COLOR_ERR`.

   .. versionadded:: 2.2

.. attribute:: LP_ENABLE_ERROR_MEANING_EXTENDED
   :type: bool
   :value: 0

   Extends the set of interpreted error codes to a larger set of (POSIX) codes.

   .. note:: This use a reasonable set of error codes
             that are common on POSIX systems on x86 or ARM architectures
             (most notably from ``sysexit.h`` and ``signal.h``).
             But any software may use its own set of codes,
             and thus the guess may be wrong.

   This has no effect if :attr:`LP_ENABLE_ERROR_MEANING` is disabled.
   See also: :attr:`LP_COLOR_ERR`.

   .. versionadded:: 2.2

.. attribute:: LP_ENABLE_ENV_VARS
   :type: bool
   :value: 1

   Display a user-defined set of environment variables.
   May show if the variables are unset, set, or their actual content.

   Watched variables should be added to the :attr:`LP_ENV_VARS` array.

   The resulting prompt section is configured by:

   - :attr:`LP_MARK_ENV_VARS_OPEN`
   - :attr:`LP_MARK_ENV_VARS_SEP`
   - :attr:`LP_MARK_ENV_VARS_CLOSE`
   - :attr:`LP_COLOR_ENV_VARS_SET`
   - :attr:`LP_COLOR_ENV_VARS_UNSET`

   .. versionadded:: 2.2

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

   .. deprecated:: 2.1
      Use :attr:`LP_HOSTNAME_METHOD` set to "full" instead.

   Use the fully qualified domain name (FQDN) instead of the short hostname when
   the hostname is displayed.

   .. note::
      This never functioned as intended, and would only show the FQDN if
      ``/etc/hostname`` contained the full domain name. For a more portable and
      reliable version, set :attr:`LP_HOSTNAME_METHOD` to `fqdn`.

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

   See also: :attr:`LP_MARK_HG` and :attr:`LP_HG_COMMAND`.

.. attribute:: LP_ENABLE_HYPERLINKS
   :type: bool
   :value: 0

   Adds clickable links to some elements of the prompt:

   - If locally connected, adds a link to
     each displayed elements of the path, using the ``file://`` scheme.
   - Within remote SSH connections, adds a link to
     each element of the path, but using the ``sftp://`` protocol,
     configured with the *current* username and hostname.
   - If the hostname is displayed within an SSH connection,
     adds a ``ssh://`` URL to it.

   The links take the form of a OSC-8 escape sequences
   containing an Uniform Resource Locator,
   which should be interpreted by the terminal emulator.
   If your terminal emulator does not support OSC-8,
   it may display escapement garbage.
   As not all terminal emulator support links,
   this feature is disabled by default.

   .. warning:: Your system should be configured to handle
                the aforementioned link schemes.
                If nothing happen when you click on the link,
                or if the wrong application is used,
                there is a configuration problem on your system
                or with your terminal emulator
                (not with Liquid Prompt).

   .. note:: Liquid Prompt cannot possibly follow complex remote connections.
             Remote links are thus configured with the *current* username,
             and the *current* fully qualified domain name,
             as ``sftp://<username>@<hostname>/<path>``.
             It is possible that this URL does not work the same way
             than a manual connection.
             For instance, if you proxy jumped
             (i.e. if you jumped from one connection to the other),
             and/or you logged in with another user, and/or used SSH aliases,
             then the links probably won't work the way you may expect.

   .. versionadded:: 2.2

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

   See also: :attr:`LP_ENABLE_KUBE_NAMESPACE`,
   :attr:`LP_DELIMITER_KUBECONTEXT_PREFIX`,
   :attr:`LP_DELIMITER_KUBECONTEXT_SUFFIX`,
   :attr:`LP_COLOR_KUBECONTEXT`,
   and :attr:`LP_MARK_KUBECONTEXT`.

   .. versionadded:: 2.1

.. attribute:: LP_ENABLE_KUBE_NAMESPACE
   :type: bool
   :value: 0

   Display the current `Kubernetes <https://kubernetes.io/>`_ default
   `namespace`_ in the current context.

   .. _`namespace`: https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/#setting-the-namespace-preference

   See also: :attr:`LP_ENABLE_KUBECONTEXT`,
   :attr:`LP_DELIMITER_KUBECONTEXT_PREFIX`,
   :attr:`LP_DELIMITER_KUBECONTEXT_SUFFIX`,
   :attr:`LP_COLOR_KUBECONTEXT`,
   and :attr:`LP_MARK_KUBECONTEXT`.

   .. versionadded:: 2.1

.. attribute:: LP_ENABLE_LOAD
   :type: bool
   :value: 1

   Display the load average over the past 1 minutes when above the threshold.

   See also: :attr:`LP_LOAD_THRESHOLD`, :attr:`LP_LOAD_CAP`,
   :attr:`LP_MARK_LOAD`, :attr:`LP_ALWAYS_DISPLAY_VALUES`,
   and :attr:`LP_COLORMAP`.
   :attr:`LP_MARK_LOAD`, :attr:`LP_PERCENTS_ALWAYS`, and :attr:`LP_COLORMAP`.

.. attribute:: LP_ENABLE_MODULES
   :type: bool
   :value: 1

   Display the currently loaded `Modules <https://modules.readthedocs.io/>`_.

   See also:
   * :attr:`LP_ENABLE_MODULES_VERSIONS`,
   * :attr:`LP_ENABLE_MODULES_HASHCOLOR`,
   * :attr:`LP_COLOR_MODULES`,
   * :attr:`LP_MARK_MODULES_OPEN`,
   * :attr:`LP_MARK_MODULES_SEP`,
   * :attr:`LP_MARK_MODULES_CLOSE`.

   .. versionadded:: 2.2

.. attribute:: LP_ENABLE_MODULES_VERSIONS
   :type: bool
   :value: 1

   Display the currently loaded modules' versions, after their names
   (separated by a slash, as in the ``module list`` command).

   If disabled, only the name of the module is displayed.

   See :attr:`LP_ENABLE_MODULES`.

   .. versionadded:: 2.2

.. attribute:: LP_ENABLE_MODULES_HASHCOLOR
   :type: bool
   :value: 0

   If enabled, each item in the modules section will be randomly colored,
   according to its hash, instead of using :attr:`LP_COLOR_MODULES`.

   See :attr:`LP_ENABLE_MODULES`.

   .. versionadded:: 2.2

.. attribute:: LP_ENABLE_MULTIPLEXER
   :type: bool
   :value: 1

   Allows getting the name of the current multiplexer
   (*screen* or *tmux*), if any.

   If set to ``0``, also disables:

   * :attr:`LP_COLOR_IN_MULTIPLEXER`,
   * :attr:`LP_MARK_MULTIPLEXER_OPEN` and :attr:`LP_MARK_MULTIPLEXER_CLOSE`.

   .. versionadded:: 2.2

.. attribute:: LP_ENABLE_NODE_VENV
   :type: bool
   :value: 0

   Display the currently activated nodeenv_ or NVM_ virtual environment.

   See also: :attr:`LP_COLOR_NODE_VENV`.

   .. _nodeenv: https://ekalinin.github.io/nodeenv/
   .. _NVM: https://github.com/nvm-sh/nvm

   .. versionadded:: 2.1

.. attribute:: LP_ENABLE_OS
   :type: bool
   :value: 0

   Display information about the current Operating System.

   Degree of details is controlled by:

   - :attr:`LP_ENABLE_OS_ARCH`
   - :attr:`LP_ENABLE_OS_FAMILY`
   - :attr:`LP_ENABLE_OS_KERNEL`
   - :attr:`LP_ENABLE_OS_DISTRIB`
   - :attr:`LP_ENABLE_OS_VERSION`

   .. note:: As of now, only Linux may have detailed information
             about the distribution and version.

   See also :attr:`LP_MARK_OS` and :attr:`LP_MARK_OS_SEP`
   for configuring the appearance.

   If no replacement string is provided with :attr:`LP_MARK_OS`,
   each item will be randomly colored, according to its hash.

   .. versionadded:: 2.2

.. attribute:: LP_ENABLE_OS_ARCH
   :type: bool
   :value: 0

   Display the processor architecture of the current OS.

   See :attr:`LP_ENABLE_OS`.

   .. versionadded:: 2.2

.. attribute:: LP_ENABLE_OS_DISTRIB
   :type: bool
   :value: 0

   Display the current Linux distribution.

   See :attr:`LP_ENABLE_OS`.

   .. versionadded:: 2.2

.. attribute:: LP_ENABLE_OS_FAMILY
   :type: bool
   :value: 0

   Display the family of the current OS (UNIX, BSD, GNU, or Windows).

   See :attr:`LP_ENABLE_OS`.

   .. versionadded:: 2.2

.. attribute:: LP_ENABLE_OS_KERNEL
   :type: bool
   :value: 1

   Display the name of the kernel type for the current OS.

   This may be "Linux", "FreeBSD", "SunOS", "Darwin", "Cygwin", "MSYS",
   "MinGW", "OpenBSD", "DragonFly".

   See :attr:`LP_ENABLE_OS`.

   .. versionadded:: 2.2

.. attribute:: LP_ENABLE_OS_VERSION
   :type: bool
   :value: 1

   Display the version "codename" of the current Linux distribution.

   See :attr:`LP_ENABLE_OS`.

   .. versionadded:: 2.2

.. attribute:: LP_ENABLE_PATH
   :type: bool
   :value: 1

   Display the current working directory.

   .. versionadded:: 2.2
      Before this version, this feature was always enabled.

.. attribute:: LP_ENABLE_PERL_VENV
   :type: bool
   :value: 1

   Display the currently activated PERLBREW_ or PLENV_ virtual environment.

   See also: :attr:`LP_COLOR_PERL_VENV`.

   .. _PERLBREW: https://perlbrew.pl/
   .. _PLENV: https://github.com/tokuhirom/plenv

   .. versionadded:: 2.2

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

.. attribute:: LP_ENABLE_RAM
   :type: bool
   :value: 1

   Display a :attr:`LP_MARK_RAM` mark when the available amount of
   Random Access Memory goes below a threshold.

   Thresholds can be stated either:

   * as a percentage with :attr:`LP_RAM_THRESHOLD_PERC`,
   * or an absolute number *of kilobytes* with :attr:`LP_RAM_THRESHOLD`.

   Display will occur if one of the thresholds is met.

   If :attr:`LP_ALWAYS_DISPLAY_VALUES` is enabled, the prompt will show the
   available space along with :attr:`LP_MARK_RAM`, if disabled, it will show
   only the mark.

   The precision of the displayed available space can be configured with
   :attr:`LP_RAM_PRECISION`.

   If :attr:`LP_DISPLAY_VALUES_AS_PERCENTS` is enabled, it will show the
   percentage, if it is disabled, it will show the absolute value in a
   human-readable form (i.e. with metric prefixed units).

   .. versionadded:: 2.2

.. attribute:: LP_ENABLE_RUBY_VENV
   :type: bool
   :value: 1

   Display the currently activated RVM_ or RBENV_ virtual environment.

   See also: :attr:`LP_RUBY_RVM_PROMPT_OPTIONS` and
   :attr:`LP_COLOR_RUBY_VENV`.

   .. _RVM: https://rvm.io/
   .. _RBENV: https://github.com/rbenv/rbenv

   .. versionadded:: 2.1

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

.. attribute:: LP_ENABLE_SHLVL
   :type: bool
   :value: 1

   Show the value of ``$SHLVL``, which is the number of nested shells, if the
   value meets the threshold. For example, if one runs ``bash`` inside their
   shell, it will open a new shell inside their current shell, and this will
   display "2".

   See also: :attr:`LP_SHLVL_THRESHOLD`, :attr:`LP_MARK_SHLVL`, and
   :attr:`LP_COLOR_SHLVL`.

   .. versionadded:: 2.1

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
      Each evocation of ``sudo`` by default writes to the
      :spelling:word:`syslog`, and this will run ``sudo`` once each prompt,
      unless you have `NOPASSWD` powers. This is likely to make your sysadmin
      hate you.

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

   Will be disabled if neither ``sensors`` nor ``acpi`` are found, or fails to
   read from the Linux sysfs system.

   See also: :attr:`LP_TEMP_THRESHOLD`, :attr:`LP_MARK_TEMP`,
   :attr:`LP_COLORMAP`, and :attr:`LP_TEMP_SYSFS_IGNORE_FILES`.

.. attribute:: LP_ENABLE_TERRAFORM
   :type: bool
   :value: 0

   Display the currently activated `Terraform`_ workspace.

   See also: :attr:`LP_COLOR_TERRAFORM`.

   .. _Terraform: https://www.terraform.io/docs/language/index.html

   .. versionadded:: 2.1

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

.. attribute:: LP_ENABLE_TITLE_COMMAND
   :type: bool
   :value: 1

   Postpend the currently running command to the terminal title while the
   command is running.

   :attr:`LP_ENABLE_TITLE` must be enabled to have any effect.

   .. versionadded:: 2.1

.. attribute:: LP_ENABLE_TMUX_TITLE_PANES
   :type: bool
   :value: 1

   Sets the title of the Tmux pane instead of the window.

   :attr:`LP_ENABLE_TITLE` and :attr:`LP_ENABLE_SCREEN_TITLE` must be enabled to
   have any effect.

   .. versionadded:: 2.2

.. attribute:: LP_ENABLE_VCS_REMOTE
   :type: bool
   :value: 0

   Enable the display of the remote repository in the VCS state section.

   If enabled, will display :attr:`LP_MARK_VCS_REMOTE`, followed by the remote
   repository name.

   In the default theme, if the remote repository has commits not pulled in the
   local branch, the mark will be showed in :attr:`LP_COLOR_COMMITS_BEHIND`. If
   the local repository has commits not pushed to the remote branch, the remote
   name is shown in :attr:`LP_COLOR_COMMITS`. If neither is the case, nothing
   will be shown.

   .. versionadded:: 2.2

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

.. attribute:: LP_ENABLE_WIFI_STRENGTH
   :type: bool
   :value: 0

   Display an indicator if any wireless signal strength percentage is below
   :attr:`LP_WIFI_STRENGTH_THRESHOLD`. Also show the strength percentage if
   :attr:`LP_ALWAYS_DISPLAY_VALUES` is enabled.

   Both Linux and MacOS are supported.

   See also: :attr:`LP_MARK_WIFI` and :attr:`LP_COLORMAP`.

   .. versionadded:: 2.1

.. attribute:: LP_ENV_VARS
   :type: array<string>
   :value: ()

   The set of environment variables that the user wants to watch.

   Items should be a string with three space-separated elements
   of the form `"<name> <set>[ <unset>]"`, containing:

   - the name of the variable to watch,
   - the string to display if the variable is set,
   - (optionally) the string to display if the variable is not set.

   The string used when the variable is set may contain the ``%s`` mark,
   which is replaced by the actual content of the variable.

   For example::

    LP_ENV_VARS=(
        # Display "V" if VERBOSE is set, nothing if it's unset.
        "VERBOSE V"
        # Display the name of the desktop session, if set, T if unset.
        "DESKTOP_SESSION %s T"
        # Display "ed:" followed the name of the default editor, nothing if unset.
        "EDITOR ed:%s"
    )

   See also :attr:`LP_ENABLE_ENV_VARS`.

   The resulting prompt section is configured by:

   -  :attr:`LP_MARK_ENV_VARS_OPEN`
   -  :attr:`LP_MARK_ENV_VARS_SEP`
   -  :attr:`LP_MARK_ENV_VARS_CLOSE`
   -  :attr:`LP_COLOR_ENV_VARS_SET`
   -  :attr:`LP_COLOR_ENV_VARS_UNSET`

.. attribute:: LP_HG_COMMAND
   :type: string
   :value: "hg"

   The command to use for Mercurial commands. Can be used to replace ``hg``
   with ``rhg`` or ``chg``.

   See also: :attr:`LP_ENABLE_HG` and :attr:`LP_MARK_HG`.

   .. versionadded:: 2.1

.. attribute:: LP_HIDE_EMPTY_ERROR
   :type: bool
   :value: 1

   Hide the error code returned by a command if the new prompt is displayed
   after the user hits Ctrl-C or submits an empty command (i.e. empty string
   or a comment).

   See also: :attr:`LP_ENABLE_ERROR`.

   .. versionadded:: 2.2

.. attribute:: LP_HOSTNAME_ALWAYS
   :type: int
   :value: 0

   Determine when the hostname should be displayed.

   Valid values are:

   * ``0`` - show the hostname, except when locally connected
   * ``1`` - always show the hostname
   * ``-1`` - never show the hostname

   See also: :attr:`LP_COLOR_HOST` and :attr:`LP_ENABLE_SSH_COLORS`.

.. attribute:: LP_HOSTNAME_METHOD
   :type: string
   :value: "short"

   Determine the method for displaying the hostname.

   * **short**: show the first section of the hostname, what is before the first
     dot. Equal to ``\h`` in Bash or ``%m`` in Zsh.
   * **full**: show the full hostname, without any domain name. Equal to ``\H``
     in Bash or ``%M`` in Zsh.
   * **fqdn**: show the fully qualified domain name, if it exists. Defaults to
     **full** if not.
   * **pretty**: show the pretty hostname, also called "machine display name".
     Defaults to **full** if one does not exist.

   See also: :attr:`LP_HOSTNAME_ALWAYS`.

   .. versionadded:: 2.1

.. attribute:: LP_PERCENTS_ALWAYS
   :type: bool
   :value: 1

   .. deprecated:: 2.2
      Use :attr:`LP_ALWAYS_DISPLAY_VALUES`
      and :attr:`LP_DISPLAY_VALUES_AS_PERCENTS` instead.

   Display the actual values of load, batteries, and wifi signal strength along
   with their corresponding marks. Disable to only print the colored marks.

   See also: :attr:`LP_ENABLE_LOAD`, :attr:`LP_ENABLE_BATT`,
   :attr:`LP_ENABLE_WIFI_STRENGTH`.

.. attribute:: LP_RUBY_RVM_PROMPT_OPTIONS
   :type: array<string>
   :value: (i v g s)

   An array of single letter switches to customize the `RVM prompt`_ output.

   Will only have an effect if :attr:`LP_ENABLE_RUBY_VENV` is enabled and you
   are using RVM (i.e. no effect with RBENV).

   .. _`RVM prompt`: https://rvm.io/workflow/prompt

   .. versionadded:: 2.1

.. attribute:: LP_TEMP_SYSFS_IGNORE_FILES
   :type: array<string>
   :value: ()

   Paths to files in the sysfs interface that should be ignored when reading
   temperature sensors. A path can include globs.

   See also :attr:`LP_ENABLE_TEMP`.

   .. versionadded:: 2.2

.. attribute:: LP_TIME_ANALOG
   :type: bool
   :value: 0

   Shows the time using an analog clock instead of numeric values. The analog
   clock is "accurate" to the nearest half hour. You must have a Unicode capable
   terminal and a font with the "CLOCK" characters (U+1F550 - U+1F567).

   Will only have an effect if :attr:`LP_ENABLE_TIME` is enabled.

.. attribute:: LP_USER_ALWAYS
   :type: int
   :value: 1

   Determine when the username should be displayed.

   Valid values are:

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

.. attribute:: LP_DISK_PRECISION
   :type: int
   :value: 2

   Control the numbers of decimals when displaying the absolute available space
   of the current hard drive. If set to 0, don't display decimals. If set to 1
   or 2, display decimals.

   See :attr:`LP_ENABLE_DISK`, :attr:`LP_ALWAYS_DISPLAY_VALUES`, and
   :attr:`LP_DISPLAY_VALUES_AS_PERCENTS`.

   .. versionadded:: 2.2

.. attribute:: LP_DISK_THRESHOLD
   :type: int
   :value: 100000

   Display something if the available space on the hard drive hosting the
   current directory goes below this absolute threshold *in kilobytes*.

   The threshold for disk can also be set with :attr:`LP_DISK_THRESHOLD_PERC`,
   the first one to be reached triggering the display.

   See also :attr:`LP_ENABLE_DISK`.

   .. versionadded:: 2.2

.. attribute:: LP_DISK_THRESHOLD_PERC
   :type: int
   :value: 10

   Display something if the available space on the hard drive hosting the
   current directory goes below this percentage.

   The threshold for disk can also be set with :attr:`LP_DISK_THRESHOLD`,
   the first one to be reached triggering the display..

   See also :attr:`LP_ENABLE_DISK`.

   .. versionadded:: 2.2

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
      Integer values of :spelling:word:`centiload` are still accepted, but
      deprecated.

.. attribute:: LP_RAM_PRECISION
   :type: int
   :value: 2

   Control the numbers of decimals when displaying the absolute available space
   of the current system RAM. If set to 0, don't display decimals. If set to 1
   or 2, display decimals.

   See :attr:`LP_ENABLE_RAM`, :attr:`LP_ALWAYS_DISPLAY_VALUES`, and
   :attr:`LP_DISPLAY_VALUES_AS_PERCENTS`.

   .. versionadded:: 2.2

.. attribute:: LP_RAM_THRESHOLD
   :type: int
   :value: 100000

   Display something if the available RAM space goes below this absolute
   threshold *in kilobytes*.

   The threshold for RAM can also be set with :attr:`LP_RAM_THRESHOLD_PERC`,
   the first one to be reached triggering the display.

   See also :attr:`LP_ENABLE_RAM`.

   .. versionadded:: 2.2

.. attribute:: LP_RAM_THRESHOLD_PERC
   :type: int
   :value: 10

   Display something if the available RAM space goes below this percentage.

   The threshold for RAM can also be set with :attr:`LP_RAM_THRESHOLD`,
   the first one to be reached triggering the display..

   See also :attr:`LP_ENABLE_RAM`.

   .. versionadded:: 2.2

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

.. attribute:: LP_SHLVL_THRESHOLD
   :type: int
   :value: 2

   Number of nested shells before the shell level is shown.

   See also: :attr:`LP_ENABLE_SHLVL`, :attr:`LP_MARK_SHLVL`, and
   :attr:`LP_COLOR_SHLVL`.

   .. versionadded:: 2.2

.. attribute:: LP_TEMP_THRESHOLD
   :type: int
   :value: 60

   Display the highest system temperature when the temperature is above this
   threshold (in degrees Celsius).

   :attr:`LP_ENABLE_TEMP` must be enabled to have any effect.

.. attribute:: LP_WIFI_STRENGTH_THRESHOLD
   :type: int
   :value: 40

   Display the lowest wireless signal strength when the strength percentage is
   below this threshold.

   :attr:`LP_ENABLE_WIFI_STRENGTH` must be enabled to have any effect.

   .. versionadded:: 2.1

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

   See also: :attr:`LP_MARK_BRACKET_OPEN`, :attr:`LP_MARK_MULTIPLEXER_CLOSE`.

   .. versionchanged:: 2.2
      Can be disabled by :attr:`LP_ENABLE_MULTIPLEXER`.

.. attribute:: LP_MARK_BRACKET_OPEN
   :type: string
   :value: "["

   Mark used for opening core prompt brackets. Used by the default theme for
   enclosing user, host, and current working directory sections.

   See also: :attr:`LP_MARK_BRACKET_CLOSE`, :attr:`LP_MARK_MULTIPLEXER_OPEN`.

   .. versionchanged:: 2.2
      Can be disabled by :attr:`LP_ENABLE_MULTIPLEXER`.

.. attribute:: LP_MARK_BZR
   :type: string
   :value: "⚯"

   Mark used instead of :attr:`LP_MARK_DEFAULT` to indicate that the current
   directory is inside of a Bazaar repository.

   See also: :attr:`LP_ENABLE_BZR`.

.. attribute:: LP_MARK_CMAKE
   :type: string
   :value: ":"

   Separator used for fields of :attr:`LP_ENABLE_CMAKE`.

   .. versionadded:: 2.2

.. attribute:: LP_MARK_DEFAULT
   :type: string
   :value: "$" (Bash) or "%" (Zsh)

   Mark used to indicate that the prompt is ready for user input, unless some
   other context overrides it, like a VCS repository.

.. attribute:: LP_MARK_DEV_CLOSE
   :type: string
   :value: ">"

   Closing of the "development tools" section.

   .. versionadded:: 2.2

.. attribute:: LP_MARK_DEV_MID
   :type: string
   :value: "|"

   Separator between elements of the "development tools" section.

   .. versionadded:: 2.2

.. attribute:: LP_MARK_DEV_OPEN
   :type: string
   :value: "<"

   Opening of the "development tools" section.

   .. versionadded:: 2.2

.. attribute:: LP_MARK_DIRSTACK
   :type: string
   :value: "⚞"

   Mark used to indicate the size of the directory stack.

   Here are some alternative marks you might like: ⚟ = ≡ ≣

   See also: :attr:`LP_ENABLE_DIRSTACK` and :attr:`LP_COLOR_DIRSTACK`.

   .. versionadded:: 2.0

.. attribute:: LP_MARK_DISABLED
   :type: string
   :value: "⌀"

   Mark used instead of :attr:`LP_MARK_DEFAULT` to indicate that the current
   directory is disabled for VCS display through :attr:`LP_DISABLED_VCS_PATHS`.

.. attribute:: LP_MARK_DISK
   :type: string
   :value: "🖴 "

   Mark used to indicate that the available disk space is too low.
   See :attr:`LP_ENABLE_DISK`.

   .. versionadded:: 2.2

.. attribute:: LP_MARK_ENV_VARS_OPEN
   :type: string
   :value: "("

   Mark used to start the user-defined environment variables watch list.

   See also:

   - :attr:`LP_ENABLE_ENV_VARS`
   - :attr:`LP_ENV_VARS`
   - :attr:`LP_MARK_ENV_VARS_SEP`
   - :attr:`LP_MARK_ENV_VARS_CLOSE`
   - :attr:`LP_COLOR_ENV_VARS_SET`
   - :attr:`LP_COLOR_ENV_VARS_UNSET`

   .. versionadded:: 2.2

.. attribute:: LP_MARK_ENV_VARS_SEP
   :type: string
   :value: " "

   Mark used to separate items of the user-defined
   environment variables watch list.

   See also:

   - :attr:`LP_ENABLE_ENV_VARS`
   - :attr:`LP_ENV_VARS`
   - :attr:`LP_MARK_ENV_VARS_OPEN`
   - :attr:`LP_MARK_ENV_VARS_CLOSE`
   - :attr:`LP_COLOR_ENV_VARS_SET`
   - :attr:`LP_COLOR_ENV_VARS_UNSET`

   .. versionadded:: 2.2

.. attribute:: LP_MARK_ENV_VARS_CLOSE
   :type: string
   :value: ")"

   Mark used to end the user-defined environment variables watch list.

   See also:

   - :attr:`LP_ENABLE_ENV_VARS`
   - :attr:`LP_ENV_VARS`
   - :attr:`LP_MARK_ENV_VARS_OPEN`
   - :attr:`LP_MARK_ENV_VARS_SEP`
   - :attr:`LP_COLOR_ENV_VARS_SET`
   - :attr:`LP_COLOR_ENV_VARS_UNSET`

   .. versionadded:: 2.2

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

   See also: :attr:`LP_ENABLE_HG` and :attr:`LP_HG_COMMAND`.

.. attribute:: LP_MARK_JOBS_SEPARATOR
   :type: string
   :value: "/"

   Mark used to separate elements of :attr:`LP_JOBS`.

   See also :attr:`LP_ENABLE_JOBS`.

   .. versionadded:: 2.2

.. attribute:: LP_MARK_KUBECONTEXT
   :type: string
   :value: "⎈"

   Mark used to prefix the current Kubernetes context.

   Used to visually distinguish the Kubernetes context from other
   context fields like the Python virtual environment (see
   :attr:`LP_ENABLE_VIRTUALENV`) and the Red Hat Software Collection
   (see :attr:`LP_ENABLE_SCLS`).

   The display of Unicode characters varies among Terminal and Font settings, so
   you might try alternative marks. Single symbol alternatives to the default
   `⎈` (U+2388, Helm Symbol) are `☸` (U+2638, Wheel of :spelling:word:`Dharma`)
   or `κ` (U+03BA, Greek Small Letter Kappa).

   See also: :attr:`LP_ENABLE_KUBECONTEXT`.

   .. versionadded:: 2.1

.. attribute:: LP_MARK_LOAD
   :type: string
   :value: "⌂"

   Mark used before displaying load average.

   See also: :attr:`LP_ENABLE_LOAD`.

.. attribute:: LP_MARK_MODULES_OPEN
   :type: string
   :value: ""

   Mark used before displaying loaded modules.

   See also: :attr:`LP_ENABLE_MODULES`.

.. attribute:: LP_MARK_MODULES_CLOSE
   :type: string
   :value: ""

   Mark used after displaying loaded modules.

   See also: :attr:`LP_ENABLE_MODULES`.

.. attribute:: LP_MARK_MODULES_SEP
   :type: string
   :value: ":"

   Mark used between loaded modules.

   See also: :attr:`LP_ENABLE_MODULES`.

.. attribute:: LP_MARK_MULTIPLEXER_CLOSE
   :type: string
   :value: $LP_MARK_BRACKET_CLOSE

   Mark used for closing core prompt brackets. Used by the default theme when
   inside of a multiplexer.

   See also: :attr:`LP_MARK_MULTIPLEXER_OPEN`, :attr:`LP_MARK_BRACKET_CLOSE`.

   .. versionadded:: 2.1

   .. versionchanged:: 2.2
      Can be disabled by :attr:`LP_ENABLE_MULTIPLEXER`.

.. attribute:: LP_MARK_MULTIPLEXER_OPEN
   :type: string
   :value: $LP_MARK_BRACKET_OPEN

   Mark used for opening core prompt brackets. Used by the default theme when
   inside of a multiplexer.

   See also: :attr:`LP_MARK_MULTIPLEXER_CLOSE`, :attr:`LP_MARK_BRACKET_OPEN`.

   .. versionadded:: 2.1

   .. versionchanged:: 2.2
      Can be disabled by :attr:`LP_ENABLE_MULTIPLEXER`.

.. attribute:: LP_MARK_OS
   :type: array<string>
   :value: ()

   A list of pair of strings to be replaced by another string
   when displaying information about the OS.

   Each pair in the list configures the match, then the replacement string.

   For instance, if you set ``LP_MARK_OS=("Linux" "L")``
   and ``LP_ENABLE_OS=1 ; LP_ENABLE_OS_FAMILY=1``,
   then any occurrence of "Linux" will be replaced by an "L"
   in the OS section.

   It is possible to use presets colors in the replacement string
   (see the :ref:`Colors` section below).
   Note that if a replacement occurs,
   the result will *not* be colored automatically.

   For example, to shorten known names,
   you can use the following configuration
   (if your font supports those characters):

   .. code-block:: shell

       LP_MARK_OS=(
           # Arch
           "x86_64"    "${BLUE}x64${NO_COL}"
           "i386"      "i3"
           "i686"      "i6"
           "aarch64"   "${GREEN}a64${NO_COL}"
           # Families
           "BSD"       "${RED}BSD${NO_COL}"
           "Windows"   "🪟"
           "Unix"      "U"
           "GNU"       "🐮"
           # Kernels
           "FreeBSD"   "👹"
           "DragonFly" "🦋"
           "OpenBSD"   "🐡"
           "Darwin"    "🍎"
           "SunOS"     "${BOLD_YELLOW}☀${NO_COL}"
           "Cygwin"    "🦢"
           "MSYS"      "M"
           "MinGW"     "GW"
           "Linux"     "🐧"
       )

   See :attr:`LP_ENABLE_OS`.

   .. versionadded:: 2.2

.. attribute:: LP_MARK_OS_SEP
   :type: string
   :value: "/"

   The character used to separate items of the OS section.

   See :attr:`LP_ENABLE_OS`.

   .. versionadded:: 2.2

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

.. attribute:: LP_MARK_RAM
   :type: string
   :value: M

   Mark used before displaying available Random Access Memory.
   See :attr:`LP_ENABLE_RAM`.

   .. versionadded:: 2.2

.. attribute:: LP_MARK_SHLVL
   :type: string
   :value: "└"

   Mark used to indicate the shell is inside another shell.

   See also: :attr:`LP_ENABLE_SHLVL`, :attr:`LP_SHLVL_THRESHOLD`, and
   :attr:`LP_COLOR_SHLVL`.

   .. versionadded:: 2.1

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

.. attribute:: LP_MARK_VCS_REMOTE
   :type: string
   :value: "⭚"

   Mark used to indicate the VCS remote repository name and status.

   See :attr:`LP_ENABLE_VCS_REMOTE`.

   .. versionadded:: 2.2

.. attribute:: LP_MARK_VCSH
   :type: string
   :value: "|"

   Mark used instead of :attr:`LP_MARK_DEFAULT` to indicate that the current
   directory is inside of a `VCSH <https://github.com/RichiH/vcsh>`_ repository.

   Since VCSH repositories are Git repositories under the hood,
   :attr:`LP_MARK_GIT` is surrounded in this mark.

.. attribute:: LP_MARK_WIFI
   :type: string
   :value: "📶"

   Mark used before displaying wireless signal strength.

   See also: :attr:`LP_ENABLE_WIFI_STRENGTH`.

   .. versionadded:: 2.1


.. _Colors:

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
   :value: ( "" $GREEN $BOLD_GREEN $YELLOW $BOLD_YELLOW $RED $BOLD_RED
                $WARN_RED $CRIT_RED $DANGER_RED )

   An array of colors that is used by the battery, load, temperature, and
   wireless signal strength features to indicate the severity level of their
   status. A normal or low status will use the first index, while the last index
   is the most severe.

   See also: :attr:`LP_ENABLE_BATT`, :attr:`LP_ENABLE_LOAD`,
   :attr:`LP_ENABLE_TEMP`, and :attr:`LP_ENABLE_WIFI_STRENGTH`.

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

.. attribute:: LP_COLOR_CMAKE_BUILD
   :type: string
   :value: $MAGENTA

   Color used to display the build type in the CMake segment.

   See :attr:`LP_ENABLE_CMAKE`.

   .. versionadded:: 2.2

.. attribute:: LP_COLOR_CMAKE_C
   :type: string
   :value: $MAGENTA

   Color used to display the C compiler in the CMake segment.

   See :attr:`LP_ENABLE_CMAKE`.

   .. versionadded:: 2.2

.. attribute:: LP_COLOR_CMAKE_CXX
   :type: string
   :value: $MAGENTA

   Color used to display the C++ compiler in the CMake segment.

   See :attr:`LP_ENABLE_CMAKE`.

   .. versionadded:: 2.2

.. attribute:: LP_COLOR_CMAKE_DEBUG
   :type: string
   :value: $MAGENTA

   Color for the *Debug* build type of the CMake section.

   See also: :attr:`LP_COLOR_CMAKE_RWDI` and :attr:`LP_COLOR_CMAKE_RELEASE`.

   .. versionadded:: 2.2

.. attribute:: LP_COLOR_CMAKE_RWDI
   :type: string
   :value: $BLUE

   Color for the *RelWithDebInfo* build type of the CMake section.

   See also: :attr:`LP_COLOR_CMAKE_DEBUG` and :attr:`LP_COLOR_CMAKE_RELEASE`.

   .. versionadded:: 2.2

.. attribute:: LP_COLOR_CMAKE_RELEASE
   :type: string
   :value: $CYAN

   Color for the *Release* build type of the CMake section.

   See also: :attr:`LP_COLOR_CMAKE_DEBUG` and :attr:`LP_COLOR_CMAKE_RWDI`.

   .. versionadded:: 2.2

.. attribute:: LP_COLOR_COMMITS_BEHIND
   :type: string
   :value: $BOLD_RED

   Color used to indicate that the current repository has a remote tracking
   branch that has commits that the local branch does not.

   May be used by :attr:`LP_ENABLE_VCS_REMOTE`.

.. attribute:: LP_COLOR_COMMITS
   :type: string
   :value: $YELLOW

   Color used to indicate that the current repository has commits on the local
   branch that the remote tracking branch does not.

   Also used to color :attr:`LP_MARK_STASH` and :attr:`LP_MARK_VCS_REMOTE`.

.. attribute:: LP_COLOR_CONTAINER
   :type: string
   :value: $BOLD_BLUE

   Color used to indicate that the current shell is running in a container.

   .. versionadded:: 2.1

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

.. attribute:: LP_COLOR_DISK
   :type: string
   :value: $BOLD_RED

   Color used for displaying information about the hard drive hosting the
   current directory.

   See also :attr:`LP_COLOR_DISK_UNITS`, :attr:`LP_ENABLE_DISK`,
   :attr:`LP_ALWAYS_DISPLAY_VALUES`, and :attr:`LP_PERCENTS_ALWAYS`.

   .. versionadded:: 2.2

.. attribute:: LP_COLOR_DISK_UNITS
   :type: string
   :value: $RED

   Color used for displaying the unit of the available space on the hard drive
   hosting the current directory.

   See also :attr:`LP_COLOR_DISK`, :attr:`LP_ENABLE_DISK`,
   :attr:`LP_ALWAYS_DISPLAY_VALUES`, and :attr:`LP_PERCENTS_ALWAYS`.

   .. versionadded:: 2.2

.. attribute:: LP_COLOR_ERR
   :type: string
   :value: $PURPLE

   Color used to indicate the last command exited with a non-zero return code.

   See also: :attr:`LP_ENABLE_ERROR`.

.. attribute:: LP_COLOR_ENV_VARS_SET
   :type: string
   :value: $BOLD_BLUE

   Color of the environment variables that are set,
   in the user-defined watch list.

   See also:
   - :attr:`LP_ENABLE_ENV_VARS`
   - :attr:`LP_ENV_VARS`
   - :attr:`LP_COLOR_ENV_VARS_UNSET`
   - :attr:`LP_MARK_ENV_VARS_OPEN`
   - :attr:`LP_MARK_ENV_VARS_SEP`
   - :attr:`LP_MARK_ENV_VARS_CLOSE`

.. attribute:: LP_COLOR_ENV_VARS_UNSET
   :type: string
   :value: $BLUE

   Color of the environment variables that are unset,
   in the user-defined watch list.

   See also:

   - :attr:`LP_ENABLE_ENV_VARS`
   - :attr:`LP_ENV_VARS`
   - :attr:`LP_COLOR_ENV_VARS_SET`
   - :attr:`LP_MARK_ENV_VARS_OPEN`
   - :attr:`LP_MARK_ENV_VARS_SEP`
   - :attr:`LP_MARK_ENV_VARS_CLOSE`

   .. versionadded:: 2.2

.. attribute:: LP_COLOR_HOST
   :type: string
   :value: ""

   Color used for the hostname when connected locally.

   See also: :attr:`LP_HOSTNAME_ALWAYS`.

.. attribute:: LP_COLOR_IN_MULTIPLEXER
   :type: string
   :value: $BOLD_BLUE

   Color used for :attr:`LP_MARK_MULTIPLEXER_OPEN` and
   :attr:`LP_MARK_MULTIPLEXER_CLOSE` if the terminal is in a multiplexer.

   .. versionchanged:: 2.2
      Can be disabled by :attr:`LP_ENABLE_MULTIPLEXER`.

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

   Color used for :attr:`LP_MARK_DEFAULT` when ``sudo`` is active, shown instead
   of :attr:`LP_COLOR_MARK`.

   See also: :attr:`LP_ENABLE_SUDO`.

.. attribute:: LP_COLOR_MODULES
   :type: string
   :value: $BLUE

   Color used for displaying currently loaded modules
   (if :attr:`LP_ENABLE_MODULES_HASHCOLOR` is disabled).

   See also: :attr:`LP_ENABLE_MODULES`.

.. attribute:: LP_COLOR_NODE_VENV
   :type: string
   :value: $LP_COLOR_VIRTUALENV

   Color used for displaying a Node.js virtual environment.

   See also: :attr:`LP_ENABLE_NODE_VENV`.

   .. versionadded:: 2.1

.. attribute:: LP_COLOR_NOWRITE
   :type: string
   :value: $RED

   Color used for :attr:`LP_MARK_PERM` when the user does not have write
   permissions to the current working directory.

   See also: :attr:`LP_ENABLE_PERM` and :attr:`LP_COLOR_WRITE`.

.. attribute:: LP_COLOR_OS_ARCH
   :type: string
   :value: $MAGENTA

   Color used for OS' architecture (e.g. "x86_64", "i686"…).

   See also: :attr:`LP_ENABLE_OS` and :attr:`LP_ENABLE_OS_ARCH`.

   .. versionadded:: 2.2

.. attribute:: LP_COLOR_OS_DISTRIB
   :type: string
   :value: $MAGENTA

   Color used for OS' distribution (e.g. "Ubuntu", "Debian"…).

   .. note:: Will probably only work on Linux-like systems.

   See also: :attr:`LP_ENABLE_OS` and :attr:`LP_ENABLE_OS_DISTRIB`.

   .. versionadded:: 2.2

.. attribute:: LP_COLOR_OS_FAMILY
   :type: string
   :value: $MAGENTA

   Color used for OS' family (e.g. "BSD", "GNU"…).

   See also: :attr:`LP_ENABLE_OS` and :attr:`LP_ENABLE_OS_FAMILY`.

   .. versionadded:: 2.2

.. attribute:: LP_COLOR_OS_KERNEL
   :type: string
   :value: $MAGENTA

   Color used for OS' kernel (e.g. "Linux", "MinGW"…).

   See also: :attr:`LP_ENABLE_OS` and :attr:`LP_ENABLE_OS_KERNEL`.

   .. versionadded:: 2.2

.. attribute:: LP_COLOR_OS_VERSION
   :type: string
   :value: $MAGENTA

   Color used for OS' version codename (e.g. "focal", "buster"…).

   .. note:: Will probably only work on Linux-like systems.

   See also: :attr:`LP_ENABLE_OS` and :attr:`LP_ENABLE_OS_VERSION`.

   .. versionadded:: 2.2

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

   .. versionadded:: 2.0

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

   .. versionadded:: 2.0

.. attribute:: LP_COLOR_PERL_VENV
   :type: string
   :value: $LP_COLOR_VIRTUALENV

   Color used for displaying a Perl virtual environment.

   See also: :attr:`LP_ENABLE_PERL_VENV`.

   .. versionadded:: 2.2

.. attribute:: LP_COLOR_PROXY
   :type: string
   :value: $BOLD_BLUE

   Color used for :attr:`LP_MARK_PROXY`.

   See also: :attr:`LP_ENABLE_PROXY`.

.. attribute:: LP_COLOR_RAM
   :type: string
   :value: $BOLD_RED

   Color used for displaying information about the available RAM.

   See also :attr:`LP_COLOR_RAM_UNITS`, :attr:`LP_ENABLE_RAM`,
   :attr:`LP_ALWAYS_DISPLAY_VALUES`, and :attr:`LP_PERCENTS_ALWAYS`.

   .. versionadded:: 2.2

.. attribute:: LP_COLOR_RAM_UNITS
   :type: string
   :value: $RED

   Color used for displaying the unit of the available RAM.

   See also :attr:`LP_COLOR_RAM`, :attr:`LP_ENABLE_RAM`,
   :attr:`LP_ALWAYS_DISPLAY_VALUES`, and :attr:`LP_PERCENTS_ALWAYS`.

   .. versionadded:: 2.2

.. attribute:: LP_COLOR_RUBY_VENV
   :type: string
   :value: $LP_COLOR_VIRTUALENV

   Color used for displaying a Ruby virtual environment.

   See also: :attr:`LP_ENABLE_RUBY_VENV`.

   .. versionadded:: 2.1

.. attribute:: LP_COLOR_RUNTIME
   :type: string
   :value: $YELLOW

   Color used for displaying the last command runtime.

   See also: :attr:`LP_ENABLE_RUNTIME`.

.. attribute:: LP_COLOR_SHLVL
   :type: string
   :value: $BOLD_GREEN

   Color used for displaying the nested shell level.

   See also: :attr:`LP_ENABLE_SHLVL`, :attr:`LP_SHLVL_THRESHOLD`, and
   :attr:`LP_MARK_SHLVL`.

   .. versionadded:: 2.1

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

.. attribute:: LP_COLOR_TERRAFORM
   :type: string
   :value: $PINK

   Color used for displaying a Terraform workspace.

   See also: :attr:`LP_ENABLE_TERRAFORM`.

   .. versionadded:: 2.1

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

   Color used for displaying a Python virtual environment or Red Hat Software
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

   See also :attr:`LP_ENABLE_DISPLAY`.

.. attribute:: LP_COLOR_X11_ON
   :type: string
   :value: $GREEN

   Color used for indicating that a display is connected.

   See also :attr:`LP_ENABLE_DISPLAY`.
