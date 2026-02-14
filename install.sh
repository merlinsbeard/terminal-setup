#!/bin/bash
set -euo pipefail

# =============================================================================
# terminal-setup install script
# Installs required apps and tools for this dotfiles setup
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALLED=0
SKIPPED=0
FAILED=0

# =============================================================================
# Catppuccin Mocha colors (truecolor)
# =============================================================================

if [[ -t 1 ]] && [[ -z "${NO_COLOR:-}" ]]; then
  GREEN='\033[38;2;166;227;161m'    # #a6e3a1
  RED='\033[38;2;243;139;168m'      # #f38ba8
  BLUE='\033[38;2;137;180;250m'     # #89b4fa
  MAUVE='\033[38;2;203;166;247m'    # #cba6f7
  DIM='\033[38;2;108;112;134m'      # #6c7086 overlay0
  SUB='\033[38;2;166;173;200m'      # #a6adc8 subtext0
  BOLD='\033[1m'
  RST='\033[0m'
else
  GREEN='' RED='' BLUE='' MAUVE='' DIM='' SUB='' BOLD='' RST=''
fi

# =============================================================================
# Output helpers
# =============================================================================

banner() {
  echo ""
  echo -e "  ${MAUVE}${BOLD}🍱 terminal-setup install${RST}"
  echo -e "  ${DIM}──────────────────────────${RST}"
  echo ""
}

success()  { printf "  ${GREEN}[✓]${RST} ${MAUVE}%-22s${RST} ${2}\n" "$1"; }
skip()     { printf "  ${DIM}[·]${RST} ${DIM}%-22s${RST} ${DIM}already installed${RST}\n" "$1"; }
fail_msg() { printf "  ${RED}[✗]${RST} ${MAUVE}%-22s${RST} ${2}\n" "$1"; }
step()     { printf "  ${BLUE}[→]${RST} ${MAUVE}%-22s${RST} ${2}\n" "$1"; }

summary() {
  echo ""
  echo -e "  ${DIM}──────────────────────────${RST}"
  local parts="🍱 ${GREEN}${INSTALLED} installed${RST}"
  [[ $SKIPPED -gt 0 ]] && parts="${parts} ${DIM}·${RST} ${DIM}${SKIPPED} already present${RST}"
  [[ $FAILED -gt 0 ]]  && parts="${parts} ${DIM}·${RST} ${RED}${FAILED} failed${RST}"
  echo -e "  ${parts}"
  echo ""
  echo -e "  ${SUB}next step: run ${MAUVE}./deploy.sh${RST}${SUB} to copy configs${RST}"
  echo ""
}

usage() {
  banner
  echo -e "  ${SUB}usage:${RST}"
  echo -e "    ./install.sh ${DIM}.................${RST} install all tools"
  echo -e "    ./install.sh ${MAUVE}--help${RST} ${DIM}.............${RST} show this help"
  echo ""
  echo -e "  ${SUB}installs:${RST}"
  echo -e "    ${DIM}homebrew, tmux, neovim, zoxide, fzf, fd, tree, tig,${RST}"
  echo -e "    ${DIM}ripgrep, rsync, jq, htop, oh-my-zsh, tpm, nvm, fonts${RST}"
  echo ""
}

# =============================================================================
# Install functions
# =============================================================================

install_homebrew() {
  if command -v brew &>/dev/null; then
    skip "homebrew"
    SKIPPED=$((SKIPPED + 1))
  else
    step "homebrew" "installing..."
    if /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; then
      # Add brew to path for this session
      eval "$(/opt/homebrew/bin/brew shellenv)" 2>/dev/null || true
      success "homebrew" "installed"
      INSTALLED=$((INSTALLED + 1))
    else
      fail_msg "homebrew" "failed to install"
      FAILED=$((FAILED + 1))
      echo -e "  ${RED}  brew is required for other installs, aborting${RST}"
      summary
      exit 1
    fi
  fi
}

install_brew_packages() {
  local packages=(
    tmux
    neovim
    zoxide
    fzf
    fd
    tree
    tig
    ripgrep
    rsync
    jq
    htop
    zsh-syntax-highlighting
    zsh-autosuggestions
  )

  for pkg in "${packages[@]}"; do
    if brew list "$pkg" &>/dev/null; then
      skip "$pkg"
      SKIPPED=$((SKIPPED + 1))
    else
      step "$pkg" "installing..."
      if brew install "$pkg" &>/dev/null; then
        success "$pkg" "installed"
        INSTALLED=$((INSTALLED + 1))
      else
        fail_msg "$pkg" "failed"
        FAILED=$((FAILED + 1))
      fi
    fi
  done
}

install_ohmyzsh() {
  if [[ -d "$HOME/.oh-my-zsh" ]]; then
    skip "oh-my-zsh"
    SKIPPED=$((SKIPPED + 1))
  else
    step "oh-my-zsh" "installing..."
    if sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended; then
      success "oh-my-zsh" "installed"
      INSTALLED=$((INSTALLED + 1))
    else
      fail_msg "oh-my-zsh" "failed"
      FAILED=$((FAILED + 1))
    fi
  fi
}

install_tpm() {
  local tpm_dir="$HOME/.tmux/plugins/tpm"
  if [[ -d "$tpm_dir" ]]; then
    skip "tpm"
    SKIPPED=$((SKIPPED + 1))
  else
    step "tpm" "cloning..."
    if git clone https://github.com/tmux-plugins/tpm "$tpm_dir" &>/dev/null; then
      success "tpm" "installed"
      INSTALLED=$((INSTALLED + 1))
    else
      fail_msg "tpm" "failed to clone"
      FAILED=$((FAILED + 1))
    fi
  fi
}

install_nvm() {
  if [[ -d "$HOME/.nvm" ]]; then
    skip "nvm"
    SKIPPED=$((SKIPPED + 1))
  else
    step "nvm" "installing..."
    if curl -fsSo- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash &>/dev/null; then
      success "nvm" "installed"
      INSTALLED=$((INSTALLED + 1))
    else
      fail_msg "nvm" "failed"
      FAILED=$((FAILED + 1))
    fi
  fi
}

install_fonts() {
  local font_dir="$HOME/Library/Fonts"
  local src_dir="$SCRIPT_DIR/fonts"

  if [[ ! -d "$src_dir" ]] || [[ -z "$(ls -A "$src_dir" 2>/dev/null)" ]]; then
    skip "fonts"
    SKIPPED=$((SKIPPED + 1))
    return
  fi

  local copied=0
  for font in "$src_dir"/*; do
    local name
    name="$(basename "$font")"
    if [[ ! -f "$font_dir/$name" ]]; then
      cp "$font" "$font_dir/"
      copied=$((copied + 1))
    fi
  done

  if [[ $copied -gt 0 ]]; then
    success "fonts" "${copied} font(s) copied to ~/Library/Fonts/"
    INSTALLED=$((INSTALLED + 1))
  else
    skip "fonts"
    SKIPPED=$((SKIPPED + 1))
  fi
}

# =============================================================================
# Main
# =============================================================================

for arg in "$@"; do
  case "$arg" in
    --help|-h)
      usage
      exit 0
      ;;
    *)
      echo -e "  ${RED}unknown option: ${arg}${RST}"
      echo -e "  ${DIM}run ./install.sh --help for usage${RST}"
      exit 1
      ;;
  esac
done

banner

install_homebrew
install_brew_packages
install_ohmyzsh
install_tpm
install_nvm
install_fonts

summary

[[ $FAILED -eq 0 ]] || exit 1
