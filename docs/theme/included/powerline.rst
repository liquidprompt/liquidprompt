***************
Powerline Theme
***************

The included ``themes/powerline/powerline.theme`` file includes two themes:

.. contents::
   :local:

Powerline
*********

The ``powerline`` theme is a clone of the `Powerline prompt`_. It copies the
`default segments`_ of the Powerline prompt for Shell.

This prompt is a proof of (a specific) concept: that Liquidprompt can do what
Powerline does, but faster.
That said, this is a fully usable theme.

.. versionadded:: 2.0

.. _`Powerline prompt`: https://github.com/powerline/powerline
.. _`default segments`: https://github.com/powerline/powerline/blob/2.8/powerline/config_files/themes/shell/default.json

Preview
=======

If there is nothing special about the current context, the appearance of
Powerline might be as simple as this:

.. image:: powerline-short.png
   :alt:  user  ~  

If you are running a background command and are also in the "main" branch of a
Git repository on a server:

.. image:: powerline-med.png
   :alt:   server  user  ~  liquidprompt  1   main  

When Liquidprompt is displaying nearly everything, it may look like this:

.. image:: powerline-long.png
   :alt:   server  user  (e) pyenv  ~   …   liquidprompt   …   theme  3   main  ST 1  125  

.. note::
   The above "everything" image looks like it is missing some parts because this
   theme does not implement all data sources of Liquidprompt. This is by design
   to clone basic Powerline. For a Powerline theme that does show all data
   sources, see :ref:`Powerline Full <powerline_full>` below.

Setup
=====

By default, the dividers and markers used are the Powerline private characters.
You will either need a compatible font, or to configure the dividers and markers
to use other characters.

See the `Powerline Fonts installation docs`_ for help.

.. _`Powerline fonts installation docs`: https://powerline.readthedocs.io/en/latest/installation.html#fonts-installation

Configuration
=============

Liquidprompt Configuration
--------------------------
The following Liquidprompt config options are respected:

* :attr:`LP_DISABLED_VCS_PATHS`
* :attr:`LP_ENABLE_BZR`
* :attr:`LP_ENABLE_COLOR`
* :attr:`LP_ENABLE_ERROR`
* :attr:`LP_ENABLE_FOSSIL`
* :attr:`LP_ENABLE_FQDN`
* :attr:`LP_ENABLE_GIT`
* :attr:`LP_ENABLE_HG`
* :attr:`LP_ENABLE_JOBS`
* :attr:`LP_ENABLE_RUNTIME_BELL`
* :attr:`LP_ENABLE_SCREEN_TITLE`
* :attr:`LP_ENABLE_SHORTEN_PATH`
* :attr:`LP_ENABLE_SVN`
* :attr:`LP_ENABLE_TITLE`
* :attr:`LP_ENABLE_VCS_ROOT`
* :attr:`LP_ENABLE_VIRTUALENV`
* :attr:`LP_HOSTNAME_ALWAYS`
* :attr:`LP_PATH_CHARACTER_KEEP`
* :attr:`LP_PATH_KEEP`
* :attr:`LP_PATH_LENGTH`
* :attr:`LP_PATH_METHOD`
* :attr:`LP_PATH_VCS_ROOT`
* :attr:`LP_RUNTIME_BELL_THRESHOLD`
* :attr:`LP_USER_ALWAYS`

Theme Configuration
-------------------

Powerline adds these config options:

Markers
_______

.. attribute:: POWERLINE_HARD_DIVIDER
   :type: string
   :value: ""  # U+E0B0

   The divider character between sections, defaults to the private character
   used in Powerline fonts that looks like a solid right arrow.

.. attribute:: POWERLINE_PYTHON_ENV_MARKER
   :type: string
   :value: "(e) "

   The marker string used to indicate the following string is a Python
   environment.

.. attribute:: POWERLINE_ROOT_MARKER
   :type: string
   :value: "#"

   The marker character used to indicate a root session.

