Data Functions
**************

.. contents::
   :local:

.. toctree::

   data/vcs

These functions are designed to be used by themes.

All data functions will return ``true`` (meaning return code ``0``) when they
are both enabled and have data. They will return ``false`` (meaning return code
``1``) when they do not have data. Most will return ``2`` when they are
disabled, either through the config or because the tool they depend on is not
installed. Such disable config options will be documented. Exceptions to this
rule are explicitly documented.

When a function returns ``false``, any return variables are not guaranteed to
be set. If running with ``set -u`` (or when building a theme to be
distributed), guard any return variable accesses with a check of the return
code, or use ``${var-}`` syntax.

Battery
-------

.. function:: _lp_battery() -> var:lp_battery

   Returns a return code depending on the status of the battery:

   * ``5`` if the battery feature is disabled or not available
   * ``4`` if no battery level is found
   * ``3`` if charging and the level is above the threshold
   * ``2`` if charging and the level is under the threshold
   * ``1`` if discharging and the level is above the threshold
   * ``0`` if discharging and the level is under the threshold

   Returns an integer percentage of the current battery level.

   If the threshold is not surpassed, the battery level is still returned.

   The threshold is configured with :attr:`LP_BATTERY_THRESHOLD`.

   Can be disabled by :attr:`LP_ENABLE_BATT`.

   .. versionchanged:: 2.1
      Implemented `sysfs` method as the default way of getting battery status.


Development Environment
-----------------------

.. function:: _lp_cmake() -> var:lp_cmake_compiler, var:lp_cmake_generator, var:lp_cmake_buildtype

   Returns ``true`` if a CMake context is found. Parse the data in
   `CMakeCache.txt` and returns the basename of the configured compiler,
   generator (e.g. "Unix Makefiles"), and build type ("Debug", "Release", etc.).
   Some generator names are shorten: "Makefiles" becomes "Make" and "Visual
   Studio" becomes "VS".

   Can be disabled by :attr:`LP_ENABLE_CMAKE`.

   .. versionadded:: 2.2

.. function:: _lp_kubernetes_context() -> var:lp_kubernetes_context, var:lp_kubernetes_namespace

   Returns ``true`` if a Kubernetes context is found.
   Returns the Kubernetes context name or the first name component.

   Splitting long context names into components is defined by
   :attr:`LP_DELIMITER_KUBECONTEXT_SUFFIX` and
   :attr:`LP_DELIMITER_KUBECONTEXT_PREFIX`. Both use greedy matches - see
   :doc:`../config` for examples.

   If enabled by :attr:`LP_ENABLE_KUBE_NAMESPACE`, will also return the default
   namespace for the current context, if one is set.

   Can be disabled by :attr:`LP_ENABLE_KUBECONTEXT`.

   .. versionadded:: 2.1

.. function:: _lp_node_env() -> var:lp_node_env

   Returns ``true`` if a Node.js environment is detected. Returns the virtual
   environment name.

   Can be enabled by :attr:`LP_ENABLE_NODE_VENV`.

   .. versionadded:: 2.1

.. function:: _lp_perl_env() -> var:lp_perl_env

   Returns ``true`` if a Perlbrew or PLENV Perl environment is detected.
   Returns the virtual environment name.

   Can be disabled by :attr:`LP_ENABLE_PERL_VENV`.

   .. versionadded:: 2.2

.. function:: _lp_python_env() -> var:lp_python_env

   Returns ``true`` if a Python or Conda environment is detected. Returns the
   virtual environment name.

   If the environment name contains a forward slash (``/``), only the substring
   after the last forward slash is returned.

   Can be disabled by :attr:`LP_ENABLE_VIRTUALENV`.

   .. versionadded:: 2.0

   .. versionchanged:: 2.1
      Displays the "prompt string" first (the ``--prompt`` argument when setting
      up the virtualenv).

.. function:: _lp_ruby_env() -> var:lp_ruby_env

   Returns ``true`` if a RVM or RBENV ruby environment is detected. Returns the
   virtual environment name.

   In the case of a RVM environment, the label displayed can be customized
   with the :attr:`LP_RUBY_RVM_PROMPT_OPTIONS`.

   Can be disabled by :attr:`LP_ENABLE_RUBY_VENV`.

   .. versionadded:: 2.1

.. function:: _lp_software_collections() -> var:lp_software_collections

   Returns ``true`` if a `Red Hat Software Collection`_ is enabled. Returns the
   software collection name.

   If the software collection name has trailing whitespace, it is removed.

   Can be disabled by :attr:`LP_ENABLE_SCLS`.

   .. versionadded:: 2.0

   .. _`Red Hat Software Collection`: https://developers.redhat.com/products/softwarecollections/overview

