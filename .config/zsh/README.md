# Zsh

```text
~/.config/zsh/
├── .zshrc               # sources conf.d/*.zsh in lexical order, then the local override
└── conf.d/
    ├── 00_env.zsh       # Homebrew, PATH, env vars
    ├── 01_history.zsh   # history file and options
    ├── 10_runtime.zsh   # nvm, conda (both lazy-loaded), uv, rbenv
    ├── 20_completion.zsh
    ├── 30_vim.zsh       # vi mode, cursor shape per mode
    └── 40_prompt.zsh
```

## Notes

- **Why it lives here** — the root `.zshenv` (→ `~/.zshenv`) sets
  `ZDOTDIR=~/.config/zsh`, so zsh reads `.zshrc` from this directory.
- **Load order** — the number prefix sets the order. `20_completion.zsh` must come after
  `10_runtime.zsh`: its nvm completion uses the lazy-load wrappers defined there.
- **Local override** — `~/.dotfiles-local/zshrc` is sourced last, if present. It sits
  outside the repo on purpose (see the root
  [README](../../README.md#local-overrides-not-tracked)).
