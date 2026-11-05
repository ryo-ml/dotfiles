# Homebrew (Apple Silicon macOS, or Homebrew on Linux) — skipped if neither exists
for _brew_prefix in /opt/homebrew /home/linuxbrew/.linuxbrew; do
    [[ -d $_brew_prefix ]] || continue

    export HOMEBREW_PREFIX="$_brew_prefix"
    export HOMEBREW_CELLAR="$_brew_prefix/Cellar"
    if [[ -d $_brew_prefix/Homebrew ]]; then  # Linux keeps the repo in a subdirectory
        export HOMEBREW_REPOSITORY="$_brew_prefix/Homebrew"
    else
        export HOMEBREW_REPOSITORY="$_brew_prefix"
    fi

    typeset -U path
    [[ -d $_brew_prefix/bin  ]] && path=("$_brew_prefix/bin"  $path)
    [[ -d $_brew_prefix/sbin ]] && path=("$_brew_prefix/sbin" $path)

    typeset -U fpath
    [[ -d $_brew_prefix/share/zsh/site-functions ]] \
        && fpath=("$_brew_prefix/share/zsh/site-functions" $fpath)

    export MANPATH="$_brew_prefix/share/man${MANPATH:+:${MANPATH}}:"
    export INFOPATH="$_brew_prefix/share/info:${INFOPATH:-}"

    export HOMEBREW_NO_AUTO_UPDATE=1
    break
done
unset _brew_prefix


# X11 display (macOS / XQuartz). Not set on Linux, where ssh -X provides it.
[[ $OSTYPE == darwin* ]] && export DISPLAY="${DISPLAY:-:0}"


# Conda PS1 control
export CONDA_CHANGEPS1=false
