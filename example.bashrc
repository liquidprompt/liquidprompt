
# if you want to use the liquidprompt without bothering about its configuration,
# just:
# cp example.bashrc ~/.bashrc

# This part is a minimalist bash config file example

# Use the system config if any
if [ -f /etc/bashrc ]; then
        . /etc/bashrc   # --> Read /etc/bashrc, if present.
fi

# Use bash completion, if installed
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# If you have your own config for the liquid prompt, edit and uncomment this line:
# source /path/to/liquidpromptrc

# Use the liquidprompt
source ~/.liquidprompt

