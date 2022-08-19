Packages
********

.. contents::
   :local:

Liquidprompt is packaged for many operating systems, though the latest version
in those repositories is not always up to date.

Latest Versions
===============

.. image:: https://repology.org/badge/vertical-allrepos/liquidprompt.svg
   :alt: Liquidprompt packaging status

Source: `repology.org <https://repology.org/project/liquidprompt/versions>`_.

Install commands
================

Archlinux
---------

.. image:: https://repology.org/badge/version-for-repo/aur/liquidprompt.svg
   :alt: Archlinux package
   :target: https://aur.archlinux.org/packages/liquidprompt

.. code-block::

   pacman -S liquidprompt

Debian
------

... and Debian derivatives.

.. image:: https://repology.org/badge/version-for-repo/debian_unstable/liquidprompt.svg
   :alt: Debian Unstable package
   :target: https://packages.debian.org/source/liquidprompt

.. image:: https://repology.org/badge/version-for-repo/ubuntu_22_04/liquidprompt.svg
   :alt: Ubuntu 22.04 package
   :target: https://packages.ubuntu.com/source/liquidprompt

.. image:: https://repology.org/badge/version-for-repo/mx_19_testing/liquidprompt.svg
   :alt: MX Linux MX-19 Testing package
   :target: http://mxrepo.com/mx/testrepo/pool/test/l/liquidprompt/

.. code-block::

   apt-get install liquidprompt

A small script, ``liquidprompt_activate`` (not to be confused with
:func:`lp_activate`) is included to ease activation of the prompt, which can be
used instead of the :ref:`shell-installation` instructions.

This will set the required environment:

* The files ``~/.bashrc`` and/or ``~/.zshrc`` are modified to load Liquidprompt
  at startup.
* If no previous ``~/.config/liquidpromptrc`` file exists, it will be created.

So, to get Liquidprompt working simply run:

.. code-block::

   liquidprompt_activate
   source ~/.bashrc  # or ~/.zshrc

Be aware that multiple invocations of the ``liquidprompt_activate`` command may
pollute ``~/.bashrc`` and/or ``~/.zshrc`` files.

Homebrew
--------

.. image:: https://repology.org/badge/version-for-repo/homebrew/liquidprompt.svg
   :alt: Homebrew package
   :target: https://formulae.brew.sh/formula/liquidprompt

.. code-block::

   brew install liquidprompt

Nix
---

.. image:: https://repology.org/badge/version-for-repo/nix_stable/liquidprompt.svg
   :alt: nixpkgs stable package
   :target: https://github.com/NixOS/nixpkgs/blob/master/pkgs/shells/liquidprompt/default.nix

.. code-block::

   nix-env -i liquidprompt

