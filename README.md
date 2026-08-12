# dotfiles

Personal macOS dotfiles, managed as a set of symlinks into `~/.config` (XDG Base Directory) and `$HOME`.

## Setup

```bash
git clone git@github.com:ryo-ml/dotfiles.git ~/dotfiles && ~/dotfiles/install.sh --no-backup
```

`--no-backup` is fine for a fresh machine (there's nothing at the destinations to lose yet).
Migrating an existing machine with real configs already in place? Drop the flag — see
[What `install.sh` does](#what-installsh-does).

Then fill in the machine-specific bits `install.sh` created empty placeholders for:

- `~/.config/git/config.local` — set `name` / `email`
- `~/.zsh.local` — add any machine-specific env vars / secrets

Reload the shell to pick up `ZDOTDIR` and everything under it:

```bash
source ~/.zshenv && source "$ZDOTDIR/.zshrc"
```

### Optional: set zsh as your login shell

Not done by `install.sh` — it's a one-time, system-level change (may need `sudo` to register
the shell in `/etc/shells`, and prompts for your password), unlike everything else here which
is a safe, idempotent symlink. Run it yourself if your login shell isn't already zsh:

```bash
chsh -s "$(command -v zsh)"
```

## Structure

```
dotfiles/
├── .zshenv          # zsh bootstrap; symlinked to ~/.zshenv
├── install.sh       # symlinks everything below into place
└── .config/         # mirrors ~/.config 1:1
    ├── git/
    ├── nvim/
    ├── tmux/
    └── zsh/
```

Everything under `.config/` maps directly onto `~/.config/<name>`. `.zshenv` is the one
exception: zsh reads it from `$HOME` before `ZDOTDIR` is even set, so it can't live under
`.config/` like everything else.

## What `install.sh` does

- Symlinks each `.config/*` directory into `~/.config/*`, and `.zshenv` into `~/.zshenv`.
  Safe to re-run — an existing correct symlink is left alone, a stale symlink is just
  replaced (it holds no data of its own).
- If something real (not a symlink) already exists at the destination:
  - identical to what's in the repo → removed, no backup needed
  - different → moved to `<destination>.backup` first (overwriting any previous backup
    there), unless `--no-backup` was passed, in which case it's just discarded
- Creates empty placeholders for the [local override](#local-overrides-not-tracked) files
  if they don't exist yet — never overwrites existing ones.

## Local overrides (not tracked)

Some files hold machine-specific or secret values and are kept out of version control.
Two different mechanisms are used depending on how sensitive the content is:

| File                        | Mechanism                                            | Purpose                                        |
| ---------------------------- | ------------------------------------------------------ | ------------------------------------------------- |
| `~/.zsh.local`               | lives entirely outside `~/dotfiles`, sourced by `.zshrc` if present | env vars / API keys / anything sensitive |
| `.config/git/config.local`   | inside the repo but excluded via the whitelist `.gitignore`, included by `.config/git/config` | `[user] name`/`email` |

`git/config.local` only ever holds low-stakes identity info (it's published in every commit's
metadata anyway), so keeping it gitignored-but-physically-in-the-repo is fine. Anything with
real secret value (API tokens, credentials) belongs in `~/.zsh.local` instead — a plain
`.gitignore` entry only stops `git push`, it doesn't stop other tools (editors, AI agents,
backups, sync) that read the whole `~/dotfiles` folder from seeing the file. Living outside
the repo avoids that entirely.

## What's tracked

- **git** — global config, minus identity (see [Local overrides](#local-overrides-not-tracked))
- **nvim** — modular Lua config on lazy.nvim; see `.config/nvim/README.md`
- **tmux** — `tmux.conf`
- **zsh** — modular `.zshrc` sourcing `conf.d/*.zsh` in lexical order; see `.config/zsh/README.md`