.. attribute:: POWERLINE_SECURE_MARKER
   :type: string
   :value: ""  # U+E0A2

   The marker character used to indicate a SSH session, defaults to the
   private character used in Powerline fonts that looks like a lock.

.. attribute:: POWERLINE_SOFT_DIVIDER
   :type: string
   :value: ""  # U+E0B1

   The divider character between similar sections, defaults to the private
   character used in Powerline fonts that looks like a thin right arrow.

.. attribute:: POWERLINE_SPACER
   :type: string
   :value: " "  # U+00A0: non-breaking space

   The marker character used to pad sections, defaults to the
   non-breaking space character.

   To add more padding, add more spaces to this string.

   A non-breaking space is needed in some fonts to prevent multiple spaces from
   collapsing to one space, loosing the padding.

.. attribute:: POWERLINE_STASH_MARKER
   :type: string
   :value: "ST"

   The marker string used to indicate stashes exist in the VCS repository.

.. attribute:: POWERLINE_VCS_MARKER
   :type: string
   :value: ""  # U+E0A0

   The marker character used to indicate a VCS repository, defaults to the
   private character used in Powerline fonts that looks like a branching commit
   history.

Colors
______

These color config options take an array of integers, which are arguments to
:func:`lp_terminal_format`.

.. note::
   Arrays are set without commas (``,``). The default values are displayed with
   commas for clarity.

.. attribute:: POWERLINE_ERROR_COLOR
   :type: array<int>
   :value: (231, 52, 0, 0, 7, 1)

   Color for the error code section.

.. attribute:: POWERLINE_HOST_COLOR
   :type: array<int>
   :value: (220, 166, 0, 0, 3, 2)

   Color for the hostname section.

.. attribute:: POWERLINE_JOBS_COLOR
   :type: array<int>
   :value: (220, 166, 0, 0, 3, 2)

   Color for the shell jobs section.

.. attribute:: POWERLINE_PATH_COLOR
   :type: array<int>
   :value: (250, 240, 0, 0, 7, 0)

   Color for the current working directory section.

.. attribute:: POWERLINE_PATH_LAST_COLOR
   :type: array<int>
   :value: (252, 240, 1, 0, 7, 0)

   Color for the current working directory last subsection.

.. attribute:: POWERLINE_PATH_SEPARATOR_COLOR
   :type: array<int>
   :value: (245, 240, 0, 0, 7, 0)

   Color for the current working directory subsection separator.

.. attribute:: POWERLINE_PATH_SHORTENED_COLOR
   :type: array<int>
   :value: (245, 240, 0, 0, 7, 0)

   Color for any sections in the current working directory that are shortened to
   make the path fit in :attr:`LP_PATH_LENGTH`.

.. attribute:: POWERLINE_PATH_VCS_COLOR
   :type: array<int>
   :value: (147, 240, 1, 0, 4, 0)

   Color for the current working directory segment corresponding to the current
   VCS repository root directory.

   :attr:`LP_PATH_VCS_ROOT` must be enabled to have any effect.

.. attribute:: POWERLINE_PYTHON_ENV_COLOR
   :type: array<int>
   :value: (231, 74, 0, 0, 7, 4)

   Color for the Python environment section.

.. attribute:: POWERLINE_USER_COLOR
   :type: array<int>
   :value: (231, 31, 1, 0, 7, 6)

   Color for the username section.

.. attribute:: POWERLINE_VCS_CLEAN_COLOR
   :type: array<int>
   :value: (250, 236, 0, 0, 7, 0)

   Color for the VCS section if the repository is clean.

.. attribute:: POWERLINE_VCS_DIRTY_COLOR
   :type: array<int>
   :value: (220, 236, 0, 0, 3, 0)

   Color for the VCS section if the repository is not clean.

.. attribute:: POWERLINE_VCS_STASH_COLOR
   :type: array<int>
   :value: (220, 236, 0, 0, 3, 0)

   Color for the VCS stash subsection.