.. function:: _lp_terraform_env() -> var:lp_terraform_env

   Returns ``true`` if a Terraform workspace is detected. Returns the workspace
   name.

   Can be enabled by :attr:`LP_ENABLE_TERRAFORM`.

   .. versionadded:: 2.1


Disks and Memory
----------------

.. function:: _lp_disk -> var:lp_disk, var:lp_disk_human, var:lp_disk_perc

   Gather information about the current state of the hard drive hosting the
   *current directory*:

   * available space in kibi-bytes (``lp_disk``, that is, 1024 bytes),
   * available space in human-readable form, using binary unit prefixes
     (``lp_disk_human``, see also :func:`__lp_bytes_to_human`).
   * available space as a percentage of total (``lp_disk_perc``).

   Returns ``true`` if the used space is below at least one of the user-defined
   thresholds:

   * :attr:`LP_DISK_THRESHOLD`
   * :attr:`LP_DISK_THRESHOLD_PERC`

   Can be disabled by :attr:`LP_ENABLE_DISK`.

   .. versionadded:: 2.2

.. function:: _lp_ram -> var:lp_ram, var:lp_ram_human, var:lp_ram_perc

   Gather information about the current state of the RAM:

   * available space in kibi-bytes (``lp_ram``, that is, 1024 bytes),
   * available space in human-readable form, using binary unit prefixes
     (``lp_ram_human``, see also :func:`__lp_bytes_to_human`).
   * available space as a percentage of total (``lp_ram_perc``).

   Returns ``true`` if the used space is below at least one of the user-defined
   thresholds:

   * :attr:`LP_RAM_THRESHOLD`
   * :attr:`LP_RAM_THRESHOLD_PERC`

   Can be disabled by :attr:`LP_ENABLE_RAM`.

   .. versionadded:: 2.2


Environment
-----------

.. function:: _lp_aws_profile() -> var:lp_aws_profile

   Returns ``true`` if the :envvar:`AWS_PROFILE`, :envvar:`AWS_DEFAULT_PROFILE`,
   or :envvar:`AWS_VAULT` variables are found in the environment
   (in that order of preference). Returns the contents of the variable.

   Can be disabled by :attr:`LP_ENABLE_AWS_PROFILE`.

   .. versionadded:: 2.1

.. function:: _lp_connected_display()

   Returns ``true`` if there is a connected X11 display.

   .. versionadded:: 2.0

   .. versionchanged:: 2.2
      Can be disabled by :attr:`LP_ENABLE_DISPLAY`.

.. function:: _lp_connection() -> var:lp_connection

   Returns a string matching the connection context of the shell. Valid values:

   * ``ssh`` - connected over OpenSSH
   * ``tel`` - connected over Telnet
   * ``su`` - running in a ``su`` or ``sudo`` shell
   * ``lcl`` - running in a local terminal

   It is not possible for more than one context to be returned. The contexts
   are checked in the order listed above, and the first one found will be
   returned.

   It is not possible for no context to be returned.

   .. versionchanged:: 2.0
      Return method changed from stdout.

.. function:: _lp_container() -> var:lp_container

   Returns ``true`` if the shell is running in a container. In that case, the
   return variable is set to a string matching the container type. Possible
   values include (but are not limited to):

   * ``Singlrty`` - running in a `Singularity`_ container
   * ``Toolbox`` - running in a `Toolbox`_ container
   * ``Podman`` - running in a `Podman`_ container
   * ``Docker`` - running in a `Docker`_ container
   * ``LXC`` - running in an `LXC`_ container
   * ``nspawn`` - running in a `systemd-nspawn`_ container

   .. _Singularity: https://sylabs.io/guides/latest/user-guide/
   .. _Toolbox: https://containertoolbx.org/
   .. _Podman: https://podman.io/
   .. _Docker: https://www.docker.com/
   .. _LXC: https://linuxcontainers.org/lxc/
   .. _systemd-nspawn: https://www.freedesktop.org/software/systemd/man/systemd-nspawn.html

   It is not possible to detect more than one containerization type to be
   returned. The containers are checked in the order listed above, and the first
   one found will be returned.

    Can be enabled by :attr:`LP_ENABLE_CONTAINER`.

   .. versionadded:: 2.1

