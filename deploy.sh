#!/bin/bash
set -euo pipefail

# =============================================================================
# terminal-setup deploy script
# Copies config files to their home directory locations
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ALL_TARGETS=(zsh nvim tmux aerospace ghostty git vscode zshenv)
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y-%m-%d_%H%M%S)"
DO_BACKUP=true
DEPLOYED=0
SKIPPED=0
FAILED=0

# =============================================================================
# Catppuccin Mocha colors (truecolor)
# =============================================================================

if [[ -t 1 ]] && [[ -z "${NO_COLOR:-}" ]]; then
  GREEN='\033[38;2;166;227;161m'    # #a6e3a1
  RED='\033[38;2;243;139;168m'      # #f38ba8
  YELLOW='\033[38;2;249;226;175m'   # #f9e2af
  BLUE='\033[38;2;137;180;250m'     # #89b4fa
  MAUVE='\033[38;2;203;166;247m'    # #cba6f7
  DIM='\033[38;2;108;112;134m'      # #6c7086 overlay0
  SUB='\033[38;2;166;173;200m'      # #a6adc8 subtext0
  BOLD='\033[1m'
  RST='\033[0m'
else
  GREEN='' RED='' YELLOW='' BLUE='' MAUVE='' DIM='' SUB='' BOLD='' RST=''
fi

# =============================================================================
# Output helpers
# =============================================================================

banner() {
  echo ""
  echo -e "  ${MAUVE}${BOLD}🍱 terminal-setup deploy${RST}"
  echo -e "  ${DIM}─────────────────────────${RST}"
  echo ""
}

success() { printf "  ${GREEN}[✓]${RST} ${MAUVE}%-10s${RST} ${2}${BLUE} → ${RST}${3}\n" "$1"; }
warn()    { printf "  ${YELLOW}[⚠]${RST} ${MAUVE}%-10s${RST} ${2}\n" "$1"; }
fail()    { printf "  ${RED}[✗]${RST} ${MAUVE}%-10s${RST} ${2}\n" "$1"; }
info()    { echo -e "  ${DIM}${1}${RST}"; }

summary() {
  echo ""
  echo -e "  ${DIM}─────────────────────────${RST}"
  local parts="🍱 ${GREEN}${DEPLOYED} deployed${RST}"
  [[ $SKIPPED -gt 0 ]] && parts="${parts} ${DIM}·${RST} ${YELLOW}${SKIPPED} skipped${RST}"
  [[ $FAILED -gt 0 ]]  && parts="${parts} ${DIM}·${RST} ${RED}${FAILED} failed${RST}"
  echo -e "  ${parts}"
  echo ""
  echo -e "  ${SUB}reload tips:${RST}"
  echo -e "  ${SUB}  zsh        ${DIM}source ~/.zshrc${RST}"
  echo -e "  ${SUB}  tmux       ${DIM}Ctrl-a + I${RST}"
  echo -e "  ${SUB}  aerospace  ${DIM}alt-shift-; then esc${RST}"
  echo ""
}

usage() {
  banner
  echo -e "  ${SUB}usage:${RST}"
  echo -e "    ./deploy.sh ${DIM}...................${RST} deploy all configs"
  echo -e "    ./deploy.sh ${MAUVE}zsh nvim${RST} ${DIM}............${RST} deploy specific targets"
  echo -e "    ./deploy.sh ${MAUVE}--no-backup${RST} ${DIM}.........${RST} skip backup step"
  echo -e "    ./deploy.sh ${MAUVE}--list${RST} ${DIM}..............${RST} list available targets"
  echo -e "    ./deploy.sh ${MAUVE}--help${RST} ${DIM}..............${RST} show this help"
  echo ""
  echo -e "  ${SUB}targets:${RST}"
  echo -e "    ${MAUVE}zsh${RST}  ${MAUVE}nvim${RST}  ${MAUVE}tmux${RST}  ${MAUVE}aerospace${RST}  ${MAUVE}ghostty${RST}  ${MAUVE}git${RST}  ${MAUVE}vscode${RST}  ${MAUVE}zshenv${RST}"
  echo ""
  echo -e "  ${SUB}tip: run ${MAUVE}./install.sh${RST}${SUB} first to install required apps${RST}"
  echo ""
}

