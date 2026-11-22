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

5. (macOS only) Apply system preferences, then log out and back in

   ```bash
   ~/dotfiles/macos.sh
   ```

See [Setup notes](#setup-notes) for details on each step.

## Setup notes

- **Step 1** — Skip it if `echo $SHELL` already shows zsh (the macOS default). It's a
  one-time system change and may ask for your password, so `install.sh` doesn't do it.
- **Step 2** — Safe on a machine with existing configs too: anything in the way is moved to
  `~/.dotfiles-backup/` first (see [What `install.sh` does](#what-installsh-does)).
- **Step 3** — `gitconfig` takes your `[user] name` / `email`; `zshrc` takes machine-specific
  env vars and secrets (see [Local overrides](#local-overrides-not-tracked)).
- **Step 5** — Overwrites the current values of the settings it lists (see
  [macOS preferences](#macos-preferences)). Skip it on Linux; it exits without doing anything
  there anyway.

## Structure

```
dotfiles/
├── install.sh       # symlinks everything below into place
├── macos.sh         # macOS preferences via `defaults write` (run by hand)
├── .zshenv          # → ~/.zshenv (zsh reads it before ZDOTDIR is set)
├── .vimrc           # → ~/.vimrc (plugin-free vim for machines without nvim)
├── .claude/
│   └── settings.json  # → ~/.claude/settings.json (rest of ~/.claude is runtime state)
└── .config/         # each directory → ~/.config/<name>
    ├── git/         # global config + ignore; identity lives in ~/.dotfiles-local
    ├── latexmk/     # latexmkrc (LuaLaTeX, aux/PDF next to the .tex file)
    ├── nvim/        # Lua config on lazy.nvim — see .config/nvim/README.md
    ├── tmux/        # tmux.conf
    └── zsh/         # .zshrc + conf.d/*.zsh — see .config/zsh/README.md
```

## What `install.sh` does

- Symlinks `.zshenv`, `.vimrc`, `.claude/settings.json` and each `.config/*` directory.
  Safe to re-run: correct links are kept, stale links are replaced.
- If a real file already exists at a destination: identical → removed; different → moved
  to `~/.dotfiles-backup/<YYYYmmdd-HHMMSS>/<same path>` (mode `700`, one directory per run,
  never overwritten).
- Creates `~/.dotfiles-local/` (mode `700`) with empty placeholders (mode `600`). Never
  overwrites existing files.
- Creates `~/.ssh/config.d/`, `~/.ssh/keys/` and, if missing, a `~/.ssh/config` that just
  includes `config.d/*.conf`. Then normalizes permissions under `~/.ssh`: directories `700`,
  files `600`, `*.pub` `644`. Keys and host configs are never tracked or modified.

## macOS preferences

`macos.sh` applies the macOS settings changed from the defaults (keyboard repeat, text
input, trackpad, menu bar, Dock, Finder) with `defaults write`. `install.sh` doesn't run it;
run it by hand on a new Mac. It's safe to re-run, and does nothing on Linux. Log out and back
in afterwards for the keyboard and trackpad changes to take effect.

To find the key for a setting changed in System Settings, diff the defaults before and after
changing it:

```bash
defaults read > before.txt   # change the setting, then:
defaults read > after.txt && diff before.txt after.txt
```

## Local overrides (not tracked)

Machine-specific settings and secrets live outside the repo:

```
~/.dotfiles-local/
├── zshrc        # sourced at the end of .zshrc — env vars / API keys / secrets
└── gitconfig    # included by .config/git/config — [user] name / email
```

They stay outside `~/dotfiles` rather than gitignored inside it, so editors, AI agents,
backups and sync tools that read the repo folder never see them.