.. function:: _lp_dirstack() -> var:lp_dirstack

    Returns ``true`` if directory stack support is enabled and the directory
    stack contains more than one directory. In that case, the return variable
    is set to the number of directories on the stack.

    Can be enabled by :attr:`LP_ENABLE_DIRSTACK`.

    .. versionadded:: 2.0

.. function:: _lp_env_vars([color_if_set, [color_if_unset, [end_color]]]) -> var:lp_env_vars

   Gather the states of the environment variables indicated in the
   :attr:`LP_ENV_VARS` array,
   and put them in the ``lp_env_vars`` array.

   :attr:`LP_ENV_VARS` should be a list of environment variable names
   to look for, along with the string to be displayed if the variable is set,
   and an optional string to be displayed if the variable is not set.
   The string to be displayed may contain a ``%s`` marker,
   which will be replaced by the variable's content.

   If ``color_if_set`` is passed, it will be used to color the *set*
   variables string. If ``color_if_unset`` is passed, it will be used to color
   the *unset* variables string.

   ``end_color`` is added at the end of each variable string.
   It defaults to "$NO_COL" (color reset).

   Returns ``true`` if at least one variable representation is added to
   the result array. Returns ``1`` if the no variable representation is set.
   Returns ``2`` if the user disabled the feature
   with :attr:`LP_ENABLE_ENV_VARS`.

   .. versionadded:: 2.2

.. function:: _lp_error() -> var:lp_error

   Returns ``true`` if the last user shell command returned a non-zero exit
   code. Returns (in the return variable) the exit code of that command.

   Can be disabled by :attr:`LP_ENABLE_ERROR`.

   .. note::

      The return variable ``lp_error`` will always be set with the last command
      return code, as it must be the first thing done by the prompt. This
      function should still be used, as it checks for the feature being
      disabled by the user.

   .. versionadded:: 2.0

.. function:: _lp_error_meaning() -> var:lp_error_meaning

   Returns ``true`` if the last user shell command returned a non-zero exit
   code. Returns (in the return variable) a guess of the meaning of that error.

   Can be disabled by :attr:`LP_ENABLE_ERROR_MEANING`.

   .. versionadded:: 2.2

.. function:: _lp_http_proxy() -> var:lp_http_proxy

   Returns ``true`` if an HTTP or HTTPS proxy is enabled through environment
   variables in the shell. Returns the first found proxy string.

   Can be disabled by :attr:`LP_ENABLE_PROXY`.

   .. versionadded:: 2.0

.. function:: _lp_multiplexer() -> var:lp_multiplexer

   Returns ``true`` if the current shell context is inside a terminal
   multiplexer. Returns a string matching the multiplexer:

   * ``tmux``
   * ``screen``

   .. versionadded:: 2.0

   .. versionchanged:: 2.2
      Can be disabled by :attr:`LP_ENABLE_MULTIPLEXER`,
      except if ``--internal`` is passed (i.e. for internal use only).
      Return variable renamed from ``lp_mulitplexer`` to ``lp_multiplexer``.

.. function:: _lp_shell_level() -> var:lp_shell_level

    Returns ``true`` if the shell is a nested shell inside another shell.

    Can be disabled by :attr:`LP_ENABLE_SHLVL`.

    .. versionadded:: 2.1

.. function:: _lp_terminal_device() -> var:lp_terminal_device

   Returns the basename of the terminal device connected to the shell's standard
   input.

   .. note::
      This value should never change during the life of the shell.

   .. note::
      This data source is unlikely to be wanted by the user, and should not be
      included in themes by default.

   .. versionadded:: 2.0

Jobs
----

.. function:: _lp_detached_sessions() -> var:lp_detached_sessions

   Returns ``true`` if any detached multiplexer sessions are found. Returns an
   integer count of how many sessions were found.

   Can be disabled by :attr:`LP_ENABLE_DETACHED_SESSIONS`.

   .. versionadded:: 2.0

.. function:: _lp_jobcount() -> var:lp_running_jobs, var:lp_stopped_jobs

   Returns ``true`` if any shell background jobs are found. Returns an integer
   count of how many jobs are running and how many are stopped.

   Stopped jobs are jobs suspended with `Ctrl-Z`.

   Running jobs are jobs started with the ``command &`` syntax, or stopped jobs
   started again with the ``bg`` command.

   Can be disabled by :attr:`LP_ENABLE_JOBS`.

   .. versionadded:: 2.0

Load
----

.. function:: _lp_cpu_load() -> var:lp_cpu_load

   Returns a string of the system load average smallest increment, usually 1
   minute. The return code is not defined.