# =============================================================================
# App detection - warn if target app is not installed
# =============================================================================

check_app() {
  local target="$1"
  local cmd=""

  case "$target" in
    zsh)       cmd="zsh" ;;
    nvim)      cmd="nvim" ;;
    tmux)      cmd="tmux" ;;
    aerospace) cmd="aerospace" ;;
    git)       cmd="git" ;;
  esac

  # ghostty, vscode, zshenv don't need a command check
  if [[ -n "$cmd" ]] && ! command -v "$cmd" &>/dev/null; then
    printf "  ${YELLOW}[!]${RST} ${DIM}%-10s not found, config will be deployed anyway${RST}\n" "$cmd"
    return 1
  fi
  return 0
}

check_apps() {
  local targets=("$@")
  local missing=false

  for t in "${targets[@]}"; do
    check_app "$t" || missing=true
  done

  if $missing; then
    echo -e "  ${DIM}    run ${MAUVE}./install.sh${RST}${DIM} to install missing apps${RST}"
    echo ""
  fi
}

# =============================================================================
# Backup
# =============================================================================

backup_file() {
  local dest="$1"
  if [[ -e "$dest" ]]; then
    mkdir -p "$BACKUP_DIR"
    cp -r "$dest" "$BACKUP_DIR/"
    echo -e "    ${DIM}→ ${dest}${RST}"
  fi
}

do_backup() {
  local targets=("$@")
  local needs_backup=false

  # Check if any target has an existing file to back up
  for t in "${targets[@]}"; do
    case "$t" in
      zsh)       [[ -f "$HOME/.zshrc" ]] && needs_backup=true ;;
      nvim)      [[ -d "$HOME/.config/nvim" ]] && needs_backup=true ;;
      tmux)      [[ -f "$HOME/.tmux.conf" ]] && needs_backup=true ;;
      aerospace) [[ -f "$HOME/.aerospace.toml" ]] && needs_backup=true ;;
      ghostty)   [[ -f "$HOME/.config/ghostty/config" ]] && needs_backup=true ;;
      git)       [[ -f "$HOME/.gitconfig" ]] && needs_backup=true ;;
      vscode)    [[ -f "$HOME/Library/Application Support/Code/User/settings.json" ]] && needs_backup=true ;;
    esac
  done

  if ! $needs_backup; then
    return
  fi

  echo -e "  ${SUB}backing up to ${DIM}${BACKUP_DIR}/${RST}"

  for t in "${targets[@]}"; do
    case "$t" in
      zsh)       backup_file "$HOME/.zshrc" ;;
      nvim)      backup_file "$HOME/.config/nvim" ;;
      tmux)      backup_file "$HOME/.tmux.conf" ;;
      aerospace) backup_file "$HOME/.aerospace.toml" ;;
      ghostty)   backup_file "$HOME/.config/ghostty/config" ;;
      git)       backup_file "$HOME/.gitconfig" ;;
      vscode)    backup_file "$HOME/Library/Application Support/Code/User/settings.json" ;;
    esac
  done

  echo ""
}

# =============================================================================
# Deploy targets
# =============================================================================

