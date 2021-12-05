Liquid Prompt — a useful adaptive prompt for Bash & zsh
=======================================================

![Tests](https://github.com/nojhan/liquidprompt/workflows/tests/badge.svg)
[![Documentation Status](https://readthedocs.org/projects/liquidprompt/badge/?version=stable)](https://liquidprompt.readthedocs.io/)

Liquid Prompt gives you a nicely displayed prompt with useful information
when you need it. It shows you what you need when you need it.
You will notice what changes *when* it changes, saving time and frustration.
You can even use it with your favorite shell – Bash or zsh.

![Screenshot of the default theme](https://raw.github.com/nojhan/liquidprompt/master/docs/demo.png)

On top of the classical information of a classical prompt,
Liquid Prompt displays the state of many of the tools that you like to operate
from the command line, for example:
* numerous information from various version control systems (Git, Mercurial, Fossil, etc.), when you are in a code repository;
* whether you're remotely connected by SSH, in a terminal multiplexer (screen or tmux), with graphical support;
* permissions on the current directory, whether you have sudo rights or not;
* information about virtual environments, web proxy;
* information about jobs attached to the current terminal;
* alerts about the battery or the load;
* etc., etc., etc.

Liquid Prompt has been carrefuly designed to highlight the *relevant*
information, at *the right time*.
It does not clutter your prompt with useless eye candy and helps you detect
important alerts right away.
Moreover, Liquid Prompt is highly configurable: you can disable useless features
and change any alert thresholds to suit your needs.
On top of this, it comes with several themes, from the discrete default to the
most colorful and fancy one, àla powerline.

![Screenshot of the Dotmatrix
theme](https://raw.github.com/nojhan/liquidprompt/master/docs/demo_dotmatrix.png)


## Documentation

See the [Liquidprompt documentation](https://liquidprompt.readthedocs.io/) for
details on installing and configuring Liquidprompt.


## License

Liquid Prompt is distributed under the [GNU Affero General Public License
version 3](LICENSE).

To comply with the AGPL clauses, anybody offering Liquid Prompt over the network
is required to also offer access to the source code of it and allow further use
and modifications. As Liquid Prompt is implemented purely in shell script,
anybody using it over SSH or equivalent terminal connection automatically also
has access to the source code, so it is easy to comply with the license.


## Known Limitations and Bugs

* Does not display the number of commits to be pushed in Mercurial repositories.
* Browsing very large Subversion repositories may dramatically slow down
  the display of Liquid Prompt (use `LP_DISABLED_VCS_PATHS` to avoid that).
* Subversion repositories cannot display commits to be pushed because
  that's not how Subversion works
* The window's title escape sequence may not work properly on some terminals
  (like `xterm-256`).
* The analog clock requires a Unicode-aware terminal and at least a
  sufficiently complete font on your system. The [Symbola](https://dn-works.com/ufas/)
  font, designed by Georges Douros, is known to work well. On Debian or Ubuntu
  install try the `fonts-symbola` or `ttf-ancient-fonts` package.
* The "sudo" feature is disabled by default as there is no way to detect
  if the user has sudo rights without triggering a security alert
  that will annoy the sysadmin.


## Authors

Current Maintainer: [Rycieos](https://github.com/Rycieos)

And many [contributors](CONTRIBUTORS.md)!
