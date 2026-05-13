# --- Completion ---
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# --- History ---
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt SHARE_HISTORY HIST_IGNORE_DUPS HIST_IGNORE_SPACE

# --- Plugins (brew --prefix resolves /opt/homebrew or /usr/local) ---
ZSH_PLUGIN_DIR="$(brew --prefix 2>/dev/null)/share"
[ -r "$ZSH_PLUGIN_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh" ] && \
  source "$ZSH_PLUGIN_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh"
[ -r "$ZSH_PLUGIN_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ] && \
  source "$ZSH_PLUGIN_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# --- Prompt ---
command -v starship >/dev/null && eval "$(starship init zsh)"

# --- Tools ---
command -v direnv >/dev/null && eval "$(direnv hook zsh)"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# --- Machine-specific config (work tunnels, KUBECONFIG, etc.) — not committed ---
[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"
