# Homebrew
[[ -d /opt/homebrew ]] || return 0  # Run only on Apple Silicon

export HOMEBREW_PREFIX="/opt/homebrew"
export HOMEBREW_CELLAR="/opt/homebrew/Cellar"
export HOMEBREW_REPOSITORY="/opt/homebrew"

typeset -U path
[[ -d /opt/homebrew/bin  ]] && path=(/opt/homebrew/bin  $path)
[[ -d /opt/homebrew/sbin ]] && path=(/opt/homebrew/sbin $path)

typeset -U fpath
[[ -d /opt/homebrew/share/zsh/site-functions ]] \
    && fpath=(/opt/homebrew/share/zsh/site-functions $fpath)

export MANPATH="/opt/homebrew/share/man${MANPATH:+:${MANPATH}}:"
export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}"

export HOMEBREW_NO_AUTO_UPDATE=1


# X11 display
export DISPLAY=:0


# Conda PS1 control
export CONDA_CHANGEPS1=false