.. function:: _lp_load() -> var:lp_load, var:lp_load_adjusted

   Returns ``true`` if the system load average scaled by CPU count is greater
   than the threshold. Returns the system load average in *lp_load*, and the
   average scaled by CPU count, multiplied by 100 in *lp_load_adjusted*. In
   other words, the load average is multiplied by 100, then divided by the
   number of CPU cores.

   *lp_load* should be displayed to the user, while *lp_load_adjusted* should be
   used to compare values between machines using :attr:`LP_LOAD_CAP`. The
   default theme uses this to generate a color scale.

   .. note::
      :attr:`LP_LOAD_CAP` is a raw floating point configuration value that is
      difficult to do math on. ``_LP_LOAD_CAP`` contains the same value, but
      multiplied by 100 to make comparisons to *lp_load_adjusted* simple. Use
      it along with *lp_load_adjusted* as arguments to :func:`_lp_color_map`.

   If the threshold is not surpassed, the load average is still returned.

   The threshold is configured with :attr:`LP_LOAD_THRESHOLD`.

   Can be disabled by :attr:`LP_ENABLE_LOAD`.

   .. versionadded:: 2.0

OS
--

.. function:: _lp_chroot() -> var:lp_chroot

   Returns ``true`` if a chroot environment is detected. Returns a string
   matching the chroot string if one is found.

   .. versionadded:: 2.0

   .. versionchanged:: 2.2
      Can be disabled by :attr:`LP_ENABLE_CHROOT`.

.. function:: _lp_hostname() -> var:lp_hostname

   Returns ``true`` if a hostname should be displayed. Returns ``1`` if the
   connection type is local and :attr:`LP_HOSTNAME_ALWAYS` is not ``1``.

   Returns the hostname string in *lp_hostname*.

   Can be disabled by :attr:`LP_HOSTNAME_ALWAYS` set to ``-1``.

   .. versionadded:: 2.0

   .. versionchanged:: 2.1
      Returns the actual hostname instead of a shell prompt escape code.
      No longer sets ``LP_HOST_SYMBOL`` to the same return string.
      Added :attr:`LP_HOSTNAME_METHOD` to configure display method.

.. function:: _lp_os() -> var:lp_os_arch, var:lp_os_family, var:lp_os_kernel, var:lp_os_distrib, var:lp_os_version

   Gather data about the current Operating System.

   Returns ``true`` if it was able to gather all possible data.
   Returns ``1`` if some expected information was missing.
   Returns ``2`` if the user disabled the feature with :attr:`LP_ENABLE_OS`.

   Returns data in ``lp_os_*`` variables:

   - processor architecture (e.g. x86_64, i686, etc.),
   - OS family (BSD, UNIX, GNU or Windows),
   - OS kernel (Linux, Darwin, Cygwin, etc.),
   - Linux *distribution* (e.g. ubuntu, arch, mandrake, etc.),
   - Linux distribution *version codename* (e.g. focal, ada, buzz, etc.)

   Each data source can be disabled
   via its corresponding configuration variable:

   - :attr:`LP_ENABLE_OS_ARCH`
   - :attr:`LP_ENABLE_OS_FAMILY`
   - :attr:`LP_ENABLE_OS_KERNEL`
   - :attr:`LP_ENABLE_OS_DISTRIB`
   - :attr:`LP_ENABLE_OS_VERSION`

   .. versionadded:: 2.2

.. function:: _lp_sudo_active()

   Returns ``true`` if ``sudo`` is currently activated with valid credentials.
   If ``sudo`` is configured to always allow a user to run commands with no
   password, this will always return ``true``.

   Can be disabled by :attr:`LP_ENABLE_SUDO`.

   .. versionadded:: 2.0

   .. versionchanged:: 2.1
      If the user has NOPASSWD powers, that is cached on startup to prevent
      multiple ``sudo`` calls.

.. function:: _lp_user()

   Returns a return code depending on the logged in user:

   * ``2`` - the user is root
   * ``1`` - the user is a user other than the original login user
   * ``0`` - the user is the login user

   .. versionadded:: 2.0

.. function:: _lp_username() -> var:lp_username

   Returns ``true`` if a username should be displayed. Returns ``1`` if the
   user is the login user and :attr:`LP_USER_ALWAYS` is not ``1``.

   Returns the current user ID in *lp_username*.

   Can be disabled by :attr:`LP_USER_ALWAYS` set to ``-1``.

   .. versionadded:: 2.0

   .. versionchanged:: 2.1
      Returns the actual username instead of a shell prompt escape code.

