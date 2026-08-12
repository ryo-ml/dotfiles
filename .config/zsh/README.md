# Zsh Configuration

A modular Zsh setup organized under `~/.config/zsh`.

Built for a clean, maintainable, and scalable shell environment.

---

# Structure

```text
~/.config/zsh
├── .zshrc
├── README.md
└── conf.d
    ├── 00_env.zsh
    ├── 01_history.zsh
    ├── 10_runtime.zsh
    ├── 20_completion.zsh
    ├── 30_vim.zsh
    └── 40_prompt.zsh
```

`~/.zsh.local` (outside this directory, on purpose) is sourced by `.zshrc` if present — see
the root [README](../../README.md#local-overrides-not-tracked) for why it lives at `$HOME`
instead of here.

---

# Overview

## `.zshrc`

Main interactive shell configuration.

Loads all modular configs from `conf.d/`.


---

## `conf.d/`

Configuration files are separated by responsibility.

| File                | Purpose               |
| ------------------- | --------------------- |
| `00_env.zsh`        | Environment settings  |
| `01_history.zsh`    | History behavior      |
| `10_runtime.zsh`    | Runtime setup         |
| `20_completion.zsh` | Completion setup      |
| `30_vim.zsh`        | Vim-style keybindings |
| `40_prompt.zsh`     | Prompt customization  |

Files are loaded in lexical order.

---

# Installation

Handled by the repo's top-level `install.sh` — see the root
[README](../../README.md#setup). It symlinks this directory to `~/.config/zsh`
and `.zshenv` (which sets `ZDOTDIR="$HOME/.config/zsh"`) to `~/.zshenv`.

---

# Requirements

* zsh 5.x+
* macOS or Linux

---
