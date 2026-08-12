# Source all modules
for file in "${ZDOTDIR:-$HOME/.config/zsh}"/conf.d/*.zsh; do
    [[ -f "$file" ]] && source "$file"
done

# Source secrets, if any (kept at $HOME, outside the dotfiles tree)
if [[ -f "$HOME/.zsh.local" ]]; then
    source "$HOME/.zsh.local"
fi
