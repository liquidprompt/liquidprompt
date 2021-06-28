Liquid Prompt — a useful adaptive prompt for Bash & zsh
=======================================================

![Tests](https://github.com/nojhan/liquidprompt/workflows/tests/badge.svg)
[![Documentation Status](https://readthedocs.org/projects/liquidprompt/badge/?version=stable)](https://liquidprompt.readthedocs.io/)

Liquid Prompt gives you a nicely displayed prompt with useful information
when you need it. It shows you what you need when you need it.
You will notice what changes *when* it changes, saving time and frustration.
You can even use it with your favorite shell – Bash or zsh.

![Screenshot](https://raw.github.com/nojhan/liquidprompt/master/demo.png)


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
