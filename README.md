# Terminal Setup

Dotfiles and configuration for my macOS development environment.

## Quick Start

Copy configs to their home directory locations:

```bash
cp aerospace.toml ~/.aerospace.toml
cp tmux.conf ~/.tmux.conf
cp zshrc ~/.zshrc
cp zshenv.example ~/.zshenv   # fill in your tokens, then: chmod 600 ~/.zshenv
cp gitconfig ~/.gitconfig
cp config.ghostty ~/.config/ghostty/config
cp -r nvim/ ~/.config/nvim/
```

## Fonts

1. [MonaSpace](https://monaspace.githubnext.com/)
2. [JetBrains Mono Nerd Font](/fonts/)

## Neovim

Uses [LazyVim](https://www.lazyvim.org/) framework. Config lives in `nvim/`.

## VSCode

User settings: `vscode-settings-user.json`

## Tmux

1. Install [tmux plugin manager](https://github.com/tmux-plugins/tpm):

   ```bash
   git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
   ```

2. Copy config and install plugins:

   ```bash
   cp tmux.conf ~/.tmux.conf
   ```

3. Start tmux, then press `Ctrl-a + I` to install plugins

## Zsh

1. Install [Oh My Zsh](https://ohmyz.sh/):

   ```bash
   sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
   ```

2. Copy config:

   ```bash
   cp zshrc ~/.zshrc
   ```

## AeroSpace

[AeroSpace](https://github.com/nikitabobko/AeroSpace) - tiling window manager for macOS

```bash
cp aerospace.toml ~/.aerospace.toml
```

## Git

```bash
cp gitconfig ~/.gitconfig
```

## Applications

### GUI

| App | Description |
|-----|-------------|
| [Brew](https://brew.sh/) | macOS package manager, install everything else through this |
| [Ghostty](https://github.com/ghostty-org/ghostty) | GPU-accelerated terminal emulator |
| [AeroSpace](https://github.com/nikitabobko/AeroSpace) | i3-like tiling window manager for macOS |
| [Bruno](https://www.usebruno.com/) | Offline-first API client, alternative to Postman |
| [Docker](https://www.docker.com/get-started/) | Containers for local dev and databases |
| [VSCode](https://code.visualstudio.com/) | Code editor for larger projects |
| [Brave Browser](https://brave.com/) | Privacy-focused Chromium browser |
| [Zen Browser](https://zen-browser.app/) | Firefox-based browser with vertical tabs |
| [DBeaver](https://dbeaver.io/) | Universal database GUI client |
| [Bitwarden](https://bitwarden.com/) | Open-source password manager |
| [Obsidian](https://obsidian.md/) | Markdown-based knowledge base |
| [Numi](https://numi.app/) | Text-based calculator with unit conversions |
| [Discord](https://discord.com/) | Community and team chat |
| [Telegram](https://telegram.org/) | Messaging |

### Terminal

| App | Description |
|-----|-------------|
| [GitHub CLI](https://cli.github.com/) | PRs, issues, and repos from the terminal |
| [NVM](https://github.com/nvm-sh/nvm) | Switch between Node.js versions per project |
| [Neovim](https://neovim.io/) | Terminal editor, configured with LazyVim |
| [Golang](https://go.dev/) | Go programming language and toolchain |
| [Rust](https://doc.rust-lang.org/cargo/getting-started/installation.html) | Rust language and Cargo package manager |
| [Bun](https://bun.sh/) | Fast JS/TS runtime, bundler, and package manager |
| [UV](https://github.com/astral-sh/uv) | Blazing fast Python package and project manager |
| [miniconda](https://docs.anaconda.com/free/miniconda/index.html) | Minimal Conda installer for Jupyter notebooks |
| [AWS CLI v2](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) | Manage AWS services from the terminal |
| [AWS Vault](https://github.com/99designs/aws-vault) | Securely store and switch AWS credentials |
| [kubectl](https://kubernetes.io/docs/tasks/tools/#kubectl) | CLI for managing Kubernetes clusters |

### Brew CLI tools

| Tool | Description |
|------|-------------|
| htop | Interactive process viewer |
| tmux | Terminal multiplexer for split panes and sessions |
| zoxide | Smarter `cd` that learns your most visited directories |
| fzf | Fuzzy finder for files, history, and anything piped to it |
| tree | Display directory structure as a tree |
| tig | Interactive Git log viewer in the terminal |
| ripgrep | Extremely fast recursive text search (`rg`) |
| rsync | Fast incremental file and directory sync |
| jq | Command-line JSON processor |
| [JankyBorders](https://github.com/FelixKratz/JankyBorders) | Highlight active window with colored borders |

```bash
brew install htop tmux zoxide fzf tree tig ripgrep rsync jq
```

JankyBorders requires a separate tap:

```bash
brew tap FelixKratz/formulae
brew install borders
```

## macOS Tweaks

Disable press-and-hold for VS Code (enables key repeat):

```bash
defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false
defaults write com.microsoft.VSCodeInsiders ApplePressAndHoldEnabled -bool false
defaults write com.visualstudio.code.oss ApplePressAndHoldEnabled -bool false
defaults delete -g ApplePressAndHoldEnabled
```

Drag windows from anywhere with `Ctrl + Cmd + click`:

```bash
defaults write -g NSWindowShouldDragOnGesture -bool true
```