.. _powerline_full:

Powerline Full
**************

An extension of the ``powerline`` theme, ``powerline_full`` includes all data
sources that Liquidprompt provides. The ordering is the same as the default
theme.

.. versionadded:: 2.0

Preview
=======

If there is nothing special about the current context, the appearance of
Powerline might be as simple as this:

.. image:: powerline_full-short.png
   :alt:  user  ~  

If you are running a background command and are also in the "main" branch of a
Git repository on a server:

.. image:: powerline_full-med.png
   :alt:  1&  user   server  ~  liquidprompt  main  

When Liquidprompt is displaying nearly everything, it may look like this:

.. image:: powerline_full-long.png
   :alt:  🕤  ⌁24%  ⌂1.68  θ90°  3d/2&/1z  user   server  ~   …   liquidprompt   …   theme  ⚞3  (e) pyenv  main(+10/-5,+3/-1)+*  20s  125  

Setup
=====

Like the ``powerline`` theme, you will need a compatible font.
See the `Powerline Fonts installation docs`_ for help.

Configuration
=============

Liquidprompt Configuration
--------------------------
All Liquidprompt config options are respected, **except for**:

* :attr:`LP_COLOR_DIRSTACK`
* :attr:`LP_COLOR_ERR`
* :attr:`LP_COLOR_HOST`
* :attr:`LP_COLOR_IN_MULTIPLEXER`
* :attr:`LP_COLOR_JOB_D`
* :attr:`LP_COLOR_JOB_R`
* :attr:`LP_COLOR_JOB_Z`
* :attr:`LP_COLOR_MARK`
* :attr:`LP_COLOR_MARK_ROOT`
* :attr:`LP_COLOR_MARK_SUDO`
* :attr:`LP_COLOR_NOWRITE`
* :attr:`LP_COLOR_PATH`
* :attr:`LP_COLOR_PATH_ROOT`
* :attr:`LP_COLOR_PROXY`
* :attr:`LP_COLOR_RUNTIME`
* :attr:`LP_COLOR_SSH`
* :attr:`LP_COLOR_SU`
* :attr:`LP_COLOR_TELNET`
* :attr:`LP_COLOR_TERRAFORM`
* :attr:`LP_COLOR_TIME`
* :attr:`LP_COLOR_USER_ALT`
* :attr:`LP_COLOR_USER_LOGGED`
* :attr:`LP_COLOR_USER_ROOT`
* :attr:`LP_COLOR_VIRTUALENV`
* :attr:`LP_COLOR_WRITE`
* :attr:`LP_COLOR_X11_OFF`
* :attr:`LP_COLOR_X11_ON`
* :attr:`LP_ENABLE_PERM`
* :attr:`LP_ENABLE_SSH_COLORS`
* :attr:`LP_ENABLE_SUDO`
* :attr:`LP_MARK_BRACKET_OPEN`
* :attr:`LP_MARK_BRACKET_CLOSE`
* :attr:`LP_MARK_BZR`
* :attr:`LP_MARK_DEFAULT`
* :attr:`LP_MARK_DISABLED`
* :attr:`LP_MARK_FOSSIL`
* :attr:`LP_MARK_GIT`
* :attr:`LP_MARK_HG`
* :attr:`LP_MARK_PERM`
* :attr:`LP_MARK_PREFIX`
* :attr:`LP_MARK_PROXY`
* :attr:`LP_MARK_SVN`
* :attr:`LP_MARK_VCSH`

Theme Configuration
-------------------

Powerline Full uses all the config options of the above Powerline theme,
**except for**:

* :attr:`POWERLINE_STASH_MARKER`
* :attr:`POWERLINE_VCS_DIRTY_COLOR`
* :attr:`POWERLINE_VCS_MARKER`
* :attr:`POWERLINE_VCS_STASH_COLOR`

Powerline Full adds these config options:

Markers
_______

