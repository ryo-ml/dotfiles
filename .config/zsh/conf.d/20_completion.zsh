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

# Set zcompcache location to XDG cache directory
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompcache"

