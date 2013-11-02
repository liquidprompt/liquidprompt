function fish_prompt --description 'Write out the prompt'

    # Get the last command's return code. This must be done first.
    set -g last_status "$status"

    ## Configure liquidprompt.
    # This should not be done more than once per instance of fish.
    if functions -q _lp_config
        _lp_config
        # Prevent the user from running this function again.
        functions -e _lp_config
    end

    ## Initialize liquidprompt.
    # (Compute things that will not change during this instance of fish.)
    # This should not be done more than once per instance of fish.
    if functions -q _lp_init
        _lp_init
        # Prevent the user from running this function again.
        functions -e _lp_config
    end

    ## Feature check.
    # Run some checks and disable any option that should not be enabled.
    # This can be done several times during the lifetime of an instance of fish.
    if not set -q _LP_CHECKED
        # Tell liquidprompt that the feature check is done.
        set -g _LP_CHECKED
        _lp_checks
    end

    ## Directory check.
    # Just changed directory ? Run some tests on the current directory
    # and enable or disable things.
    _lp_directory

    ## Prompt printing.
    _lp_prompt

    # Cleaning, the user doesn't need this.
    set -e last_status
end

function _lp_init --description 'Initialize liquidprompt'
    ## Liquidprompt init functions
    function _lp_os_detect --description 'Detect the OS'
        set -l _UNAME (uname)
        switch "$_UNAME"
            case DragonFly
                set -g _LP_OS FreeBSD
            case '*'
                set -g _LP_OS "$_UNAME"
        end
        if [ "$_LP_OS" = "Darwin" ]
            set -g LP_DWIN_KERNEL_REL_VER (uname -r | cut -d . -f 1)
        end
    end

    function _lp_cpu_count --description 'Count CPUs'
        switch "$_LP_OS"
            case FreeBSD Darwin OpenBSD
                set -g _LP_CPUNUM (sysctl -n hw.ncpu)
            case SunOS
                set -g _LP_CPUNUM (kstat -m cpu_info | grep -c "module: cpu_info")
            # liquidprompt for bash/zsh defaults to Linux.
            case '*'
                set -g _LP_CPUNUM (nproc 2> /dev/null; or grep -c '^[Pp]rocessor' /proc/cpuinfo)
        end
    end

    function _lp_cpu_load_choose --description 'Choose the right _lp_cpu_load function'
        # Only the Linux version has been test so far !

        function _lp_cpu_load_linux --description 'Get the CPU load on Linux'
            if not set -q LP_ENABLE_LOAD
                return
            end

            set -l load
            set -l eol
            read load eol < /proc/loadavg
            echo "$load"
        end

        function _lp_cpu_load_bsd --description 'Get the CPU load on {Free,Open}BSD, Darwin'
            if not set -q LP_ENABLE_LOAD
                return
            end

            set -l bol
            set -l load
            set -l eol
            sysctl -n vm.loadavg | read bol load eol
            echo "$load"
        end

        function _lp_cpu_load_sunos --description 'Get the CPU load on SunOS'
            if not set -q LP_ENABLE_LOAD
                return
            end

            uptime | awk '{print substr($10,0,length($10))}'
        end

        functions -e _lp_cpu_load
        switch $_LP_OS
            case FreeBSD Darwin OpenBSD
                functions -c _lp_cpu_load_bsd _lp_cpu_load
            case SunOS
                functions -c _lp_cpu_load_sunos _lp_cpu_load
            # The OS detection defaults to Linux. Any OS that is not one
            # of the previous would anyway default to this.
            case '*'
                functions -c _lp_cpu_load_linux _lp_cpu_load
        end

        functions -e _lp_cpu_load_linux
        functions -e _lp_cpu_load_bsd
        functions -e _lp_cpu_load_sunos
    end

    function _lp_user --description 'Username'
        # Beware the subtlety! Here, we are setting _LP_USER!
        # We are checking somewhere else whether it should be displayed.
        # The user can decide it at runtime, so we are setting a hidden
        # _LP_USER that will remain unchanged.
        # If LP_USER has to be displayed, it is set to the value of _LP_USER
        # and when it has to be hidden, LP_USER is erased.
        set -g _LP_USER
        if [ (id -u) -eq 0 ]
            # If the user is root.
            set -g _LP_USER_IS_ROOT
            set _LP_USER "$LP_COLOR_USER_ROOT""$USER""$NO_COL"
        else if [ "$USER" != (logname 2> /dev/null; or echo $LOGNAME) ]
            # If the user is not login user.
            set -g LP_USER_IS_NOT_LOGIN
            set _LP_USER "$LP_COLOR_USER_ALT""$USER""$NO_COL"
        else
            set _LP_USER "$LP_COLOR_USER_LOGGED""$USER""$NO_COL"
            set -e LP_USER
        end
    end

    function _lp_hostname --description 'Hostname'
        # Same subtlety as in _lp_user! We are setting _LP_HOST, not LP_HOST!
        function _lp_connection
            # Local function to get fish's parent PID.
            # Fish doesn't provide a $PPID env variable.
            function _lp_fish_parent --description 'Get fish\'s parent'
                set -l FISH_PID %self
                set -l FISH_PPID (ps -f "$FISH_PID" | tail -n 1 | tr -s ' ' | cut -d ' ' -f 3)
                echo (ps -o comm= -p "$FISH_PPID" 2> /dev/null)
            end

            if [ -n "$SSH_CLIENT$SSH2_CLIENT$SSH_TTY" ]
                echo ssh
            else
                set -l SESS_SRC (who am i | sed -n 's/.*(\(.*\))/\1/p')
                set -l SESS_PARENT (_lp_fish_parent)

                if [ -z "$SESS_SRC" -o "$SESS_SRC" = ":" ]
                    echo lcl
                else if [ "$SESS_PARENT" = "su" -o "$SESS_PARENT" = "sudo" ]
                    echo su
                else
                    echo tel
                end
            end

            functions -e _lp_fish_parent
        end

        function _lp_chroot
            if [ -r /etc/debian_chroot ]
                echo "("(cat /etc/debian_chroot)")"
            end
        end

        set -g _LP_HOST
        set -g _LP_HOST (_lp_chroot)

        # Connection with X11 support.
        # Not sure this works with fish...
        if [ -n "$DISPLAY" ]
            set _LP_HOST "$LP_COLOR_X11_ON""$_LP_HOST""@""$NO_COL"
        else
            set _LP_HOST "$LP_COLOR_X11_OFF""$_LP_HOST""@""$NO_COL"
        end

        set -l _HOSTNAME (hostname -s)
        switch (_lp_connection)
            case lcl
                set -g LP_HOST_LOCAL
                set _LP_HOST "$_LP_HOST""$LP_COLOR_HOST""$_HOSTNAME""$NO_COL"
            case ssh
                if set -q LP_ENABLE_SSH_COLORS
                    function _lp_hash_to_color
                        set -l colors "red" "green" "yellow" "blue" "purple" "cyan"
                        echo "$colors[$argv[1]]"
                    end

                    set -l hash (math "1 + "(hostname | cksum | cut -d " " -f 1)" % 6")
                    set -l color (set_color (_lp_hash_to_color "$hash"))
                    set _LP_HOST "$_LP_HOST""$color""$_HOSTNAME""$NO_COL"

                    functions -e _lp_hash_to_color
                else
                    set _LP_HOST "$_LP_HOST""$LP_COLOR_SSH""$_HOSTNAME""$NO_COL"
                end
            case su
                set _LP_HOST "$_LP_HOST""$LP_COLOR_SU""$_HOSTNAME""$NO_COL"
            case tel
                set _LP_HOST "$_LP_HOST""$LP_COLOR_TELNET""$_HOSTNAME""$NO_COL"
            case '*'
                set _LP_HOST "$_LP_HOST""$_HOSTNAME"
        end

        functions -e _lp_connection
        functions -e _lp_chroot
    end

    function _lp_jobs_hack --description 'Hack for jobs processing'
        # Fish shell's builtin jobs command does not provide any option
        # for running/stopped jobs at the moment. It displays all jobs.
        # It is translated so we can't merely grep words such as “stopped”
        # or “running”.
        # At least, we know their position in the output.

        # Any command that doesn't end until the user kills it is good.
        # For now, let's use ping.
        ping localhost > /dev/null &
        set -g _LP_RUNNING_JOB_WORD (jobs -l | cut -f 4)
        kill -9 (jobs -l -p)
    end

    ## Functions used at runtime
    function _lp_return_value --description 'Print the status'
        if [ "$argv[1]" -ne 0 ]
            echo "$LP_COLOR_ERR""$argv[1]""$NO_COL"" "
        end
    end

    function _lp_title --description 'Title'
    end

    function _lp_color_map --description 'Color map'
        set -l value "$argv[1]"
        set -l scale
        if [ (count "$argv") -eq 2 ]
            # Custom scale
            set scale "$argv[2]"
        else
            # Default scale 0..100
            set scale 100
        end

        # - Transform the value to a 0..100 scale:
        # value := argv[1] * 100 / scale
        # - 0 <= value <= 100. So the colormap index is:
        # index := value / 10
        # Thus:
        set -l index (math "$value * 10 / $scale")

        eval "echo -ne \$LP_COLORMAP_$index"
    end

    function _lp_cpu_load_color --description 'Print the CPU load'
        if not set -q LP_ENABLE_LOAD
            return
        end

        # Remove the dot and all leading zeros.
        set -l load (_lp_cpu_load | sed 's/\.//g;s/^0*//g' )
        if [ -n "$load" ]
            set load (math "$load / $_LP_CPUNUM")
        else
            set load 0
        end

        if [ "$load" -ge "$LP_LOAD_THRESHOLD" ]
            set -l ret (_lp_color_map "$load" 200)"$LP_MARK_LOAD"

            if set -q LP_PERCENTS_ALWAYS
                set ret "$ret""$load""%"
            end
            echo -ne "$ret""$NO_COL"" "
        end
    end

    function _lp_temp_sensors --description 'Auxiliary function for _lp_temperature'
        # Return the average system temperature we get through the sensors command
        set -l count 0
        set -l temperature 0
        for i in (sensors | grep -E "^(Core|temp)" | sed -r "s/.*: *\+([0-9]*)\..°.*/\1/g")
            set temperature (math "$temperature + $i")
            set count (math "$count + 1")
        end
        echo -ne (math "$temperature / $count")
    end

    function _lp_temperature --description 'Print the temperature'
        # Will display the numeric value as we got it through the _lp_temp_function
        # and colorize it through _lp_color_map.
        if not set -q LP_ENABLE_TEMP
            return
        end

        set -l temperature (_lp_temp_sensors)
        if [ $temperature -ge $LP_TEMP_THRESHOLD ]
            echo -ne "$LP_MARK_TEMP"(_lp_color_map "$temperature" 120)"$temperature""°""$NO_COL"" "
        end
    end

    function _lp_battery --description 'Auxiliary function for _lp_battery_color'
        if not set -q LP_ENABLE_BATT
            return
        end

        # Extract the battery load value in percent.
        set -l bat (acpi --battery 2> /dev/null | sed 's/^Battery .*, //;s/\%.*$//')

        if [ -z "$bat" ]
            # Battery level not found.
            return 4
        else if [ (acpi --ac-adapter | sed 's/^Adapter .*: //') = "off-line" ]
            # The battery is discharging.
            if [ "$bat" -le "$LP_BATTERY_THRESHOLD" ]
                echo -n "$bat"
                return 0
            else
                echo -n "$bat"
                return 1
            end
        else
            # The battery is charging.
            if [ "$bat" -le "$LP_BATTERY_THRESHOLD" ]
                echo -n "$bat"
                return 2
            else
                echo -n "$bat"
                return 3
            end
        end
    end

    function _lp_battery_color --description 'Print the battery state'
        if not set -q LP_ENABLE_BATT
            return
        end

        set -l mark "$LP_MARK_BATTERY"
        set -l chargingmark "$LP_MARK_ADAPTER"
        set -l bat (_lp_battery)
        set -l ret "$status"

        if [ "$ret" -eq 4 -o "$bat" -eq 100 ]
            # No battery support or battery full: nothing displayed.
            return
        else if [ "$ret" -eq 3 -a "$bat" -ne 100 ]
            # The battery is charging and above the threshold and not 100%
            # Green ⏚
            echo -ne "$LP_COLOR_CHARGING_ABOVE""$chargingmark""$NO_COL"" "
            return
        else if [ "$ret" -eq 2 ]
            # The battery is charging but under the threshold.
            # Yellow ⏚
            echo -ne "$LP_COLOR_CHARGING_UNDER""$chargingmark""$NO_COL"" "
            return
        else if [ "$ret" -eq 1 ]
            # The battery is discharging but above the threshold.
            # Yellow ⌁
            echo -ne "$LP_COLOR_DISCHARGING_ABOVE""$mark""$NO_COL"" "
            return
        else if [ -n "$bat" ]
            # The battery is discharging and under the threshold.
            set ret "$LP_COLOR_DISCHARGING_UNDER""$mark""$NO_COL"

            if set -q LP_PERCENTS_ALWAYS
                if [ "$bat" -le 100 -a "$bat" -gt 80 ]
                    set ret "$ret""$LP_COLORMAP_1"
                else if [ "$bat" -le 80 -a "$bat" -gt 65 ]
                    set ret "$ret""$LP_COLORMAP_2"
                else if [ "$bat" -le 65 -a "$bat" -gt 50 ]
                    set ret "$ret""$LP_COLORMAP_3"
                else if [ "$bat" -le 50 -a "$bat" -gt 40 ]
                    set ret "$ret""$LP_COLORMAP_4"
                else if [ "$bat" -le 40 -a "$bat" -gt 30 ]
                    set ret "$ret""$LP_COLORMAP_5"
                else if [ "$bat" -le 30 -a "$bat" -gt 20 ]
                    set ret "$ret""$LP_COLORMAP_6"
                else if [ "$bat" -le 20 -a "$bat" -gt 10 ]
                    set ret "$ret""$LP_COLORMAP_7"
                else if [ "$bat" -le 10 -a "$bat" -gt 5 ]
                    set ret "$ret""$LP_COLORMAP_8"
                else if [ "$bat" -le 5 -a "$bat" -gt 0 ]
                    set ret "$ret""$LP_COLORMAP_9"
                else
                    # for debugging purpose
                    set ret "$ret""$LP_COLORMAP_0"
                end
                set ret "$ret""$bat""%"
            end # LP_PERCENTS_ALWAYS
            echo -ne "$ret""$NO_COL"" "
        end # ret
    end

    function _lp_proxy --description 'Proxy'
        if not set -q LP_ENABLE_PROXY
            return
        end

        if [ -n "$http_proxy" ]
            echo -ne "$LP_COLOR_PROXY""$LP_MARK_PROXY""$NO_COL"" "
        end
    end

    function _lp_virtualenv --description 'Virtualenv'
        if not set -q LP_ENABLE_VIRTUALENV
            return
        end

        if [ -n "$VIRTUAL_ENV" ]
            echo "[""$LP_COLOR_VIRTUALENV"(basename "$VIRTUAL_ENV")"$NO_COL""]"" "
        end
    end

    function _lp_jobcount --description 'Print jobs info'
        if not set -q LP_ENABLE_JOBS
            return
        end

        set -l all_jobs (jobs | wc -l)
        set -l running (jobs | grep "$LP_RUNNING_JOB_WORD" | wc -l)
        set -l stopped (math "$all_jobs - $running")
        set -l n_screen (screen -ls 2> /dev/null | grep -c "Detach")
        set -l n_tmux (tmux list-sessions 2> /dev/null ` grep -cv "attached")
        [ -z "$n_screen" ]; and set n_screen 0
        [ -z "$n_tmux" ]; and set n_tmux 0
        set -l detached (math "$n_screen + $n_tmux")
        set -l m_detached "d"
        set -l m_stop "z"
        set -l m_run "&"
        set -l ret

        if [ "$detached" -ne 0 ]
            set ret "$ret""$LP_COLOR_JOB_D""$detached""$m_detached""$NO_COL"
        end

        if [ "$running" -ne 0 ]
            [ -n "$ret" ]; and set ret "$ret""/"
            set ret "$ret""$LP_COLOR_JOB_R""$running""$m_run""$NO_COL"
        end

        if [ $stopped -ne 0 ]
            [ -n "$ret" ]; and set ret "$ret""/"
            set ret "$ret""$LP_COLOR_JOB_Z""$stopped""$m_stop""$NO_COL"
        end

        [ -n "$ret" ]; and set ret "$ret"" "

        echo -ne "$ret"
    end

    function _lp_git --description 'git'
        set -l branch (__fish_git_prompt | sed 's/^ (//g;s/)$//g')
        if [ -n "$branch" ]
            set -l ret
            set -l end "$NO_COL"

            if [ (git status 2> /dev/null | grep "# Untracked") ]
                set end "$LP_COLOR_CHANGES""$LP_MARK_UNTRACKED""$end"
            end
            if [ (git stash list 2> /dev/null) ]
                set end "$LP_COLOR_COMMITS""$LP_MARK_STASH""$end"
            end

            set -l remote (git config --get branch.{$branch}.remote 2> /dev/null)
            set -l has_commit 0

            if [ -n "$remote" ]
                set -l remote_branch (git config --get branch.{$branch}.merge)
                if [ -n "$remote_branch" ]
                    set -l tmp_string (echo $remote_branch | sed "s/refs\/heads/refs\/remotes\/$remote/")
                    set has_commit (git rev-list --no-merges --count {$tmp_string}..HEAD 2> /dev/null)
                    if [ -z "$has_commit" ]
                        set has_commit 0
                    end
                end
            end

            set -l shortstat (git diff --shortstat 2> /dev/null)
            if [ -n "$shortstat" ]
                set -l has_lines (echo "$shortstat" | sed 's/^.*changed, //;s/ insert.*, /\/-/;s/ delet.*$//')
                if [ (echo "$shortstat" | grep "insertion") ]
                    set has_lines "+""$has_lines"
                else
                    set has_lines "-""$has_lines"
                end

                if [ "$has_commit" -gt 0 ]
                    set ret "$LP_COLOR_CHANGES""$branch""$NO_COL""(""$LP_COLOR_DIFF""$has_lines""$NO_COL"",""$LP_COLOR_COMMITS""$has_commit""$NO_COL"")"
                else
                    set ret "$LP_COLOR_CHANGES""$branch""$NO_COL""(""$LP_COLOR_DIFF""$has_lines""$NO_COL"")"
                end
            else
                if [ "$has_commit" -gt 0 ]
                    set ret "$LP_COLOR_COMMITS""$branch""$NO_COL""(""$LP_COLOR_COMMITS""$has_commit""$NO_COL"")"
                else
                    set ret "$LP_COLOR_UP""$branch""$NO_COL"
                end
            end

            echo "$ret""$end"" "
        end
    end

    function _lp_hg --description 'mercurial'
    end

    function _lp_svn --description 'subversion'
    end

    function _lp_fossil --description 'fossil'
    end

    function _lp_bzr --description 'bazaar'
    end

    ## Actual init
    # OS specific
    _lp_os_detect
    _lp_cpu_count
    _lp_cpu_load_choose
    if [ (echo "$TERM" | head -c 6) = "screen" ]
        set -g LP_BRACKET_OPEN "$LP_COLOR_IN_MULTIPLEXER""$LP_MARK_BRACKET_OPEN""$NO_COL"
        set -g LP_BRACKET_CLOSE "$LP_COLOR_IN_MULTIPLEXER""$LP_MARK_BRACKET_CLOSE""$NO_COL"" "
    else
        set -g LP_BRACKET_OPEN "$LP_MARK_BRACKET_OPEN"
        set -g LP_BRACKET_CLOSE "$LP_MARK_BRACKET_CLOSE"" "
    end

    # Misc.
    _lp_user
    _lp_hostname
    _lp_jobs_hack

    # Once the initialization is done, these functions are of no use.
    functions -e _lp_init_clean
    functions -e _lp_os_detect
    functions -e _lp_cpu_count
    functions -e _lp_cpu_load_choose
    functions -e _lp_user
    functions -e _lp_hostname
    functions -e _lp_jobs_hack
end

function _lp_config --description 'Configure liquidprompt'
    function _lp_default_config --description 'Default config'
        set -g _LP_OPEN_ESC "\["
        set -g _LP_CLOSE_ESC "\]"

        set -l BOLD (set_color -o)

        set -l BLACK (set_color black)
        set -l BOLD_GRAY (set_color -o black)
        set -l WHITE (set_color white)
        set -l BOLD_WHITE (set_color -o white)

        set -l RED (set_color red)
        set -l BOLD_RED (set_color -o red)
        set -l WARN_RED (set_color -b red)(set_color black)
        set -l CRIT_RED (set_color -b red)(set_color white)
        set -l DANGER_RED (set_color -b red)(set_color -o yellow)

        set -l GREEN (set_color green)
        set -l BOLD_GREEN (set_color -o green)

        set -l YELLOW (set_color yellow)
        set -l BOLD_YELLOW (set_color -o yellow)

        set -l BLUE (set_color blue)
        set -l BOLD_BLUE (set_color -o blue)

        set -l PURPLE (set_color purple)
        set -l PINK (set_color -o purple)

        set -l CYAN (set_color cyan)
        set -l BOLD_CYAN (set_color -o cyan)

        # NO_COL is special: it will be used at runtime, not just during config loading
        set -g NO_COL (set_color normal)

        # Default values (globals)
        set -g LP_BATTERY_THRESHOLD 100
        set -g LP_LOAD_THRESHOLD 5
        set -g LP_TEMP_THRESHOLD 5
        set -g LP_PATH_LENGTH 35
        set -g LP_PATH_KEEP 2
        set -e LP_HOSTNAME_ALWAYS
        set -e LP_USER_ALWAYS
        set -g LP_PERCENTS_ALWAYS
        set -g LP_PS1 ""
        set -g LP_PROMPT_PREFIX ""
        set -g LP_PROMPT_POSTFIX ""
        set -g LP_TITLE_OPEN "\e]0;"
        set -g LP_TITLE_CLOSE "\a"
        set -g LP_SCREEN_TITLE_OPEN "\033k"
        set -g LP_SCREEN_TITLE_CLOSE "\033\134"

        set -g LP_ENABLE_PERM
        set -g LP_ENABLE_SHORTEN_PATH
        set -g LP_ENABLE_PROXY
        set -g LP_ENABLE_TEMP
        set -g LP_ENABLE_JOBS
        set -g LP_ENABLE_LOAD

        set -g LP_ENABLE_GIT
        set -g LP_ENABLE_SVN
        set -g LP_ENABLE_FOSSIL
        set -g LP_ENABLE_HG
        set -g LP_ENABLE_BZR
        set -g LP_ENABLE_BATT

        set -e LP_ENABLE_TIME
        set -g LP_ENABLE_VIRTUALENV
        set -e LP_ENABLE_VCS_ROOT
        set -e LP_ENABLE_TITLE
        set -e LP_ENABLE_SCREEN_TITLE
        set -e LP_ENABLE_SSH_COLORS
        set -g LP_DISABLED_VCS_PATH ""

        set -g LP_MARK_DEFAULT ""
        set -g LP_MARK_DEFAULT "\$"
        set -g LP_MARK_BATTERY "⌁"
        set -g LP_MARK_ADAPTER "⏚"
        set -g LP_MARK_LOAD "⌂"
        set -g LP_MARK_TEMP "θ"
        set -g LP_MARK_PROXY "↥"
        set -g LP_MARK_HG "☿"
        set -g LP_MARK_SVN "‡"
        set -g LP_MARK_GIT "±"
        set -g LP_MARK_FOSSIL "⌘"
        set -g LP_MARK_BZR "⚯"
        set -g LP_MARK_DISABLED "⌀"
        set -g LP_MARK_UNTRACKED "*"
        set -g LP_MARK_STASH "+"
        set -g LP_MARK_BRACKET_OPEN "["
        set -g LP_MARK_BRACKET_CLOSE "]"
        set -g LP_MARK_SHORTEN_PATH " … "

        set -g LP_COLOR_PATH "$BOLD"
        set -g LP_COLOR_PATH_ROOT "$BOLD_YELLOW"
        set -g LP_COLOR_PROXY "$BOLD_BLUE"
        set -g LP_COLOR_JOB_D "$YELLOW"
        set -g LP_COLOR_JOB_R "$BOLD_YELLOW"
        set -g LP_COLOR_JOB_Z "$BOLD_YELLOW"
        set -g LP_COLOR_ERR "$PURPLE"
        set -g LP_COLOR_MARK "$BOLD"
        set -g LP_COLOR_MARK_ROOT "$BOLD_RED"
        set -g LP_COLOR_USER_LOGGED ""
        set -g LP_COLOR_USER_ALT "$BOLD"
        set -g LP_COLOR_USER_ROOT "$BOLD_YELLOW"
        set -g LP_COLOR_HOST ""
        set -g LP_COLOR_SSH "$BLUE"
        set -g LP_COLOR_SU "$BOLD_YELLOW"
        set -g LP_COLOR_TELNET "$WARN_RED"
        set -g LP_COLOR_X11_ON "$GREEN"
        set -g LP_COLOR_X11_OFF "$YELLOW"
        set -g LP_COLOR_WRITE "$GREEN"
        set -g LP_COLOR_NOWRITE "$RED"
        set -g LP_COLOR_UP "$GREEN"
        set -g LP_COLOR_COMMITS "$YELLOW"
        set -g LP_COLOR_CHANGES "$RED"
        set -g LP_COLOR_DIFF "$PURPLE"
        set -g LP_COLOR_CHARGING_ABOVE "$GREEN"
        set -g LP_COLOR_CHARGING_UNDER "$YELLOW"
        set -g LP_COLOR_DISCHARGING_ABOVE "$YELLOW"
        set -g LP_COLOR_DISCHARGING_UNDER "$RED"
        set -g LP_COLOR_TIME "$BLUE"
        set -g LP_COLOR_IN_MULTIPLEXER "$BOLD_BLUE"

        set -g LP_COLORMAP_0 ""
        set -g LP_COLORMAP_1 "$GREEN"
        set -g LP_COLORMAP_2 "$BOLD_GREEN"
        set -g LP_COLORMAP_3 "$YELLOW"
        set -g LP_COLORMAP_4 "$BOLD_YELLOW"
        set -g LP_COLORMAP_5 "$RED"
        set -g LP_COLORMAP_6 "$BOLD_RED"
        set -g LP_COLORMAP_7 "$WARN_RED"
        set -g LP_COLORMAP_8 "$CRIT_RED"
        set -g LP_COLORMAP_9 "$DANGER_RED"

        set -e LP_TIME_ANALOG
    end

    function _lp_source_config --description 'Source the config file'
        set -l configfile
        if [ -f "/etc/liquidpromptrc.fish" ]
            . "/etc/liquidpromptrc.fish"
        end

        if [ -f "$HOME/.liquidpromptrc.fish" ]
            set configfile "$HOME/.liquidpromptrc.fish"
        else if [ -z "$XDG_HOME_DIR" ]
            set configfile "$HOME/.liquidpromptrc.fish"
        else
            set configfile "$XDG_HOME_DIR/liquidpromptrc.fish"
        end

        if [ -f "$configfile" ]
            . "$configfile"
        end
    end

    _lp_default_config
    _lp_source_config

    functions -e _lp_default_config
    functions -e _lp_source_config
end

function _lp_checks --description 'Checks'
    function _lp_check_features --description 'Check whether a tool is installed, and enable/disable it'
        # Disable features if the tool is not installed.
        [ (command command -v git) ]; or set -e LP_ENABLE_GIT
        [ (command command -v svn) ]; or set -e LP_ENABLE_SVN
        [ (command command -v fossil) ]; or set -e LP_ENABLE_FOSSIL
        [ (command command -v hg) ]; or set -e LP_ENABLE_HG
        [ (command command -v bzr) ]; or set -e LP_ENABLE_BZR
        [ (command command -v acpi) ]; or set -e LP_ENABLE_BATT
        [ (command command -v sensors) ]; or set -e LP_ENABLE_SENSORS
    end

    function _lp_choose_time --description 'Choose the right _lp_time'
        if functions -q _lp_time
            functions -e _lp_time
        end

        function _lp_time_analog --description 'Display an approximate analog clock'
            if not set -q LP_ENABLE_TIME
                return
            end

            # Get the date as "hours(12) minutes" in a single call.
            # (We are inserting a new line in between so that d is an array.)
            set -l d (date "+%I%n%M")
            # Separate hours and minutes.
            set -l hour "$d[1]"
            set -l min "$d[2]"

            # The targeted unicode characters are the "CLOCK FACE" ones
            # They are located in the codepages between:
            #     U+1F550 (ONE OCLOCK) and U+1F55B (TWELVE OCLOCK), for the plain hours.
            #     U+1F55C (ONE-THIRTY) and U+1F567 (TWELVE-THIRTY), for the thirties.
            set -l plain "🕐" "🕑" "🕒" "🕓" "🕔" "🕕" "🕖" "🕗" "🕘" "🕙" "🕚" "🕛"
            set -l half "🕜" "🕝" "🕞" "🕟" "🕠" "🕡" "🕢" "🕣" "🕤" "🕥" "🕦" "🕧"

            if [ "$min" -lt 15 ]
                echo -n $plain[$hour]" "
            else if [ "$min" -lt 45 ]
                echo -n $half[$hour]" "
            else
                echo -n $plain[(math "$hour % 12 +1")]" "
            end
        end

        function _lp_time_digital --description 'Display the time'
            if not set -q LP_ENABLE_TIME
                return
            end

            echo (date "+%H:%M:%S")" "
        end

        # Choose the _lp_time function.
        if set -q LP_TIME_ANALOG
            functions -c _lp_time_analog _lp_time
        else
            functions -c _lp_time_digital _lp_time
        end

        functions -e _lp_time_analog
        functions -e _lp_time_digital
    end

    function _lp_check_user --description 'Check whether the user name should be displayed'
        set -q _LP_USER_IS_ROOT; or set -q LP_USER_IS_NOT_LOGIN; or set -q LP_USER_ALWAYS
        if [ "$status" -eq 0 ]
            # If one of the conditions above is true.
            set -g LP_USER "$_LP_USER"
        else
            set -e LP_USER
        end
    end

    function _lp_check_hostname --description 'Check whether the hostname should be displayed'
        set -q LP_HOST_LOCAL; and not set -q LP_HOSTNAME_ALWAYS
        if [ "$status" -eq 0 ]
            set -e LP_HOST
        else
            set -g LP_HOST "$_LP_HOST"
        end
    end

    _lp_check_features
    _lp_choose_time
    _lp_check_user
    _lp_check_hostname

    functions -e _lp_check_features
    functions -e _lp_choose_time
end

function _lp_directory --description 'Check things on directory change'
    if set -q _LP_OLD_PWD
        if [ "$_LP_OLD_PWD" = "$PWD" ]
            return
        end
    end

    ## Local functions
    function _lp_are_vcs_disabled --description 'Check whether VCS are disabled for the PWD'
        if not set -q LP_DISABLED_VCS_PATH
            return 1
        else if contains $PWD $LP_DISABLED_VCS_PATH
            return 0
        else
            return 1
        end
    end

    function _lp_wd_vcs_type --description 'Determine which vcs should be used'
        if set -q LP_ENABLE_GIT
            if [ (__fish_git_prompt) ]
                echo "git"
                return
            end
        end

        if set -q LP_ENABLE_SVN
        end

        if set -q LP_ENABLE_FOSSIL
        end

        if set -q LP_ENABLE_HG
        end

        if set -q LP_ENABLE_BZR
        end

        if _lp_are_vcs_disabled
            echo "disabled"
        else
            echo "none or unknown"
        end
    end

    function _lp_choose_wd_vcs --description 'Choose the right _lp_wd_vcs'
        if functions -q _lp_wd_vcs
            functions -e _lp_wd_vcs
        end

        function _nothing
        end

        switch "$argv[1]"
            case git git-svn
                functions -c _lp_git _lp_wd_vcs
            case hg
                functions -c _lp_hg _lp_wd_vcs
            case svn
                functions -c _lp_svn _lp_wd_vcs
            case fossil
                functions -c _lp_fossil _lp_wd_vcs
            case bzr
                functions -c _lp_bzr _lp_wd_vcs
            case '*'
                functions -c _nothing _lp_wd_vcs
        end

        functions -e _nothing
    end

    function _lp_permissions_color --description 'Check permissions and color the colon'
        if not set -q LP_ENABLE_PERM
            set -g LP_PERM ":"
        else if [ -w "$PWD" ]
            set -g LP_PERM "$LP_COLOR_WRITE"":""$NO_COL"
        else
            set -g LP_PERM "$LP_COLOR_NOWRITE"":""$NO_COL"
        end
    end

    function _lp_smart_mark --description 'Smart mark'
        set -l COL "$LP_COLOR_MARK"
        if set -q _LP_USER_IS_ROOT
            set COL "$LP_COLOR_MARK_ROOT"
        end

        set -l mark
        if [ -n "$LP_MARK_DEFAULT" ]
            set mark "$LP_MARK_DEFAULT"
        else
            set mark "\\\$"
        end

        switch "$argv[1]"
            case git
                set mark "$LP_MARK_GIT"
            case git-svn
                set mark "$LP_MARK_GIT""$LP_MARK_SVN"
            case hg
                set mark "$LP_MARK_HG"
            case svn
                set mark "$LP_MARK_SVN"
            case fossil
                set mark "$LP_MARK_FOSSIL"
            case bzr
                set mark "$LP_MARK_BZR"
            case disabled
                set mark "$LP_MARK_DISABLED"
            case '*'
                if [ -n "$LP_MARK_DEFAULT" ]
                    set mark "$LP_MARK_DEFAULT"
                else
                    set mark "$LP_MARK_SYMBOL"
                end
        end
        echo -ne "$COL""$mark""$NO_COL"
    end

    ## Cleaning
    set -g _LP_OLD_PWD "$PWD"
    set -e LP_WD_DISABLE_VCS
    set -e LP_PERM
    functions -e _lp_wd_vcs

    ## Actual body
    set -l vcs_type (_lp_wd_vcs_type)
    if not _lp_are_vcs_disabled
        _lp_choose_wd_vcs "$vcs_type"
    end
    set -g LP_MARK (_lp_smart_mark "$vcs_type")

    _lp_permissions_color

    set -g LP_PWD (prompt_pwd)

    if set -q _LP_USER_IS_ROOT
        set LP_PWD "$LP_COLOR_PATH_ROOT""$LP_PWD""$NO_COL"
    else
        set LP_PWD "$LP_COLOR_PATH""$LP_PWD""$NO_COL"
    end

    ## Cleaning, again.
    functions -e _lp_are_vcs_disabled
    functions -e _lp_wd_vcs_type
    functions -e _lp_choose_wd_vcs
    functions -e _lp_permissions_color
    functions -e _lp_smart_mark
end

function _lp_prompt --description 'Compute the prompt'
    ## Variables used in the prompt.
    #
    # Reminder:
    # - The following variables are computed at initialization time and
    # should not change at runtime:
    # LP_BRACKET_OPEN, LP_USER, LP_HOST, LP_BRACKET_CLOSE
    # - The following variables need to be computed only when changing
    # directories:
    # LP_PERM, LP_PWD, LP_MARK
    # (and LP_VENV ?)
    if set -q _LP_BASIC_PROMPT
        echo "$LP_MARK "
        return
    end

    set -l LP_JOBS (_lp_jobcount)
    set -l LP_TEMP (_lp_temperature)
    set -l LP_LOAD (_lp_cpu_load_color)
    set -l LP_BATT (_lp_battery_color)
    set -l LP_TIME (_lp_time)

    set -l LP_PROXY (_lp_proxy)
    set -l LP_VENV (_lp_virtualenv)

    set -l LP_ERR (_lp_return_value $last_status)

    set -l LP_VCS (_lp_wd_vcs)

    ## Prompt
    set -l LP_PROMPT

    set LP_PROMPT "$LP_PROMPT_PREFIX""$LP_TIME""$LP_BATT""$LP_LOAD""$LP_TEMP""$LP_JOBS"
    set LP_PROMPT "$LP_PROMPT""$LP_BRACKET_OPEN""$LP_USER""$LP_HOST""$LP_PERM"
    set LP_PROMPT "$LP_PROMPT""$LP_PWD""$LP_BRACKET_CLOSE""$LP_VENV""$LP_PROXY"
    if set -q _LP_USER_IS_ROOT
        if set -q LP_ENABLE_VCS_ROOT
            set LP_PROMPT "$LP_PROMPT""$LP_VCS"
        end
    else
        set LP_PROMPT "$LP_PROMPT""$LP_VCS"
    end
    set LP_PROMPT "$LP_PROMPT""$LP_ERR""$LP_MARK""$LP_PROMPT_POSTFIX"

    set -l LP_TITLE (_lp_title "$LP_PROMPT")
    set LP_PROMPT "$LP_TITLE""$LP_PROMPT"

    echo "$LP_PROMPT"" "
end

function lp_enable --description 'Enable an option'
    set -l available "PERM" "PROXY" "TEMP" "JOBS" "LOAD" "GIT" "SVN" "FOSSIL" "HG" "BZR" "BATT" "TIME" "VIRTUALENV" "VCS_ROOT" "TITLE" "SCREEN_TITLE" "SSH_COLORS"

    for arg in $argv
        if [ "$arg" = "--list" -o "$arg" = "-l" ]
            echo -e "Available options:\n$available"
            return
        end
    end

    if [ (count $argv) -ne 1 ]
        echo "Usage: lp_enable [-l | --list] <option>" >&2
        return 64
    end

    set -l arg (echo "$argv[1]" | tr [:lower:] [:upper:])

    if not contains "$arg" $available
        echo "$arg is not a valid option." >&2
        return 65
    end

    set -l option (echo "LP_ENABLE_""$arg")
    if not set -q (echo "$option")
        set -g (echo "$option")
    end

    # Force liquidprompt to check the features.
    set -e _LP_CHECKED
    # Force liquidprompt to run the directory checks.
    set -e _LP_OLD_PWD

    return 0
end

function lp_disable --description 'Disable an option'
    set -l available "PERM" "PROXY" "TEMP" "JOBS" "LOAD" "GIT" "SVN" "FOSSIL" "HG" "BZR" "BATT" "TIME" "VIRTUALENV" "VCS_ROOT" "TITLE" "SCREEN_TITLE" "SSH_COLORS"

    for arg in $argv
        if [ "$arg" = "--list" -o "$arg" = "-l" ]
            echo -e "Available options:\n$available"
            return
        end
    end

    if [ (count $argv) -ne 1 ]
        echo "Usage: lp_disable [-l | --list] <option>" >&2
        return 64
    end

    set -l arg (echo "$argv[1]" | tr [:lower:] [:upper:])

    if not contains "$arg" $available
        echo "$arg is not a valid option." >&2
        return 65
    end

    set -l option (echo "LP_ENABLE_""$arg")
    if set -q (echo "$option")
        set -e (echo "$option")
    end

    # Force liquidprompt to check the features.
    set -e _LP_CHECKED
    # Force liquidprompt to run the directory checks.
    set -e _LP_OLD_PWD

    return 0
end

function lp_set_prefix --description 'Set the prompt prefix'
    if [ (count "$argv") -ne 1 ]
        echo "Usage: lp_set_prefix <prompt prefix>" >&2
        return 64
    end
    set -g LP_PROMPT_PREFIX "$argv[1]"

    return 0
end

function lp_set_postfix --description 'Set the prompt postfix'
    if [ (count "$argv") -ne 1 ]
        echo "Usage: lp_set_prefix <prompt postfix>" >&2
        return 64
    end
    set -g LP_PROMPT_POSTFIX "$argv[1]"

    return 0
end

function lp_prompt_off --description 'Display a very basic and fast prompt'
    set -g _LP_BASIC_PROMPT

    return 0
end

function lp_prompt_on --description 'Display the liquidprompt'
    set -e _LP_BASIC_PROMPT

    return 0
end

complete -c lp_enable -x -l list -d 'List available options'
complete -c lp_enable -x -a 'PERM' -d 'Enable permissions color'
complete -c lp_enable -x -a 'PROXY' -d 'Enable proxy display'
complete -c lp_enable -x -a 'TEMP' -d 'Enable temperature display'
complete -c lp_enable -x -a 'JOBS' -d 'Enable jobs informations display'
complete -c lp_enable -x -a 'LOAD' -d 'Enable cpu load display'
complete -c lp_enable -x -a 'GIT' -d 'Enable git informations display'
complete -c lp_enable -x -a 'SVN' -d 'Enable subversion informations display'
complete -c lp_enable -x -a 'FOSSIL' -d 'Enable fossil informations display'
complete -c lp_enable -x -a 'BZR' -d 'Enable bazaar informations display'
complete -c lp_enable -x -a 'BATT' -d 'Enable battery state display'
complete -c lp_enable -x -a 'VIRTUALENV' -d 'Enable virtualenv informations display'
complete -c lp_enable -x -a 'VCS_ROOT' -d 'Enable vcs informations display for root'
complete -c lp_enable -x -a 'TITLE' -d 'Enable title'
complete -c lp_enable -x -a 'SCREEN_TITLE' -d 'Enable screen title'
complete -c lp_enable -x -a 'SSH_COLORS' -d 'Enable ssh colors'

complete -c lp_disable -x -l list -d 'List available options'
complete -c lp_disable -x -a 'PERM' -d 'Disable permissions color'
complete -c lp_disable -x -a 'PROXY' -d 'Disable proxy display'
complete -c lp_disable -x -a 'TEMP' -d 'Disable temperature display'
complete -c lp_disable -x -a 'JOBS' -d 'Disable jobs informations display'
complete -c lp_disable -x -a 'LOAD' -d 'Disable cpu load display'
complete -c lp_disable -x -a 'GIT' -d 'Disable git informations display'
complete -c lp_disable -x -a 'SVN' -d 'Disable subversion informations display'
complete -c lp_disable -x -a 'FOSSIL' -d 'Disable fossil informations display'
complete -c lp_disable -x -a 'BZR' -d 'Disable bazaar informations display'
complete -c lp_disable -x -a 'BATT' -d 'Disable battery state display'
complete -c lp_disable -x -a 'VIRTUALENV' -d 'Disable virtualenv informations display'
complete -c lp_disable -x -a 'VCS_ROOT' -d 'Disable vcs informations display for root'
complete -c lp_disable -x -a 'TITLE' -d 'Disable title'
complete -c lp_disable -x -a 'SCREEN_TITLE' -d 'Disable screen title'
complete -c lp_disable -x -a 'SSH_COLORS' -d 'Disable ssh colors'

# complete -c lp_enable -x -l list -a "PERM PROXY TEMP JOBS LOAD GIT SVN FOSSIL HG BZR BATT TIME VIRTUALENV VCS_ROOT TITLE SCREEN_TITLE SSH_COLORS"
# complete -c lp_disable -x -l list -a "PERM PROXY TEMP JOBS LOAD GIT SVN FOSSIL HG BZR BATT TIME VIRTUALENV VCS_ROOT TITLE SCREEN_TITLE SSH_COLORS"
