# Source all modules
for file in "${ZDOTDIR:-$HOME/.config/zsh}"/conf.d/*.zsh; do
    [[ -f "$file" ]] && source "$file"
done

# Source machine-specific settings / secrets, if any (kept outside the repo)
if [[ -f "$HOME/.dotfiles-local/zshrc" ]]; then
    source "$HOME/.dotfiles-local/zshrc"
fi
