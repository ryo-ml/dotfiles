# nvm
export NVM_DIR="$HOME/.nvm"

if [ -s "$NVM_DIR/nvm.sh" ]; then
    _lazy_load_nvm() {
        # Remove all wrapper functions
        unset -f nvm node npm npx yarn pnpm 2>/dev/null

        # Early return if nvm.sh fails to load
        source "$NVM_DIR/nvm.sh" || {
            echo "[nvm] Failed to load nvm.sh" >&2
            return 1
        }
    }
    nvm()  { _lazy_load_nvm && nvm  "$@"; }
    node() { _lazy_load_nvm && node "$@"; }
    npm()  { _lazy_load_nvm && npm  "$@"; }
    npx()  { _lazy_load_nvm && npx  "$@"; }
    yarn() { _lazy_load_nvm && yarn "$@"; }
    pnpm() { _lazy_load_nvm && pnpm "$@"; }
fi

# conda
if [ -f "/opt/anaconda3/bin/conda" ]; then
    _load_conda() {
        # Remove wrapper function
        unset -f conda 2>/dev/null
        # Early return if conda fails to load
        eval "$('/opt/anaconda3/bin/conda' 'shell.zsh' 'hook' 2>/dev/null)" || {
            echo "[conda] Failed to load conda" >&2
            return 1
        }
    }
    conda() { _load_conda && conda "$@"; }
fi

# uv
[[ -f "$HOME/.local/bin/env" ]] && . "$HOME/.local/bin/env"

# ruby (rbenv)
if command -v rbenv > /dev/null; then
    eval "$(rbenv init - zsh)"
fi

