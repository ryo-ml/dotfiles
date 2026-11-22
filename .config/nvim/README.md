# Neovim

Lua config on [lazy.nvim](https://github.com/folke/lazy.nvim).

```text
~/.config/nvim/
├── init.lua                # loads config/options, then config/lazy
├── lazy-lock.json          # pinned plugin versions (tracked)
└── lua/
    ├── config/
    │   ├── lazy.lua        # bootstraps lazy.nvim, imports lua/plugins/
    │   └── options.lua     # editor options
    └── plugins/            # one plugin spec per file, loaded automatically
        ├── colorscheme.lua # tokyonight
        ├── lsp.lua         # mason + lspconfig + nvim-cmp
        ├── pairs.lua       # nvim-autopairs
        └── treesitter.lua  # parsers, highlighting, indentation
```

## Notes

- **Plugin versions** — `lazy-lock.json` is tracked, so `:Lazy restore` installs the same
  versions on another machine. Commit it after `:Lazy update`.
- **LSP servers** — Mason installs the servers listed in `lsp.lua` when the first file is opened; every
  installed server is enabled automatically.
- **Treesitter parsers** — compiling them needs the `tree-sitter` CLI. Where it's missing
  (e.g. servers), the install step is skipped and Neovim's bundled parsers are used.
- **Plain vim** — the root `.vimrc` mirrors `options.lua` for machines without nvim; keep
  the two in sync.
