# vim:sw=4:ts=4:et:sts=4

# startship for prompt
prompt off
eval "$(starship init zsh)"

# zsh-syntax highlighting
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Aliases
alias ls="ls --color=auto --hyperlink=auto -v"

# pyenv config
eval "$(pyenv init -)"

# Functions
## To activate virtualenv for a python project
function setupvenv() {
    local vf=${1:-$PWD}
    [ $vf = $HOME ] && [ ! -f $vf/venv/bin/activate ] && \
        echo -e "\e[1;31mSir, This is \e[0;9mWendy's\e[0;1;32m \e]8;;file://\
$HOST$vf\e\\HOME\e]8;;\e\\ \e[1;31m!\e[0m" && \
        return
    [ -f $vf/venv/bin/activate ] && \
        source $vf/venv/bin/activate && cd $vf || \
        echo -e "\e[0;31mThere is \e[1mNO virtualenv \e[0;31mcalled \e[1;36m\
venv\e[0;31m setup in \e[1;32m\e]8;;file://$HOST$(realpath $vf)\e\\$vf\e]8;;\
\e\\ \e[0;31m!\e[0m"
}

# Note: The garbled mess of the echo strings are
# "Sir, This is ~~Wendy's~~ HOME !" and
# "There is NO virtualenv called venv setup in $vf !" respectively
