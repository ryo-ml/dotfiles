# Docker completion
FPATH="$HOME/.docker/completions:$FPATH"

# Set zcompdump location to XDG cache directory
ZSH_COMPDUMP="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump-$ZSH_VERSION"

if [[ ! -d "${ZSH_COMPDUMP%/*}" ]]; then
    mkdir -p "${ZSH_COMPDUMP%/*}"
fi

autoload -Uz compinit
compinit -d "$ZSH_COMPDUMP"

# uv / uvx completion (must run after compinit)
if (( $+commands[uv] )); then
    eval "$(uv generate-shell-completion zsh)"
fi
if (( $+commands[uvx] )); then
    eval "$(uvx --generate-shell-completion zsh)"
fi

# npm / nvm completion. The lazy nvm wrappers (10_runtime.zsh) hide the real
# npm and nvm's helper functions until first use, so load nvm on first Tab.
if (( $+functions[_lazy_load_nvm] )); then
    _ensure_nvm_loaded() {
        (( $+functions[nvm_ls] )) && return
        # Hide the completion system's special $PREFIX (the word being completed):
        # nvm.sh aborts when PREFIX is set, leaving npm unavailable.
        () { local -h PREFIX; unset PREFIX; _lazy_load_nvm; } >/dev/null 2>&1
    }

    # Load npm's own completion script on first Tab. With bashcompinit (below)
    # it registers itself via `complete`, so call whatever it registered.
    _npm_lazy() {
        _ensure_nvm_loaded
        (( $+commands[npm] )) || return 1
        eval "$(NPM_CONFIG_UPDATE_NOTIFIER=false npm completion)"
        functions[_npm_completion]="
            local -x NPM_CONFIG_UPDATE_NOTIFIER=false
            ${functions[_npm_completion]}"
        ${=_comps[npm]} "$@"
    }
    compdef _npm_lazy npm

    # nvm ships a bash completion script; run it through bashcompinit
    if [[ -s "$NVM_DIR/bash_completion" ]]; then
        autoload -Uz bashcompinit && bashcompinit
        source "$NVM_DIR/bash_completion"
        # `complete` registered e.g. "_bash_complete -o default -F __nvm"
        _nvm_bash_completer=${_comps[nvm]}
        _nvm_lazy() {
            _ensure_nvm_loaded
            ${=_nvm_bash_completer} "$@"
        }
        compdef _nvm_lazy nvm
    fi
fi

# Set zcompcache location to XDG cache directory
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompcache"
