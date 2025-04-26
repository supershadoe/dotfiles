# vim:sw=4:ts=4:et:sts=4

# startship for prompt
prompt off
eval "$(starship init zsh)"

# zsh-syntax highlighting
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Aliases
alias ls="ls --color=auto --hyperlink=auto -v"

# pyenv config
which pyenv 2>&1 > /dev/null && eval "$(pyenv init -)"

# Functions
## To activate virtualenv for a python project
function setupvenv() {
    local venv_dir=${1:-"venv"}
    local work_dir=${1:-$PWD}
    if [ -f "$work_dir/$venv_dir/bin/activate" ]
    then
        source "$work_dir/$venv_dir/bin/activate" && cd $work_dir
    else
        local fs_t1="\e[0;31m%s \e[1m%s \e[0;31m%s \e[1;36m%s\e[0;31m %s"
        local fs_link="\e[1;32m\e]8;;%s\e\\%s\e]8;;\e\\"
        local fs_t2="\e[0;31m%s\e[0m\n"
        printf "$fs_t1 $fs_link $fs_t2" \
            "There is" "NO virtualenv" "called" "$venv_dir" "setup in" \
            "file://$HOST$(realpath $work_dir)" "$work_dir" "!"
    fi
}

# Kill old sessions using loginctl while on SSH
function kill_other_sessions_self() {
    for i in $(loginctl list-sessions \
        | awk \
            -v uid=$UID \
            -v tty=$(tty | cut -d/ -f3-) \
            '$2 == uid && $6 == "user" && $7 != tty { print $1 }'\
    )
        do loginctl kill-session $i
    done
    unset i
}
