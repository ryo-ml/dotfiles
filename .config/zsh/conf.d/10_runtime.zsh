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

# conda (first install found; system-wide on macOS, usually under $HOME on Linux)
_conda_root=
for _dir in /opt/anaconda3 /opt/miniconda3 \
            "$HOME/anaconda3" "$HOME/miniconda3" "$HOME/miniforge3"; do
    if [[ -x $_dir/bin/conda ]]; then
        _conda_root="$_dir"
        break
    fi
done
unset _dir

if [[ -n $_conda_root ]]; then
    _load_conda() {
        # Remove wrapper function
        unset -f conda 2>/dev/null
        # Early return if conda fails to load
        eval "$("$_conda_root/bin/conda" shell.zsh hook 2>/dev/null)" || {
            echo "[conda] Failed to load conda" >&2
            return 1
        }
    }
    conda() { _load_conda && conda "$@"; }
else
    unset _conda_root
fi

# uv
[[ -f "$HOME/.local/bin/env" ]] && . "$HOME/.local/bin/env"

# ruby (rbenv)
if command -v rbenv > /dev/null; then
    eval "$(rbenv init - zsh)"
fi

