# dotfiles

Personal config, managed with [GNU Stow](https://www.gnu.org/software/stow/).
Each top-level directory is a stow "package" whose contents are symlinked into
`$HOME` preserving relative paths — e.g. `git/.gitconfig` → `~/.gitconfig`.

## Layout

```
git/
  .gitconfig
  .gitconfig-stell    # commit.gpgsign=true, pulled in for StellEngineering repos
  .gitignore_global
ssh/
  .ssh/
    config.template
starship/
  .config/
    starship.toml
zsh/
  .zshrc
```

## Setup on a new machine

```sh
# 1. Install stow + shell deps
brew install stow starship zsh-autosuggestions zsh-syntax-highlighting

# 2. Clone the repo
git clone https://github.com/LadyMozzarella/dotfiles.git ~/Developer/dotfiles
cd ~/Developer/dotfiles

# 3. Move aside anything already in $HOME that would conflict
#    (stow refuses to overwrite real files — it will tell you which ones)
for f in .zshrc .gitconfig .gitignore_global; do
  [ -e "$HOME/$f" ] && [ ! -L "$HOME/$f" ] && mv "$HOME/$f" "$HOME/$f.bak"
done

# 4. Apply every package
stow -t ~ git zsh ssh starship
```

That's it — `~/.zshrc`, `~/.gitconfig`, etc. are now symlinks back into this repo.

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

## Day-to-day

```sh
# Pull the latest from any machine
cd ~/Developer/dotfiles && git pull
# Symlinks already point into the repo, so the new content is live immediately.

# Edit a file — just edit it in place (e.g. ~/.zshrc); changes show up
# inside the repo automatically.
cd ~/Developer/dotfiles
git status
git add zsh/.zshrc
git commit -m "..."
git push

# Add a new package (e.g. tmux config)
mkdir -p tmux
mv ~/.tmux.conf tmux/.tmux.conf
stow -t ~ tmux
git add tmux && git commit -m "Add tmux package" && git push

# Remove a package's symlinks from $HOME (does not delete the files in the repo)
stow -t ~ -D zsh
```

## Migrate from another machine

Things to bring over separately (NOT via this repo):

- `~/.ssh/id_ed25519*` — transfer through 1Password / USB, never a public repo
- `~/.aws/`, `~/.config/op/`, `~/.config/gh/hosts.yml` — re-auth on the new machine
- `~/.gitconfig.local`, `~/.zshrc.local`, `~/.ssh/config` — see above
