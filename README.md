# dotfiles

Personal dotfiles for macOS and Linux servers, managed as symlinks into `~/.config`
(XDG Base Directory) and `$HOME`.

## Setup

1. Make zsh the login shell

   ```bash
   chsh -s "$(command -v zsh)"
   ```

2. Clone and install

   ```bash
   git clone https://github.com/ryo-ml/dotfiles.git ~/dotfiles && ~/dotfiles/install.sh
   ```

3. Fill in `~/.dotfiles-local/gitconfig` and `~/.dotfiles-local/zshrc`

4. Reload the shell

   ```bash
   exec zsh
   ```

See [Setup notes](#setup-notes) for details on each step.

## Setup notes

- **Step 1** — Skip it if `echo $SHELL` already shows zsh (the macOS default). It's a
  one-time system change and may ask for your password, so `install.sh` doesn't do it.
- **Step 2** — Safe on a machine with existing configs too: anything in the way is moved to
  `~/.dotfiles-backup/` first (see [What `install.sh` does](#what-installsh-does)).
- **Step 3** — `gitconfig` takes your `[user] name` / `email`; `zshrc` takes machine-specific
  env vars and secrets (see [Local overrides](#local-overrides-not-tracked)).

## Structure

```
dotfiles/
├── install.sh       # symlinks everything below into place
├── .zshenv          # → ~/.zshenv (zsh reads it before ZDOTDIR is set)
└── .config/         # each directory → ~/.config/<name>
    ├── git/         # global config; identity lives in ~/.dotfiles-local
    ├── nvim/        # Lua config on lazy.nvim — see .config/nvim/README.md
    ├── tmux/        # tmux.conf
    └── zsh/         # .zshrc + conf.d/*.zsh — see .config/zsh/README.md
```

## What `install.sh` does

- Symlinks `.zshenv` and each `.config/*` directory. Safe to re-run: correct links are
  kept, stale links are replaced.
- If a real file already exists at a destination: identical → removed; different → moved
  to `~/.dotfiles-backup/<YYYYmmdd-HHMMSS>/<same path>` (mode `700`, one directory per run,
  never overwritten).
- Creates `~/.dotfiles-local/` (mode `700`) with empty placeholders (mode `600`). Never
  overwrites existing files.
- Creates `~/.ssh/config.d/`, `~/.ssh/keys/` and, if missing, a `~/.ssh/config` that just
  includes `config.d/*.conf`. Then normalizes permissions under `~/.ssh`: directories `700`,
  files `600`, `*.pub` `644`. Keys and host configs are never tracked or modified.

## Local overrides (not tracked)

Machine-specific settings and secrets live outside the repo:

```
~/.dotfiles-local/
├── zshrc        # sourced at the end of .zshrc — env vars / API keys / secrets
└── gitconfig    # included by .config/git/config — [user] name / email
```

They stay outside `~/dotfiles` rather than gitignored inside it, so editors, AI agents,
backups and sync tools that read the repo folder never see them.
