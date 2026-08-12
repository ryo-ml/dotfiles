export HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"

if [[ ! -d "${HISTFILE%/*}" ]]; then
    mkdir -p "${HISTFILE%/*}"
fi

export HISTSIZE=100000
export SAVEHIST=100000

setopt EXTENDED_HISTORY

