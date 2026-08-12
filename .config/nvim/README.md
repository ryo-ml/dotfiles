# My Neovim Configuration

A modular and optimized Neovim configuration written in Lua, powered by **lazy.nvim**.

## Concept
- **Modular**: Settings are separated into logical modules for easier maintenance.
- **Fast**: Leverages `lazy.nvim` for plugin lazy-loading, ensuring a lightning-fast startup.
- **Modern**: Fully written in Lua, following the latest Neovim best practices.

## Directory Structure

```text
~/.config/nvim/
├── init.lua                # Entry point; orchestrates module loading
├── lazy-lock.json          # lockfile (Managed by lazy.nvim)
└── lua/                    # Main configuration logic
    ├── config/             # Core settings (Independent of specific plugins)
    │   ├── lazy.lua        # Plugin manager bootstrap (lazy.nvim setup)
    │   └── options.lua     # Native Neovim options (clipboard, numbers, etc.)
    └── plugins/            # Plugin specifications (Auto-loaded by lazy.nvim)
        ├── colorscheme.lua # Theme selection and settings
        ├── dummy.lua       # Placeholder to prevent "No specs found" error
        ├── lsp.lua         # LSP (Language Server Protocol) configuration
        ├── pairs.lua       # Auto-closing brackets/quotes
        └── treesitter.lua  # Syntax highlighting and indentation
```
