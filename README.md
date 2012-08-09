Liquid prompt -- A useful adaptive Bash prompt
==============================================

Liquid prompt is a smart prompt for the "Bourne-Again" Unix shell (bash).

The basic idea of the liquid prompt is to nicely display useful informations on
the shell prompt, only when they are needed. It adds carefuly chosen colors to
draw your attention on what differs from the normal context. Thus, you will
notice what changes, when it changes, because you do not become accommodated to
informations that are always displayed in the same way.


## FEATURES

If there is nothing special in the current context, the liquid prompt is close
to a default prompt:

`[user:~] $ `

If you have ran one command in background that is still running and that you are
in a git repository on a server, at branch "myb":

`1r [user@server:~/liquidprompt] myb ± `

A liquid prompt displaying everything may look like this:

`⌁24% ⌂42% 1s/1r/1t [user@server:~/ … /code/liquidprompt]↥ g·master(+10/-5,3) 125 ± `

It displays:

* the average of the batteries remaining power, if it is under a given
threshold, with a colormap too;
* the average of the processors load, if it is over a given limit, with a
colormap that became more and more noticeable with increasing load;
* the number of detached `screen` sessions, if there is any;
* the number of attached sleeping jobs (when you interrupt a command with Ctrl-Z
and bring it back with `fg`), if there is any;
* the number of attached running jobs (commands started with a `&`), if there is
any;
* the current user, in bold yellow if it is root, in light white if it is not
the same as the login user;
* the current host, if you are connected via an SSH or telnet connection, with
different colors for each case;
* a green colon if the user has write permissions on the current directory, 
a red one if he has not;
* the current directory in bold, shortened if it takes too much space, while
preserving the first two directories;
* an up arrow if an HTTP proxy is in use;
* the name of the current branch if you are in a version control repository
(git, mercurial or subversion), in green if everything is up to date, in red if
there is changes, in yellow if there is pending commits to push;
* the number of added/deleted lines, if changes have been made and the number
of pending commits, if any;
* the error code of the last command, if it has failed in some way;
* a smart mark: ± for VCS directories, $ for simple user, a red # for root.

You can temporarily deactivate the liquid prompt and come back to your previous
one by typing `prompt_off`. Use `prompt_on` to bring it back.


## INSTALL

Include the file in your bash configuration, for example in your `.bashrc`:

`source liquidprompt.bash`

Copy the `liquidpromptrc-dist` file in your home directory as
`~/.config/liquidpromptrc` or `~/.liquidpromptrc` and edit it according to your
preferences. If you skip this step, the default behaviour will be used.


## PUT THE PROMPT IN A DIFFERENT ORDER

You can configure some variables in the `~/.liquidpromptrc` file:

* `LP_BATTERY_THRESHOLD`, the maximal value under which the battery level is
displayed
* `LP_LOAD_THRESHOLD`, the minimal value after which the load average is
displayed
* `LP_PATH_LENGTH`, the maximum percentage of the screen width used to display
the path
* `LP_PATH_KEEP`, how many directories to keep at the beginning of a shortened
path
* `LP_REVERSE`, choose between reverse colors (black on white) or normal theme
(white on black)
* `LP_HOSTNAME_ALWAYS`, choose between always displaying the hostname or showing
it only when connected with a remote shell

Most of the display is prepared in the `__set_bash_prompt` function, apart from
features that needs several colors (such as the load colormap). You can sort
what you want to see by editing the PS1 variable here.


## KNOWN LIMITATIONS AND BUGS

* Does not display the number of commits to be pushed in Mercurial repositories.
* Subversion repository cannot display commits to be pushed, this is a
limitation of the Subversion versionning model.
* The proxy detection only uses the `$http_proxy` environment variable.

