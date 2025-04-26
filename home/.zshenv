# vim:sw=4:ts=4:et:sts=4

# Setting PATH variable
typeset -U path
path=("$HOME/.local/bin" "$HOME/.local/share/gem/ruby/3.0.0/bin" "$HOME/.pyenv/bin" $path)

# Custom JVM options, exported later in the file
typeset -U jvm_opts
# Use system anti-aliasing font settings for
# better font rendering
jvm_opts=("-Dawt.useSystemAAFontSettings=on" "-Dswing.aatext=true" $jvm_opts)

# Setting xdg-dirs
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

export XDG_CONFIG_DIRS="/etc/xdg"
export XDG_DATA_DIRS="/usr/local/share:/usr/share"

# bundler env var to use xdg-dirs
export BUNDLER_USER_HOME="$XDG_DATA_HOME/bundle"
export BUNDLER_USER_CACHE="$XDG_CACHE_HOME/bundle"
export BUNDLER_USER_CONFIG="$XDG_CONFIG_HOME/bundle"
export BUNDLER_USER_PLUGIN="$BUNDLER_USER_HOME/plugin"

# cargo xdg-dirs
export CARGO_HOME="$XDG_DATA_HOME/cargo"

# gpg xdg-dirs
export GNUPGHOME="$XDG_DATA_HOME/gnupg"

# Make gpg work on wsl
export GPG_TTY=$(tty)

# gradle xdg-dirs
export GRADLE_USER_HOME="$XDG_CACHE_HOME/gradle"

# legacy GTK xdg-dirs
export GTK_RC_FILES="$XDG_CONFIG_HOME/gtk-1.0/gtkrc"
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc"

# java home
export JAVA_HOME="/usr/lib/jvm/default"

# java xdg-dirs
jvm_opts=("-Djava.utils.prefs.userRoot=\"$XDG_CONFIG_HOME/java\"" $jvm_opts)

# nuget xdg-dirs
export NUGET_PACKAGES="$XDG_CACHE_HOME/NuGetPackages"

# npm xdg-dirs
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"

# parallel xdg-dirs
export PARALLEL_HOME="$XDG_CONFIG_HOME/parallel"

# pyenv config
export PYENV_ROOT="$HOME/.pyenv"

# rustup xdg-dirs
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"

# Wayland specific stuff
if [ $XDG_SESSION_TYPE = "wayland" ]
then
    # Force AWT to handle reparenting windows on its own
    # for apps that do not support Wakefield
    # (Wayland in OpenJDK)
    export _JAVA_AWT_WM_NONREPARENTING=1

    # Enable Wakefield
    jvm_opts=("-Dawt.toolkit.name=WLToolkit" $jvm_opts)

    # Enable wayland support on Firefox
    export MOZ_ENABLE_WAYLAND=1
fi

# Concat jvm_opts array and export
export _JAVA_OPTIONS=${jvm_opts[*]}
