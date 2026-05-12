# dotfiles

Personal config, managed as a bare git repo in `$HOME` (no symlinks).
Pattern from [this HN comment](https://news.ycombinator.com/item?id=11070797).

## Setup on a new machine

```sh
# 1. Clone the bare repo into ~/.dotfiles
git clone --bare https://github.com/LadyMozzarella/dotfiles.git $HOME/.dotfiles

# 2. Define the alias (also lives in .zshrc, but needed right now)
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# 3. Don't show every untracked file in $HOME
dotfiles config --local status.showUntrackedFiles no

# 4. Back up anything already in $HOME that would be overwritten
mkdir -p ~/.dotfiles-backup
for f in .zshrc .gitconfig .gitignore_global; do
  [ -e "$HOME/$f" ] && mv "$HOME/$f" ~/.dotfiles-backup/
done

# 5. Check out the tracked files into $HOME
dotfiles checkout
```

## Per-machine config (NOT in this repo)

Create these by hand on each machine — they hold identity and work-only bits:

**`~/.gitconfig.local`** — git identity (loaded via `[include]` in `.gitconfig`)

```ini
[user]
    name = Your Name
    email = you@example.com
    signingkey = /Users/<you>/.ssh/id_ed25519.pub
[gpg]
    format = ssh
```

**`~/.zshrc.local`** — sourced from `.zshrc` if present. Put work tunnels,
`KUBECONFIG`, AWS profile overrides, etc. here.

**`~/.ssh/config`** — real bastion entries with instance IDs. Use
`~/.ssh/config.template` as a starting point. Do NOT commit this file.

## Migrate from another machine

Things to bring over separately (NOT via this repo):

- `~/.ssh/id_ed25519*` — transfer through 1Password / USB, never a public repo
- `~/.aws/`, `~/.config/op/`, `~/.config/gh/hosts.yml` — re-auth on the new machine
- `~/.gitconfig.local`, `~/.zshrc.local`, `~/.ssh/config` — see above

## Day-to-day

```sh
dotfiles status              # what's changed
dotfiles add ~/.zshrc        # stage a change
dotfiles commit -m "..."     # commit
dotfiles push                # push to GitHub
```
