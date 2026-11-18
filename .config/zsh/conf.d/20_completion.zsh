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

# npm completion. The lazy nvm wrappers (10_runtime.zsh) hide the real npm
# until first use, so load nvm on first Tab.
if (( $+functions[_lazy_load_nvm] )); then
    _ensure_nvm_loaded() {
        (( $+functions[nvm_ls] )) && return
        # Hide the completion system's special $PREFIX (the word being completed):
        # nvm.sh aborts when PREFIX is set, leaving npm unavailable.
        () { local -h PREFIX; unset PREFIX; _lazy_load_nvm; } >/dev/null 2>&1
    }

    # zsh's bundled _npm requires the real npm on PATH
    _npm_lazy() {
        _ensure_nvm_loaded
        _npm "$@"
    }
    compdef _npm_lazy npm
fi

# Set zcompcache location to XDG cache directory
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompcache"
