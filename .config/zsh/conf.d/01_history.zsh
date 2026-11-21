HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"

if [[ ! -d "${HISTFILE%/*}" ]]; then
    mkdir -p "${HISTFILE%/*}"
fi

HISTSIZE=100000
SAVEHIST=100000

setopt INC_APPEND_HISTORY_TIME  # write each command to $HISTFILE when it finishes
setopt EXTENDED_HISTORY         # record timestamp and duration
setopt HIST_IGNORE_DUPS         # skip a command identical to the previous one
setopt HIST_REDUCE_BLANKS       # collapse superfluous blanks before saving
setopt HIST_IGNORE_SPACE        # don't save commands starting with a space
