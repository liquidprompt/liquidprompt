Liquid Prompt — a useful adaptive prompt for Bash & zsh
=======================================================

Liquid Prompt gives you a nicely displayed prompt with useful information
when you need it. It shows you what you need when you need it.
You will notice what changes *when* it changes, saving time and frustration.
You can even use it with your favorite shell – Bash or zsh.

![Screenshot](https://raw.github.com/nojhan/liquidprompt/master/demo.png)


## Features

If there is nothing special about the current context, the appearance of Liquid
Prompt is similar to that of a default prompt:

`[user:~] $ `

If you are running a background command and are also in the "myb" branch
of a Git repository on a server:

`1r [user@server:~/liquidprompt] myb ± `

When Liquid Prompt is displaying everything (a rare event!), it may look like this:

`code 🕤  ⌁24% ⌂42% 3d/2&/1z [user@server:~/ … /code/liquidprompt][pyenv]↥ master(+10/-5,3)*+ 125 ± `

Here is an overview of what Liquid Prompt is capable of displaying:

* a tag associated to the current shell session (you can easily add any
  prefix tag to your prompt by invoking `prompt_tag MYTAG`)
* the current time, displayed as either numeric values or as an analog clock
* the current battery status:
  * a green `⏚` if charging, above the given threshold, but not charged
  * a yellow `⏚` if charging and under the given threshold
  * a yellow `⌁` if discharging but above the given threshold
  * a red `⌁` if discharging and under the given threshold
* the remaining battery power if it is under the given threshold, displayed with
  an increasingly red color map as remaining power decreases
* the average of the processors load if it is over a given limit, displayed with
  an intensity color map as load increases
* the average temperature of the available system sensors (generally CPU and MB)
* the number of detached sessions (`screen` or `tmux`)
* the number of attached sleeping jobs (when you interrupt a command with Ctrl-Z
  and bring it back with `fg`)
* the number of attached running jobs (commands started with a `&`)
* a pair of square brackets, in blue if your current shell is running in a
  terminal multiplexer (`screen` or `tmux`)
* the current user, in bold yellow if it is root and in light white if it is not
  the same as the login user
* a green `@` if the connection has X11 support; a yellow one if not
* the current host – in bold red if you are connected via a `telnet` connection
  and blue (or other unique colors) if connected via SSH
* a green colon if the user has write permissions in the current directory and
  a red one if not
* the current directory in bold, shortened if it takes too much space while always
  preserving the first two directory names
* the current Python virtual environment
* an up arrow if an HTTP proxy is in use
* the name of the current branch if you are in a version control repository
  (Git, Mercurial, Subversion, Bazaar, or Fossil):
  * in green if everything is up-to-date
  * in red if there are changes
  * in yellow if there are pending commits to push
* the number of added/deleted lines if changes have been made and the
  number of pending commits
* a yellow `+` if there are stashed modifications
* a red `*` if there are untracked files in the repository
* the runtime of the last command, if it has exceeded a certain threshold
* the error code of the last command, if it has failed in some way
* a smart mark at the end of the prompt:
  * `±` for Git,
  * `☿` for Mercurial,
  * `‡` for Subversion,
  * `‡±` for Git-Subversion,
  * `⌘` for Fossil,
  * `$` or `%` for a simple user, in red if you have `sudo` rights,
  * a red `#` for the root user.
* if desired, the prompt will be replicated in your terminal window's
  title (without the colors)

You can temporarily deactivate Liquid Prompt and revert to your previous prompt
by typing `prompt_off`. Use `prompt_on` to bring it back. You can disable
*all* prompts and simply use a single mark sign (`$ ` for user and `# ` for root)
by using the `prompt_OFF` command.


## Test Drive and Installation

Installation is simple. The basic dependencies are standard Unix utilities/commands.
If you experience some problems during the installation, please check that they
are met; see the [dependencies](#dependencies) section for what you need specifically.

Follow these steps:

    cd
    git clone https://github.com/nojhan/liquidprompt.git
    source liquidprompt/liquidprompt

To use it every time you start a shell, add the following lines to your
`.bashrc` (if you use Bash) or `.zshrc` (if you use zsh):

    # Only load Liquid Prompt in interactive shells, not from a script or from scp
    [[ $- = *i* ]] && source ~/liquidprompt/liquidprompt

Next up is the configuration; you can skip this step if you like the defaults:

    cp ~/liquidprompt/liquidpromptrc-dist ~/.config/liquidpromptrc

You can also copy the file to `~/.liquidpromptrc`.
Use your favorite text editor to change the defaults.
The `liquidpromptrc` file is richly commented and easy to set your own defaults.
You can even theme Liquid Prompt and use a custom PS1 prompt. This is explained
in the sections below.

Check in your `.bashrc` that the `PROMPT_COMMAND` variable is not set, or else
the prompt will not be available.

### Installation via Antigen

To install via antigen, simply add the following line in your `.zshrc` after activating antigen:

    antigen bundle nojhan/liquidprompt


## Dependencies

Apart from obvious ones, some features depend on specific commands. If you do
not install them, the corresponding feature will not be available, but no error
will be displayed.

* Battery status requires `acpi` on GNU/Linux.
* Temperature status requires `acpi` or `lm-sensors` on GNU/Linux.
* Detached session status looks for `screen` and/or `tmux`.
* VCS support features require `git`, `hg`, `svn`, `bzr` or `fossil`, but you
  probably already knew that.

For other features, the script uses commands that should be available on a large
variety of Unix systems: `tput`, `grep`, `awk`, `sed`, `ps`, `who`, and `expr`.


## Feature Configuration

You can configure some variables in the `~/.config/liquidpromptrc` file:

* `LP_BATTERY_THRESHOLD`, the maximal value under which the battery level is displayed
* `LP_LOAD_THRESHOLD`, the minimal value after which the load average is displayed
* `LP_TEMP_THRESHOLD`, the minimal value after which the average temperature is displayed
* `LP_RUNTIME_THRESHOLD`, the minimal value after which the runtime is displayed
* `LP_PATH_LENGTH`, the maximum percentage of the screen width used to display the path
* `LP_PATH_KEEP`, how many directories to keep at the beginning of a shortened path
* `LP_HOSTNAME_ALWAYS`, a choice between always displaying the hostname or
  showing it only when connected via a remote shell
* `LP_USER_ALWAYS`, a choice between always displaying the user or showing
  it only when he is different from the one that logged in

You can also force some features to be disabled, to save some time in the
prompt-building process:

* `LP_ENABLE_PERM`, if you want to detect if the directory is writeable
* `LP_ENABLE_SHORTEN_PATH`, if you want to shorten the path display
* `LP_ENABLE_PROXY`, if you want to detect if a proxy is used
* `LP_ENABLE_JOBS`, if you want to have jobs information
* `LP_ENABLE_LOAD`, if you want to have load information
* `LP_ENABLE_BATT`, if you want to have battery information
* `LP_ENABLE_GIT`, if you want to have Git information
* `LP_ENABLE_SVN`, if you want to have Subversion information
* `LP_ENABLE_HG`, if you want to have Mercurial information
* `LP_ENABLE_BZR`, if you want to have Bazaar information
* `LP_ENABLE_FOSSIL`, if you want to have Fossil information
* `LP_ENABLE_VCS_ROOT`, if you want to show VCS informations with root account
* `LP_ENABLE_TITLE`, if you want to use the prompt as your terminal window's title
* `LP_ENABLE_SCREEN_TITLE`, if you want to use the prompt as your screen window's title
* `LP_ENABLE_SSH_COLORS`, if you want different colors for hosts you SSH into
* `LP_ENABLE_RUNTIME`, if you want to display the runtime of the last command
* `LP_ENABLE_SUDO`, if you want the prompt mark to change color while you have password-less root access
* `LP_ENABLE_FQDN`, if you want the display of the fully qualified domain name
* `LP_ENABLE_TIME`, if you want to display the time at which the prompt was shown
* `LP_TIME_ANALOG`, if you want to show the time using an analog clock instead of numeric values

Note that if required commands are not installed, enabling the corresponding
feature will have no effect. Also, all the `LP_ENABLE_…` variables override the
templates; i.e. if you use `$LP_BATT` in your template and you set `LP_ENABLE_BATT=0`
in your configuration file, your prompt will not have any battery information.

If you are using Bash and want to use the `PROMPT_DIRTRIM` built-in
functionality to shorten but still want to have Liquid Prompt calculating the
number of directories to keep in the path, precise a value for `PROMPT_DIRTRIM`
before sourcing Liquid Prompt and it will override this value with one fitting
the width of your terminal.

You may face performances decrease when using VCS located in remote directories.
To avoid this, you can set the `LP_DISABLED_VCS_PATH` variable to a list of
absolute colon-separated paths where VCS-related features should be disabled.


## Customizing the Prompt

### Adding a Prefix/Postfix

You can prefix the `LP_PS1` variable with anything you want using
`LP_PS1_PREFIX`. The following example activate a custom window's title:

    LP_PS1_PREFIX="\[\e]0;\u@\h: \w\a\]"

To postfix the prompt, use the `LP_PS1_POSTFIX` variable. For example, to add a
newline and a single character:

    LP_PS1_POSTFIX="\n>"

Note: the `prompt_tag` function is a convenient way to add a prefix. You can use
it to add a keyword to each of your different terminals:

    [:~/code/liquidprompt] develop ± prompt_tag mycode
    mycode [:~/code/liquidprompt] develop ±


### Rearranging the Prompt

You can sort what you want to see by sourcing your favorite template file
(`*.ps1`) in the configuration file.

You can start from the `liquid.ps1` file, which show the default settings.
To use your own configuration, just set `LP_PS1_FILE` to your own file path in
your `~/.liquidpromptrc` and you're done.

Those scripts basically export the `LP_PS1` variable, by appending features and
theme colors.

Available features:
* `LP_BATT` battery
* `LP_LOAD` load
* `LP_TEMP` temperature
* `LP_JOBS` detached `screen` or `tmux` sessions/running jobs/suspended jobs
* `LP_USER` user
* `LP_HOST` hostname
* `LP_PERM` a colon (`:`)
* `LP_PWD` current working directory
* `LP_PROXY` HTTP proxy
* `LP_VCS` informations concerning the current working repository
* `LP_ERR` last error code
* `LP_MARK` prompt mark
* `LP_TITLE` the prompt as a window's title escaped sequences
*  LP_TTYN  the terminal basename
* `LP_BRACKET_OPEN` and `LP_BRACKET_CLOSE`, brackets enclosing the user+path part

For example, if you just want to have a prompt displaying the user and the
host, with a normal full path in blue and Git support only:

    export LP_PS1=`echo -ne "[\${LP_USER}\${LP_HOST}:\${BLUE}\$(pwd)\${NO_COL}] \${LP_GIT} \\\$ "`

Note that you need to properly escape dollar signs in a string that will be
interpreted by Bash at each prompt.

To erase your new formatting, just bind `LP_PS1` to a null string:

    export LP_PS1=""


## Themes

You can change the colors and special characters of some parts of Liquid Prompt
by sourcing your favorite theme file (`*.theme`) in the configuration file. See
[`liquid.theme`](liquid.theme) for an example of the default Liquid Prompt theme.

### Colors

The available colours available for use are:

`BOLD`, `BLACK`, `BOLD_GRAY`, `WHITE`, `BOLD_WHITE`, `GREEN`, `BOLD_GREEN`,
`YELLOW`, `BOLD_YELLOW`, `BLUE`, `BOLD_BLUE`, `PINK`, `CYAN`, `BOLD_CYAN,`,
`RED`, `BOLD_RED`, `WARN_RED`, `CRIT_RED`, `DANGER_RED`, and `NO_COL`.

Set the variable to a null string (`""`) if you do not want color.

* Current working directory
    * `LP_COLOR_PATH` as normal user
    * `LP_COLOR_PATH_ROOT` as root
* Color of the proxy mark
    * `LP_COLOR_PROXY`
* Jobs count
    * `LP_COLOR_JOB_D` Detached (`screen` / `tmux` sessions without attached clients)
    * `LP_COLOR_JOB_R` Running (`xterm &`)
    * `LP_COLOR_JOB_Z` Sleeping (Ctrl-Z)
    * `LP_COLOR_IN_MULTIPLEXER` currently running in a terminal multiplexer
* Last error code
    * `LP_COLOR_ERR`
* Prompt mark
    * `LP_COLOR_MARK` as user
    * `LP_COLOR_MARK_ROOT` as root
    * `LP_COLOR_MARK_SUDO` when you did `sudo` and your credentials are still cached (use `sudo -K` to revoke them)
    * `LP_MARK_PREFIX="\n"` put the prompt on the second line
* Current user
    * `LP_COLOR_USER_LOGGED` user who logged in
    * `LP_COLOR_USER_ALT` user but not the one who logged in
    * `LP_COLOR_USER_ROOT` root
* Hostname
    * `LP_COLOR_HOST` local host
    * `LP_COLOR_SSH` connected via SSH
    * `LP_COLOR_TELNET` connected via `telnet`
    * `LP_COLOR_X11_ON` connected with X11 support
    * `LP_COLOR_X11_OFF` connected without X11 support
* Separation mark (by default, the colon before the path)
    * `LP_COLOR_WRITE` have write permission
    * `LP_COLOR_NOWRITE` do not have write permission
* VCS
    * `LP_COLOR_UP` repository is up-to-date / a push has been made
    * `LP_COLOR_COMMITS` some commits have not been pushed
    * `LP_COLOR_CHANGES` there are some changes to commit
    * `LP_COLOR_DIFF` number of lines or files impacted by current changes
* Battery
    * `LP_COLOR_CHARGING_ABOVE` charging and above threshold
    * `LP_COLOR_CHARGING_UNDER` charging but under threshold
    * `LP_COLOR_DISCHARGING_ABOVE` discharging but above threshold
    * `LP_COLOR_DISCHARGING_UNDER` discharging and under threshold


### Special Characters

* `LP_MARK_DEFAULT` (default: "") the mark you want at the end of your prompt
  (leave empty to use your shell's default mark)
* `LP_MARK_BATTERY` (default: "⌁") in front of the battery charge
* `LP_MARK_ADAPTER` (default: "⏚") displayed when plugged-in
* `LP_MARK_LOAD` (default: "⌂") in front of the load
* `LP_MARK_PROXY` (default: "↥") indicate a proxy in use
* `LP_MARK_HG` (default: "☿") prompt mark in Mercurial repositories
* `LP_MARK_SVN` (default: "‡") prompt mark in Subversion repositories
* `LP_MARK_GIT` (default: "±") prompt mark in Git repositories
* `LP_MARK_FOSSIL` (default: "⌘") prompt mark in Fossil repositories
* `LP_MARK_BZR` (default: "⚯") prompt mark in Bazaar repositories
* `LP_MARK_DISABLED` (default: "⌀") prompt mark in disabled repositories
  (see `LP_DISABLED_VCS_PATH`)
* `LP_MARK_UNTRACKED` (default: "\*") if Git has untracked files
* `LP_MARK_STASH` (default: "+") if Git has stashed modifications
* `LP_MARK_BRACKET_OPEN` (default: "[") marks around the main part of the prompt
* `LP_MARK_BRACKET_CLOSE` (default: "]") marks around the main part of the prompt
* `LP_MARK_PERM` (default: ":") colored green red or green to indicate write
  permissions of the current directory
* `LP_TITLE_OPEN` (default: "\e]0;") escape character opening a window's title
* `LP_TITLE_CLOSE` (default: "\a") escape character closing a window's title


## Known Limitations and Bugs

Liquid Prompt is distributed under the [GNU Affero General Public License
version 3](LICENSE).

* Does not display the number of commits to be pushed in Mercurial repositories.
* Browsing very large Subversion repositories may dramatically slow down
  the display of Liquid Prompt (use `LP_DISABLED_VCS_PATH` to avoid that).
* Subversion repositories cannot display commits to be pushed because
  that's not how Subversion works
* The proxy detection only uses the `$http_proxy` environment variable.
* The window's title escape sequence may not work properly on some terminals
  (like `xterm-256`).
* The analog clock requires a Unicode-aware terminal and at least a
  sufficiently complete font on your system. The [Symbola](http://users.teilar.gr/~g1951d/)
  font, designed by Georges Douros, is known to work well. On Debian or Ubuntu
  install try the `fonts-symbola` or `ttf-ancient-fonts` package.


## Authors

Current Maintainer: [![endorse](https://api.coderwall.com/dolmen/endorsecount.png)](https://coderwall.com/dolmen)

Original Author: [![endorse](https://api.coderwall.com/nojhan/endorsecount.png)](https://coderwall.com/nojhan)

And many contributors!
