#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

no_backup=false
[[ "${1:-}" == "--no-backup" ]] && no_backup=true

# Symlink $1 -> $2. A stale symlink at the destination is just removed (it
# holds no data of its own). A real file/directory is backed up first, unless
# it's already identical to $1 (nothing to lose) or --no-backup was passed.
# The backup path is overwritten.
link() {
    local src="$1" dst="$2"

    if [[ -L "$dst" && "$(readlink "$dst")" == "$src" ]]; then
        echo "OK      $dst"
        return
    fi

    if [[ -L "$dst" ]]; then
        rm "$dst"
    elif [[ -e "$dst" ]]; then
        if $no_backup || diff -rq "$src" "$dst" > /dev/null 2>&1; then
            rm -rf "$dst"
        else
            local backup="${dst}.backup"
            echo "BACKUP  $dst -> $backup"
            rm -rf "$backup"
            mv "$dst" "$backup"
        fi
    fi

    mkdir -p "$(dirname "$dst")"
    ln -s "$src" "$dst"
    echo "LINK    $dst -> $src"
}

# .zshenv must live directly under $HOME: zsh reads it before ZDOTDIR is set,
# so it can't be part of the .config/* loop below.
link "$DOTFILES_DIR/.zshenv" "$HOME/.zshenv"

# Everything under .config/ maps 1:1 onto ~/.config/*.
mkdir -p "$HOME/.config"
for src in "$DOTFILES_DIR"/.config/*/; do
    name="$(basename "$src")"
    link "${src%/}" "$HOME/.config/$name"
done

# Create $1 with content $2 only if nothing exists there yet. Never overwrites.
touch_if_missing() {
    local path="$1" content="$2"
    if [[ ! -e "$path" ]]; then
        printf '%s' "$content" > "$path"
        echo "CREATE  $path"
    fi
}

# Local override placeholders — machine-specific/secret, kept outside the
# dotfiles tree entirely (see README "Local overrides"). Only created if
# missing; existing content (e.g. a real git identity) is left untouched.
touch_if_missing "$HOME/.zsh.local" $'# Machine-specific env vars / secrets.\n'
touch_if_missing "$HOME/.config/git/config.local" $'[user]\n#\tname = \n#\temail = \n'

echo "Done."
