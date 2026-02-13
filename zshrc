# =============================================================================
# ZSH Configuration - Optimized for fast startup (~150ms)
# =============================================================================

#zmodload zsh/zprof  # Uncomment to profile startup time

# =============================================================================
# Oh My Zsh Configuration
# =============================================================================

export ZSH="/Users/$USER/.oh-my-zsh"

ZSH_THEME="robbyrussell"

plugins=(
  # git     # ~150 aliases like ga, gc, gp - disabled for speed
  # docker  # docker aliases - disabled for speed
  # macos   # ofd, cdf, quick-look - disabled for speed
)

DISABLE_AUTO_UPDATE=true

# Set fpath before Oh My Zsh for custom completions
fpath=(~/.zsh "$HOMEBREW_PREFIX/share/zsh/site-functions" $fpath)

# Tell Oh My Zsh to use cached compinit
ZSH_COMPDUMP="${ZDOTDIR:-$HOME}/.zcompdump"

source $ZSH/oh-my-zsh.sh

# =============================================================================
# Aliases - Directory Navigation
# =============================================================================

alias codes='cd ~/Codes/'
alias aco='cd ~/Work/ACO/'
alias busu='cd ~/Codes/busu'
alias pr='cd ~/Work/prominence'
alias buko='cd ~/Work/bukobus'
alias xe='cd ~/Work/xendit'
alias pc='cd ~/Work/pc'
alias up='cd ../'

# =============================================================================
# Aliases - Tmux Sessions
# =============================================================================

alias xt='tmux new-session -A -s xendit -c Work/xendit/'
alias bt='tmux new-session -A -s buko -c Work/bukobus/'
alias ct='tmux new-session -A -s codes -c Codes'
alias zt='tmux new-session -A -s zip -c Work/zipph'

# =============================================================================
# Aliases - Git
# =============================================================================

alias gm='git stash && git pull --rebase origin master && git stash pop'
alias gmain='git stash && git pull --rebase origin main && git stash pop'

# =============================================================================
# Aliases - General
# =============================================================================

alias nd='npm run dev'
alias numi='numi-cli'
alias vim='nvim'
alias x='exit'
alias m='docker start mongo && docker start mongo-express'
alias sync-server="rsync -avzP --checksum caffeine@172.104.168.204:/home/caffeine/server-sync/ ~/Documents/server-sync"
alias claude-mem='bun "/Users/neb/.claude/plugins/marketplaces/thedotmack/plugin/scripts/worker-service.cjs"'

# =============================================================================
# NVM - Hybrid lazy-load + auto-switch on cd
# =============================================================================

export NVM_DIR="$HOME/.nvm"

# Load nvm fully (called on first use or when .nvmrc found)
_nvm_load() {
  unset -f _nvm_load nvm node npm npx yarn pnpm 2>/dev/null
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
}

# Wrapper functions for lazy loading
nvm() { _nvm_load; nvm "$@"; }
node() { _nvm_load; node "$@"; }
npm() { _nvm_load; npm "$@"; }
npx() { _nvm_load; npx "$@"; }
yarn() { _nvm_load; yarn "$@"; }
pnpm() { _nvm_load; pnpm "$@"; }

# Auto-switch node version on cd (loads nvm only when needed)
autoload -U add-zsh-hook
load-nvmrc() {
  # If nvm not loaded yet, only load if .nvmrc exists in current dir
  if ! type nvm_find_nvmrc &>/dev/null; then
    [[ -f .nvmrc ]] && _nvm_load || return
  fi

  local nvmrc_path
  nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version
    nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$(nvm version)" ]; then
      nvm use
    fi
  elif [ -n "$(PWD=$OLDPWD nvm_find_nvmrc)" ] && [ "$(nvm version)" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}
add-zsh-hook chpwd load-nvmrc

# =============================================================================
# Conda - Lazy-load (only initialize when first called)
# =============================================================================

conda() {
  unfunction conda mamba 2>/dev/null
  eval "$('/Users/neb/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
  if [ -f "/Users/neb/miniconda3/etc/profile.d/mamba.sh" ]; then
    . "/Users/neb/miniconda3/etc/profile.d/mamba.sh"
  fi
  conda "$@"
}
mamba() { conda; mamba "$@"; }

# =============================================================================
# Completions - Cached for performance
# =============================================================================

# kubectl completion (regenerate if binary is newer)
if [[ ! -f ~/.zsh/kubectl.zsh ]] || [[ $(which kubectl) -nt ~/.zsh/kubectl.zsh ]]; then
  kubectl completion zsh > ~/.zsh/kubectl.zsh
fi
source ~/.zsh/kubectl.zsh

# gh completion (regenerate if binary is newer)
if [[ ! -f ~/.zsh/gh.zsh ]] || [[ $(which gh) -nt ~/.zsh/gh.zsh ]]; then
  gh completion -s zsh > ~/.zsh/gh.zsh
fi
source ~/.zsh/gh.zsh

# uv completion
eval "$(uv generate-shell-completion zsh)"

# bun completions
[ -s "/Users/neb/.bun/_bun" ] && source "/Users/neb/.bun/_bun"

# =============================================================================
# FZF Configuration
# =============================================================================

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# =============================================================================
# Syntax Highlighting & Autosuggestions
# =============================================================================

source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# =============================================================================
# PATH Configuration
# =============================================================================

# Cargo/Rust
. "$HOME/.cargo/env"

export GO_DIR="$HOME/go/bin"
export FLUTTER_PATH="$HOME/flutter/bin"
export BUN_INSTALL="$HOME/.bun"

export PATH="$FLUTTER_PATH:$GO_DIR:$HOME/.poetry/bin:$PATH"
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH="$PATH:/Applications/love.app/Contents/MacOS/"
export PATH="/opt/homebrew/opt/postgresql@16/bin:$PATH"
export PATH="/Users/neb/.local/bin:/opt/homebrew/bin:$PATH"
export PATH="/Users/neb/.opencode/bin:$PATH"

# =============================================================================
# Other Settings
# =============================================================================

export HOMEBREW_NO_INSTALL_CLEANUP=TRUE
fpath=($fpath "/Users/neb/.zfunctions")

# =============================================================================
# Custom Functions
# =============================================================================

# Interactive git log viewer with fzf
function logg() {
  git log --all --decorate --graph | fzf --ansi --no-sort --reverse \
    --preview 'echo {} | grep -o "[a-f0-9]\{7\}" | head -1 | xargs -I % git show % --color=always' \
    --preview-window=right:50%:wrap --height 100% \
    --bind 'enter:execute(echo {} | grep -o "[a-f0-9]\{7\}" | head -1 | xargs -I % sh -c "git show % | nvim -c \"setlocal buftype=nofile bufhidden=wipe noswapfile nowrap\" -c \"nnoremap <buffer> q :q!<CR>\" -")' \
    --bind 'ctrl-e:execute(echo {} | grep -o "[a-f0-9]\{7\}" | head -1 | xargs -I % sh -c "gh browse %")'
}

#zprof  # Uncomment to see profiling results