deploy() {
  local target="$1"

  case "$target" in
    zsh)
      if cp "$SCRIPT_DIR/zshrc" "$HOME/.zshrc" 2>/dev/null; then
        success "zsh" "zshrc" "$HOME/.zshrc"
        DEPLOYED=$((DEPLOYED + 1))
      else
        fail "zsh" "failed to copy zshrc"
        FAILED=$((FAILED + 1))
      fi
      ;;

    nvim)
      mkdir -p "$HOME/.config"
      if cp -r "$SCRIPT_DIR/nvim/" "$HOME/.config/nvim/" 2>/dev/null; then
        success "nvim" "nvim/" "$HOME/.config/nvim/"
        DEPLOYED=$((DEPLOYED + 1))
      else
        fail "nvim" "failed to copy nvim/"
        FAILED=$((FAILED + 1))
      fi
      ;;

    tmux)
      if cp "$SCRIPT_DIR/tmux.conf" "$HOME/.tmux.conf" 2>/dev/null; then
        success "tmux" "tmux.conf" "$HOME/.tmux.conf"
        DEPLOYED=$((DEPLOYED + 1))
      else
        fail "tmux" "failed to copy tmux.conf"
        FAILED=$((FAILED + 1))
      fi
      ;;

    aerospace)
      if cp "$SCRIPT_DIR/aerospace.toml" "$HOME/.aerospace.toml" 2>/dev/null; then
        success "aerospace" "aerospace.toml" "$HOME/.aerospace.toml"
        DEPLOYED=$((DEPLOYED + 1))
      else
        fail "aerospace" "failed to copy aerospace.toml"
        FAILED=$((FAILED + 1))
      fi
      ;;

    ghostty)
      mkdir -p "$HOME/.config/ghostty"
      if cp "$SCRIPT_DIR/config.ghostty" "$HOME/.config/ghostty/config" 2>/dev/null; then
        success "ghostty" "config.ghostty" "$HOME/.config/ghostty/config"
        DEPLOYED=$((DEPLOYED + 1))
      else
        fail "ghostty" "failed to copy config.ghostty"
        FAILED=$((FAILED + 1))
      fi
      ;;

    git)
      if cp "$SCRIPT_DIR/gitconfig" "$HOME/.gitconfig" 2>/dev/null; then
        success "git" "gitconfig" "$HOME/.gitconfig"
        DEPLOYED=$((DEPLOYED + 1))
      else
        fail "git" "failed to copy gitconfig"
        FAILED=$((FAILED + 1))
      fi
      ;;

    vscode)
      local vscode_dir="$HOME/Library/Application Support/Code/User"
      mkdir -p "$vscode_dir"
      if cp "$SCRIPT_DIR/vscode-settings-user.json" "$vscode_dir/settings.json" 2>/dev/null; then
        success "vscode" "vscode-settings-user.json" "$HOME/Library/.../settings.json"
        DEPLOYED=$((DEPLOYED + 1))
      else
        fail "vscode" "failed to copy vscode settings"
        FAILED=$((FAILED + 1))
      fi
      ;;

    zshenv)
      if [[ -f "$HOME/.zshenv" ]]; then
        warn "zshenv" "skipped (${DIM}\$HOME/.zshenv already exists${RST}${YELLOW})${RST}"
        SKIPPED=$((SKIPPED + 1))
      else
        if cp "$SCRIPT_DIR/zshenv.example" "$HOME/.zshenv" 2>/dev/null; then
          chmod 600 "$HOME/.zshenv"
          success "zshenv" "zshenv.example" "$HOME/.zshenv"
          echo -e "    ${YELLOW}fill in your tokens and keep chmod 600${RST}"
          DEPLOYED=$((DEPLOYED + 1))
        else
          fail "zshenv" "failed to copy zshenv.example"
          FAILED=$((FAILED + 1))
        fi
      fi
      ;;

    *)
      fail "$target" "unknown target"
      FAILED=$((FAILED + 1))
      ;;
  esac
}

# =============================================================================
# Main
# =============================================================================

targets=()

for arg in "$@"; do
  case "$arg" in
    --help|-h)
      usage
      exit 0
      ;;
    --list|-l)
      echo ""
      echo -e "  ${SUB}available targets:${RST}"
      for t in "${ALL_TARGETS[@]}"; do
        echo -e "    ${MAUVE}${t}${RST}"
      done
      echo ""
      exit 0
      ;;
    --no-backup)
      DO_BACKUP=false
      ;;
    *)
      targets+=("$arg")
      ;;
  esac
done

# Default to all targets if none specified
if [[ ${#targets[@]} -eq 0 ]]; then
  targets=("${ALL_TARGETS[@]}")
fi

banner
check_apps "${targets[@]}"

if $DO_BACKUP; then
  do_backup "${targets[@]}"
fi

for t in "${targets[@]}"; do
  deploy "$t"
done

summary

[[ $FAILED -eq 0 ]] || exit 1
