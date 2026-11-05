#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if (( $# > 0 )); then
    echo "usage: $0  (takes no options)" >&2
    exit 1
fi

# Conflicting files are moved into one timestamped directory per run, keeping
# their path relative to $HOME. Created only if something needs backing up.
backup_root="$HOME/.dotfiles-backup"
backup_dir="$backup_root/$(date +%Y%m%d-%H%M%S)"

# Symlink $1 -> $2. A stale symlink at the destination is just removed (it
# holds no data of its own). A real file/directory is removed if identical to
# $1 (nothing to lose), otherwise moved into $backup_dir.
link() {
    local src="$1" dst="$2"

    if [[ -L "$dst" && "$(readlink "$dst")" == "$src" ]]; then
        echo "OK      $dst"
        return
    fi

    if [[ -L "$dst" ]]; then
        rm "$dst"
    elif [[ -e "$dst" ]]; then
        if diff -rq "$src" "$dst" > /dev/null 2>&1; then
            rm -rf "$dst"
        else
            # Private: old configs may contain secrets.
            local backup="$backup_dir/${dst#"$HOME"/}"
            (umask 077; mkdir -p "$(dirname "$backup")")
            chmod 700 "$backup_root"
            mv "$dst" "$backup"
            echo "BACKUP  $dst -> $backup"
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

# Local override placeholders — machine-specific/secret, kept in
# ~/.dotfiles-local, outside the repo (see README "Local overrides"). Only
# created if missing; existing content (e.g. a real git identity) is left
# untouched. Private to the user since it may hold secrets.
local_dir="$HOME/.dotfiles-local"
mkdir -p "$local_dir"
chmod 700 "$local_dir"
(
    umask 077
    touch_if_missing "$local_dir/zshrc" $'# Machine-specific env vars / secrets.\n'
    touch_if_missing "$local_dir/gitconfig" $'[user]\n#\tname = \n#\temail = \n'
)

# SSH skeleton — ~/.ssh stays a real directory. Keys, host configs and
# known_hosts are machine-specific: never tracked, never modified (only their
# permissions are normalized).
ssh_dir="$HOME/.ssh"
mkdir -p "$ssh_dir/config.d" "$ssh_dir/keys"
touch_if_missing "$ssh_dir/config" $'Include config.d/*.conf\n'
find "$ssh_dir" -type d -exec chmod 700 {} +
find "$ssh_dir" -type f ! -name '*.pub' -exec chmod 600 {} +
find "$ssh_dir" -type f -name '*.pub' -exec chmod 644 {} +

echo "Done."