.. attribute:: POWERLINE_AWS_PROFILE_MARKER
   :type: string
   :value: "AWS: "

   The marker string used to indicate the following string is the name of an
   AWS profile.

.. attribute:: POWERLINE_CHROOT_MARKER
   :type: string
   :value: "chroot: "

   The marker string used to indicate the following string is a chroot.

.. attribute:: POWERLINE_KUBECONTEXT_MARKER
   :type: string
   :value: $LP_MARK_KUBECONTEXT

   The marker string used to indicate the following string is the name of a
   kubectl context.

.. attribute:: POWERLINE_PROXY_MARKER
   :type: string
   :value: "proxy: "

   The marker string used to indicate the following string is a HTTP proxy.

.. attribute:: POWERLINE_RUBY_ENV_MARKER
   :type: string
   :value: "ruby: "

   The marker string used to indicate the following string is a Ruby
   environment.

.. attribute:: POWERLINE_SOFTWARE_COLLECTION_MARKER
   :type: string
   :value: "(sc) "

   The marker string used to indicate the following string is a Red Hat Software
   Collection.

.. attribute:: POWERLINE_TERRAFORM_ENV_MARKER
   :type: string
   :value: "(tf) "

   The marker string used to indicate the following string is a Terraform
   workspace.

   .. versionadded:: 2.1

Colors
______

.. attribute:: POWERLINE_AWS_PROFILE_COLOR
   :type: array<int>
   :value: (190 236 0 0 3 0)

   Color for the AWS profile section.

.. attribute:: POWERLINE_BATTERY_COLOR
   :type: array<int>
   :value: (-1, 238, 0, 0, -1, 0)

   Color for the battery section.

.. attribute:: POWERLINE_CHROOT_COLOR
   :type: array<int>
   :value: (219, 30, 0, 0, 7, 4)

   Color for the chroot section.

.. attribute:: POWERLINE_DIRSTACK_COLOR
   :type: array<int>
   :value: $POWERLINE_NEUTRAL_COLOR

   Color for the directory stack section.

.. attribute:: POWERLINE_KUBECONTEXT_COLOR
   :type: array<int>
   :value: (231 74 0 0 7 4)

   Color for the Kubernetes context section.

.. attribute:: POWERLINE_LOAD_COLOR
   :type: array<int>
   :value: (-1, 148, 0, 0, -1, 3)

   Color for the CPU load section.

.. attribute:: POWERLINE_NEUTRAL_COLOR
   :type: array<int>
   :value: (252, 234, 0, 0, 7, 0)

   Color for all neutral sections, :attr:`LP_PS1_PREFIX` and
   :attr:`LP_PS1_POSTFIX`.

.. attribute:: POWERLINE_PROXY_COLOR
   :type: array<int>
   :value: (21, 219, 1, 0, 4, 7)

   Color for the HTTP proxy section.

.. attribute:: POWERLINE_RUBY_ENV_COLOR
   :type: array<int>
   :value: (231 38 0 0 7 4)

   Color for the Ruby environment section.

.. attribute:: POWERLINE_RUNTIME_COLOR
   :type: array<int>
   :value: (226, 17, 0, 0, 3, 4)

   Color for the command runtime section.

.. attribute:: POWERLINE_SOFTWARE_COLLECTIONS_COLOR
   :type: array<int>
   :value: (231, 62, 0, 0, 7, 5)

   Color for the Red Hat Software Collections section.

.. attribute:: POWERLINE_TEMPERATURE_COLOR
   :type: array<int>
   :value: (-1, 240, 0, 0, -1, 0)

   Color for the temperature section.

.. attribute:: POWERLINE_TERRAFORM_ENV_COLOR
   :type: array<int>
   :value: (231 182 0 0 7 4)

   Color for the Terraform workspace.

   .. versionadded:: 2.1

.. attribute:: POWERLINE_TIME_COLOR
   :type: array<int>
   :value: (33, 17, 0, 0, 5, 4)

   Color for the current time section.