Path
----

.. function:: _lp_path_format(path_format=$LP_COLOR_PATH, \
   last_directory_format=$path_format, vcs_root_format=$last_directory_format, \
   shortened_directory_format=$path_format, separator="/", \
   [separator_format]) -> var:lp_path, var:lp_path_format

   Returns a shortened and formatted string indicating the current working
   directory path. *lp_path* contains the path without any formatting, custom
   separators, or shell escapes, intended for use in the terminal title.
   *lp_path_format* contains the complete formatted path, to be inserted into
   the prompt.

   The behavior of the shortening is controlled by
   :attr:`LP_ENABLE_SHORTEN_PATH`, :attr:`LP_PATH_METHOD`,
   :attr:`LP_PATH_LENGTH`, :attr:`LP_PATH_KEEP`, :attr:`LP_PATH_CHARACTER_KEEP`,
   and :attr:`LP_PATH_VCS_ROOT`. See their descriptions for details on how they
   change the output of this function.

   The last directory in the displayed path will be shown with the
   *last_directory_format*.

   If a VCS repository is detected with :func:`_lp_find_vcs`, the root of the
   VCS repository is formatted with *vcs_root_format*. The detection method is
   the same as for all other VCS display, so if a VCS type or directory is
   disabled, it will not be detected.

   If the path shortening shortens a directory (or multiple consecutive
   directories), they will be formatted with *shortened_directory_format*.

   A custom *separator* will only be substituted in the *lp_path_format* output.
   Note that this will cut into maximum path length if the separator is longer
   than one character.

   With no specified *separator_format*, each separator will take the format of
   the directory section preceding it. Otherwise every separator will be
   formatted with *separator_format*. Note that the root directory is treated as
   a directory, and is formatted as such.

   .. versionadded:: 2.0

   .. versionchanged:: 2.1
      Changed *lp_path* to no longer contain shell escapes.

Runtime
-------

.. function:: _lp_runtime_format() -> var:lp_runtime_format

   Returns ``true`` if the last command runtime was greater than the threshold.
   Returns a formatted string of the total runtime, split into days, hours,
   minutes, and seconds. Ex: ``3h27m6s``.

   The threshold is configured with :attr:`LP_RUNTIME_THRESHOLD`.

   Can be disabled by :attr:`LP_ENABLE_RUNTIME`.

   .. versionadded:: 2.0

Temperature
-----------

.. function:: _lp_temperature() -> var:lp_temperature

   Returns ``true`` if the highest system temperature is greater than the
   threshold. Returns the highest temperature integer.

   If the threshold is not surpassed, the highest temperature is still returned.

   If no temperature data is found, returns ``false`` and *lp_temperature* will
   not be set.

   The threshold is configured with :attr:`LP_TEMP_THRESHOLD`.

   Can be disabled by :attr:`LP_ENABLE_TEMP`.

   .. versionadded:: 2.0
      Note that a function by this name was renamed to
      ``_lp_temperature_color``.

Time
----

.. function:: _lp_time() -> var:lp_time

   Returns ``true`` if digital time is enabled. Returns the current digital time
   string, formatting set by :attr:`LP_TIME_FORMAT`.

   Can be disabled by :attr:`LP_ENABLE_TIME`, or :attr:`LP_TIME_ANALOG` set to
   ``1``.

   .. versionadded:: 2.0

   .. versionchanged:: 2.1
      Returns the actual time instead of a shell prompt escape code.

.. function:: _lp_analog_time() -> var:lp_analog_time

   Returns ``true`` if analog time is enabled. Returns the current analog time
   as a single Unicode character, accurate to the closest 30 minutes.

   Can be disabled by :attr:`LP_ENABLE_TIME`, or :attr:`LP_TIME_ANALOG` set to
   ``0``.

   .. versionadded:: 2.0

Wireless
--------

.. function:: _lp_wifi_signal_strength() -> var:lp_wifi_signal_strength

   Returns ``true`` if the lowest wireless signal strength is lower than the
   threshold. Returns the lowest strength percentage.

   If the threshold is not surpassed, the lowest signal strength is still
   returned.

   If no wireless signal data is found, returns ``false`` and
   *lp_wifi_signal_strength* will not be set.

   The threshold is configured with :attr:`LP_WIFI_STRENGTH_THRESHOLD`.

   Can be disabled by :attr:`LP_ENABLE_WIFI_STRENGTH`.

   .. versionadded:: 2.1
