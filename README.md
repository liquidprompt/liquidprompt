Liquid prompt -- A useful adaptive prompt for Bash & Zsh
========================================================

Liquid prompt gives you a nicely displayed prompt with useful information
when you need it. It shows you what you need when you need it.
You will notice what changes, when it changes saving time and frustration.
And you can even use it with your favorite shell, Bash or Zsh.

![Screenshot](https://raw.github.com/nojhan/liquidprompt/master/demo.png)

## FEATURES

If there is nothing special in the current context, the liquid prompt is close
to a default prompt:

`[user:~] $ `

If you are running a command in the background that is still running and you are
in a git repository on a server, on branch "myb":

`1r [user@server:~/liquidprompt] myb ± `

A liquid prompt displaying everything (a rare event!) may look like this:

`code 🕤  ⌁24% ⌂42% 3d/2&/1z [user@server:~/ … /code/liquidprompt][pyenv]↥ master(+10/-5,3)*+ 125 ± `

It (may) displays:

* A tag associated to the current shell session (you can easily add any
prefix tag to your prompt, by invoking `prompt_tag MYTAG`).
* The current time, either as numeric values or an analog clock,
* a green ⏚ if the battery is charging, above the given threshold, but not charged,
a yellow ⏚ if the battery is charging and under threshold,
a yellow ⌁ if the battery is discharging but above threshold,
a  red ⌁ if the battery is discharging and under threshold;
* the average of the batteries remaining power, if it is under the given
threshold, with a colormap, going more and more red with decreasing power;
* the average of the processors load, if it is over a given limit, with a
colormap that becomes more and more noticeable with increasing load;
* the average temperature of the available sensors in the system (generally CPU
and MB);
* the number of detached sessions (`screen` or `tmux`), if there are any;
* the number of attached sleeping jobs (when you interrupt a command with Ctrl-Z
and bring it back with `fg`), if there are any;
* the number of attached running jobs (commands started with a `&`), if there are
any;
* a pair of square brackets, in blue if your current shell is running in a
terminal multiplexer (`screen` or `tmux`);
* the current user, in bold yellow if it is root, in light white if it is not
the same as the login user;
* a green @ if the connection has X11 support, a yellow one if not;
* the current host, if you are connected via a telnet connection (in bold red)
or SSH (either a blue hostname or different colors for different hosts);
* a green colon if the user has write permissions on the current directory,
a red one if he has not;
* the current directory in bold, shortened if it takes too much space, while
preserving the first two directories;
* the current Python virtual environment, if any;
* an up arrow if an HTTP proxy is in use;
* the name of the current branch if you are in a version control repository
(git, mercurial, subversion, bazaar or fossil), in green if everything is up
to date, in red if there are changes, in yellow if there are pending
commits to push;
* the number of added/deleted lines (git) or files (fossil), if
changes have been made and the number of pending commits, if any;
* a yellow plus if there is stashed modifications;
* a red star if there is some untracked files in the repository;
* the error code of the last command, if it has failed in some way;
* a smart mark: ± for git directories, ☿ for mercurial, ‡ for svn,
‡± for git-svn, ⌘ for fossil, $ or % for simple user, a red # for root;
* if you ask for, the liquidprompt will be replicated in your terminal window's
title (without the colors);

You can temporarily deactivate the liquid prompt and come back to your previous
one by typing `prompt_off`. Use `prompt_on` to bring it back. You can deactivate
any prompt and use a single mark sign (`$ ` for user and `# ` for root) with the
`prompt_OFF` command.


## TEST RIDE AND INSTALLATION

Installation is simple. The basic dependencies are standard available on Unix.
Please check if they are met if you experience some problems during the installation.
See the DEPENDENCIES section for what you need.

Follow these steps:

`cd ~/`
`git clone https://github.com/nojhan/liquidprompt.git`
`source liquidprompt/liquidprompt`

To use it everytime you start a shell add the following line to your
`.bashrc` (if you use bash) or `.zshrc` (if you use zsh):

`source ~/liquidprompt/liquidprompt`

Next up is the configuration, you can skip this step if you already like the defaults:

`cp ~/liquidpromp/liquidpromptrc-dist ~/.config/liquidpromptrc`

You can also copy the file to `~/.liquidpromptrc`.
Use your favorite text editor to change the defaults.
The `liquidpromptrc` file is richly commented and easy to set your own defaults.
You can even theme liquidprompt and have a custom PS1. This is explained
in the sections below.

Please do not edit or set the `PROMPT_COMMAND` variable, or else the
prompt will not be available.


## DEPENDENCIES

Apart from obvious ones, some features depends on specific commands. If you do
not install them, the corresponding feature will not be available, but you will
see no error.

* battery status needs `acpi`.
* temperature status needs `lm-sensors`.
* detached sessions is looking for `screen` and/or `tmux`.
* VCS support features needs… `git`, `hg`, `svn` or `fossil`, but you knew it.

For other features, the script uses commands that should be available on a large
variety of unixes: `tput`, `grep`, `awk`, `sed`, `ps`, `who`.


## FEATURES CONFIGURATION

You can configure some variables in the `~/.liquidpromptrc` file:

* `LP_BATTERY_THRESHOLD`, the maximal value under which the battery level is
displayed
* `LP_LOAD_THRESHOLD`, the minimal value after which the load average is
* `LP_TEMP_THRESHOLD`, the minimal value after which the temperature average is
displayed
* `LP_PATH_LENGTH`, the maximum percentage of the screen width used to display
the path
* `LP_PATH_KEEP`, how many directories to keep at the beginning of a shortened
path
* `LP_HOSTNAME_ALWAYS`, choose between always displaying the hostname or showing
it only when connected with a remote shell
* `LP_USER_ALWAYS`, choose between always displaying the user or showing
it only when he is different from the logged one

You can also force some features to be disabled, to save some time in the prompt
building:
* `LP_ENABLE_PERM`, if you want to detect if the directory is writable
* `LP_ENABLE_SHORTEN_PATH`, if you want to shorten the path display
* `LP_ENABLE_PROXY`, if you want to detect if a proxy is used
* `LP_ENABLE_JOBS`, if you want to have jobs informations
* `LP_ENABLE_LOAD`, if you want to have load informations
* `LP_ENABLE_BATT`, if you want to have battery informations
* `LP_ENABLE_GIT`, if you want to have git informations
* `LP_ENABLE_SVN`, if you want to have subversion informations
* `LP_ENABLE_HG`, if you want to have mercurial informations
* `LP_ENABLE_BZR`, if you want to have bazaar informations
* `LP_ENABLE_FOSSIL`, if you want to have fossil informations
* `LP_ENABLE_VCS_ROOT`, if you want to show VCS informations with root account
* `LP_ENABLE_TITLE`, if you want to use the prompt as your terminal window's title
* `LP_ENABLE_SCREEN_TITLE`, if you want to use the prompt as your screen window's title
* `LP_ENABLE_SSH_COLORS`, if you want different colors for hosts you SSH in
* `LP_ENABLE_TIME`, if you want to display the time at which the prompt was shown
* `LP_TIME_ANALOG`, when showing time, use an analog clock instead of numeric values

Note that if required commands are not installed, enabling the
corresponding feature will have no effect.
Note also that all the `LP_ENABLE_…` variables override the templates,
i.e. if you use `$LP_BATT` in your template and you set `LP_ENABLE_BATT=0`
in your config file, you will not have the battery informations.

If you are using bash and want to use the `PROMPT_DIRTRIM` built-in
functionality to shorten but still have liquidprompt calculating the number of
directories to keep in the path, precise a value for `PROMPT_DIRTRIM` before
sourcing liquidprompt and liquidprompt will override this value with one
fitting the width of your terminal.

You may face performances decrease when using VCS located in remote directories.
To avoid that, you can set the `LP_DISABLED_VCS_PATH` variable to a list of
absolute and colon (":") separated paths where VCS-related features will be
disabled.


## CUSTOMIZING THE PROMPT

### ADD A PREFIX/POSTFIX

You can prefix the `LP_PS1` variable with anything you want using the
`LP_PS1_PREFIX`. The following example activate a custom window's title:

    LP_PS1_PREFIX="\[\e]0;\u@\h: \w\a\]"

To postfix the prompt, use the `LP_PS1_POSTFIX` variable. For example, to add a
newline and a single character:

    LP_PS1_POSTFIX="\n>"

Note: the `prompt_tag` function is  convenient way to add a prefix. You can thus add
a keyword to your different terminals:

    [:~/code/liquidprompt] develop ± prompt_tag mycode
    mycode [:~/code/liquidprompt] develop ±


### PUT THE PROMPT IN A DIFFERENT ORDER

You can sort what you want to see by sourcing your favorite template file
(`*.ps1`) in the configuration file.

You can start from the `liquid.ps1` file, which show the default settings.
To use your own configuration, just set `LP_PS1_FILE` to your own file path in
your `~/.liquipromptrc` and you're done.

Those scripts basically export the `LP_PS1` variable, by appending features and
theme colors.

Available features:
* `LP_BATT` battery
* `LP_LOAD` load
* `LP_TEMP` temperature
* `LP_JOBS` detached screen or tmux sessions/running jobs/suspended jobs
* `LP_USER` user
* `LP_HOST` hostname
* `LP_PERM` a colon ":"
* `LP_PWD` current working directory
* `LP_PROXY` HTTP proxy
* `LP_VCS` informations concerning the current working repository
* `LP_ERR` last error code
* `LP_MARK` prompt mark
* `LP_TITLE` the prompt as a window's title escaped sequences
* `LP_BRACKET_OPEN` and `LP_BRACKET_CLOSE`, brackets enclosing the user+path part

For example, if you just want to have a liquidprompt displaying the user and the
host, with a normal full path in blue and only the git support:

    export LP_PS1=`echo -ne "[\${LP_USER}\${LP_HOST}:\${BLUE}\$(pwd)\${NO_COL}] \${LP_GIT} \\\$ "`

Note that you need to properly escape dollars in a string that wil be
interpreted by bash at each prompt.

To erase your new formatting, just bring the `LP_PS1` to a null string:

     export LP_PS1=""



## THEMES

You can change the colors and special characters of some part of the liquid
prompt by sourcing your favorite theme file (`*.theme`) in the configuration file.

### COLORS

Available colors are:
BOLD, BLACK, BOLD_GRAY, WHITE, BOLD_WHITE,
GREEN, BOLD_GREEN, YELLOW, BOLD_YELLOW, BLUE, BOLD_BLUE, PINK, CYAN, BOLD_CYAN
RED, BOLD_RED, WARN_RED, CRIT_RED, DANGER_RED,
NO_COL.
Set to a null string "" if you do not want color.

* Current working directory
    * `LP_COLOR_PATH` as normal user
    * `LP_COLOR_PATH_ROOT` as root
* Color of the proxy mark
    * `LP_COLOR_PROXY`
* Jobs count
    * `LP_COLOR_JOB_D` Detached (screen/tmux sessions without attached clients)
    * `LP_COLOR_JOB_R` Running (xterm &)
    * `LP_COLOR_JOB_Z` Sleeping (Ctrl-Z)
    * `LP_COLOR_IN_MULTIPLEXER` currently running in a terminal multiplexer
* Last error code
    * `LP_COLOR_ERR`
* Prompt mark
    * `LP_COLOR_MARK` as user
    * `LP_COLOR_MARK_ROOT` as root
* Current user
    * `LP_COLOR_USER_LOGGED` user who logged in
    * `LP_COLOR_USER_ALT` user but not the one who logged in
    * `LP_COLOR_USER_ROOT` root
* Hostname
    * `LP_COLOR_HOST` local host
    * `LP_COLOR_SSH` connected via SSH
    * `LP_COLOR_TELNET` connected via telnet
    * `LP_COLOR_X11_ON` connected with X11 support
    * `LP_COLOR_X11_OFF` connected without X11 support
* Separation mark (by default, the colon before the path)
    * `LP_COLOR_WRITE` have write permission
    * `LP_COLOR_NOWRITE` do not have write permission
* VCS
    * `LP_COLOR_UP` repository is up to date / a push have been made
    * `LP_COLOR_COMMITS` some commits have not been pushed
    * `LP_COLOR_CHANGES` there is some changes to commit
    * `LP_COLOR_DIFF` number of lines or files impacted by current changes
* Battery
    * `LP_COLOR_CHARGING_ABOVE` charging and above threshold
    * `LP_COLOR_CHARGING_UNDER` charging but under threshold
    * `LP_COLOR_DISCHARGING_ABOVE` discharging but above threshold
    * `LP_COLOR_DISCHARGING_UNDER` discharging and under threshold


### CHARACTERS

Special characters:
* `LP_MARK_DEFAULT` (default: "") the mark you want at the end of your prompt (leave to empty for your shell default mark)
* `LP_MARK_BATTERY` (default: "⌁") in front of the battery charge
* `LP_MARK_ADAPTER` (default: "⏚") displayed when plugged
* `LP_MARK_LOAD` (default: "⌂") in front of the load
* `LP_MARK_PROXY` (default: "↥") indicate a proxy in use
* `LP_MARK_HG` (default: "☿") prompt mark in hg repositories
* `LP_MARK_SVN` (default: "‡") prompt mark in svn repositories
* `LP_MARK_GIT` (default: "±") prompt mark in git repositories
* `LP_MARK_FOSSIL` (default: "⌘") prompt mark in fossil repositories
* `LP_MARK_BZR` (default: "⚯") prompt mark in bazaar repositories
* `LP_MARK_DISABLED` (default: "⌀") prompt mark in disabled repositories (see `LP_DISABLED_VCS_PATH`)
* `LP_MARK_UNTRACKED` (default: "*") if git has untracked files
* `LP_MARK_STASH` (default: "+") if git has stashed modifications
* `LP_MARK_BRACKET_OPEN` (default: "[") marks around the main part of the prompt
* `LP_MARK_BRACKET_CLOSE` (default: "]") marks around the main part of the prompt
* `LP_TITLE_OPEN` (default: "\e]0;") escape character opening a window's title
* `LP_TITLE_CLOSE` (default: "\a") escape character closing a window's title
* `LP_SCREEN_TITLE_OPEN` (default: "\033k") escape character opening screen window's title
* `LP_SCREEN_TITLE_CLOSE` (default: "\033\134") escape character closing screen window's title


## KNOWN LIMITATIONS AND BUGS

Liquid prompt is distributed under the GNU Affero General Public License
version 3.

* Does not display the number of commits to be pushed in Mercurial repositories.
* Browsing into very large subversion repositories may dramatically slow down
the display of the liquid prompt (use `LP_DISABLED_VCS_PATH` to avoid that).
* Subversion repository cannot display commits to be pushed, this is a
limitation of the Subversion versionning model.
* The proxy detection only uses the `$http_proxy` environment variable.
* The window's title escape sequence may not work properly on some terminals
(like xterm-256)
* The analog clock necessitate a unicode-aware terminal and a sufficiently
complete font.

