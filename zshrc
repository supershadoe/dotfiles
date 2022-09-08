# vim:sw=4:ts=4:et:sts=4
# Cleanup of various history files
unset HISTFILE
histfiles=(
    "$HOME/.zsh_history" \
    "$HOME/.zdirs" \
    "$HOME/.lesshst" \
    "$HOME/.kotlinc_history" \
    "$HOME/.mysql_history" \
    "$HOME/.nmcli_history" \
    "$HOME/.psql_history" \
    "$HOME/.python_history" \
    "$HOME/.sqlite_history")
for i in $histfiles
do
    [ -f $i ] && rm $i
done
unset histfiles
unsetopt auto_pushd

: << Comment
Creation of "throw away" directories specified in
$XDG_CONFIG_HOME/user-dirs.dirs
in place of DESKTOP and PUBLICSHARE directories as I have no use for those
Comment

throwaway_dirs=("$XDG_CACHE_HOME/throwaway1" "$XDG_CACHE_HOME/throwaway2")
for i in $throwaway_dirs
do
    [ ! -d $i ] && mkdir -p $i
done
unset throwaway_dirs

: << Comment
Below are some lines which are used for styling the zsh prompt
:prompt:grml: is for the zsh prompt
:vcs_info: is for VCS prompts(like git)
:setup prompts are for the order of items to show in either side
:items:path are for styling the path
Comment
autoload -U colors && colors
zstyle ':prompt:grml:left:setup' items venv change-root path percent
zstyle ':prompt:grml:left:items:path' pre "%{${fg[green]}%} ( "
zstyle ':prompt:grml:left:items:path' post ") %{$reset_color%}"
zstyle ':prompt:grml:right:setup' items vcs rc sad-smiley
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr '!'
zstyle ':vcs_info:*' stagedstr '+'
zstyle ':vcs_info:git*' formats \
    "%{${fg[green]}%}[%{${fg[cyan]}%}%b%{${fg[yellow]}%}%m%u%c%{${fg[green]}%}]\
%{$reset_color%}"

function venv_prompt() {
    REPLY=${VIRTUAL_ENV+(${VIRTUAL_ENV:t})}
}
grml_theme_add_token venv -f venv_prompt '%F{magenta}' '%f'

# Aliases
alias ls="ls --color=auto --hyperlink=auto -v"

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

# To install a gnome extension using its UUID
function inst_ext() {
    dbus-send --session --print-reply --dest=org.gnome.Shell /org/gnome/Shell \
    org.gnome.Shell.Extensions.InstallRemoteExtension string:"$1"
}

# Initialize the magnificent app which corrects your previous console command
eval $(thefuck --alias)
