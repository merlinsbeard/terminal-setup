# Config and applications I use

## Fonts usage

1. [MonaSpace](https://monaspace.githubnext.com/)
2. [Jetbrains Mono Nerd Font](/fonts/)

## Neovim setup

1. [LazyVim](https://www.lazyvim.org/)

## VSCode Settings

1. `vscode-settings-user.json`

## TMUX

Install tmux-plugins first
Taken from [tmux-plugins](https://github.com/tmux-plugins/tpm)

```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

After install copy tmux.conf to $HOME folder

```bash
cp tmux.conf ~/.tmux.conf
```

To Install the plugins start tmux and press

`Press Ctrl + A + I`

## Oh my ZSH install

1. Install ZSH

```bash
sudo apt update
sudo apt install zsh
zsh --version
chsh -s $(which zsh)
echo $SHELL
```

1. Install oh my zsh

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

1. Copy zsh file

```bash
cp zshrc ~/.zshrc
```

## Aerospace

Window tiling for MacOS

```bash
cp aerospace.toml ~/.aerospace.toml
```

## Git

After installing `git`

```bash
cp gitconfig ~/.gitconfig
```

## Applications

### GUI

- [ ] [Brew](https://brew.sh/) MacOS package manager
- [ ] [Ghosttty](https://github.com/ghostty-org/ghostty) Terminal Emulator
- [ ] [Postman](https://www.postman.com/) API Client
- [ ] [Docker](https://www.docker.com/get-started/) Container Manager
- [ ] [VSCode](https://code.visualstudio.com/) Code Editor
- [ ] [Brave Browser](https://brave.com/) Browser
- [ ] [DBeaver](https://dbeaver.io/) Database Client
- [ ] [Bitwarden](https://bitwarden.com/) Password Manager
- [ ] [Obsidian note taking](https://obsidian.md/) Note Taking
- [ ] [Magnet tile windows](https://apps.apple.com/us/app/magnet/id441258766?mt=12) Window Manager
- [ ] [Numi calculator](https://numi.app/) Calculator

### Terminal

- [ ] [Github cli](https://cli.github.com/)
- [ ] [NVM node manager](https://github.com/nvm-sh/nvm) Node version manager
- [ ] [Neovim editor](https://neovim.io/) Terminal Editor
- [ ] [Golang](https://go.dev/)
- [ ] [Rust](https://doc.rust-lang.org/cargo/getting-started/installation.html)
- [ ] [Bun.sh](https://bun.sh/)
- [ ] Python

  - [ ] [UV python](https://github.com/astral-sh/uv)
  - [ ] [pyenv](https://github.com/pyenv/pyenv) (Optional)
  - [ ] [pyenv-virtualenv](https://github.com/pyenv/pyenv-virtualenv) (Optional)

    ```bash
    pyenv global 3.9.9
    ```

- [ ] [miniconda](https://docs.anaconda.com/free/miniconda/index.html) For jupyter

  ```bash
  # So it doesnt auto start
  # only start or activate when we need
  # this way it doesnt conflict with pyenv
  conda init
  conda config --set auto_activate_base false
  conda create -n <name> python=3.12
  conda install jupterlab
  ```

- [ ] [AWS cli v2](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) AWS cli
- [ ] [AWS vault for managing different aws](https://github.com/99designs/aws-vault) AWS account manager
- [ ] [Kubectl](https://kubernetes.io/docs/tasks/tools/#kubectl) Kubernetes Client
- [ ] [Aerospace](https://github.com/nikitabobko/AeroSpace) Window Tile Manager

## Brew apps

```bash
brew install \
    htop \
    tmux \
    zoxide \
    fzf \
    tree \
    tig \
    ripgrep \
    rsync \
    jq
```

[JankyBorders](https://github.com/FelixKratz/JankyBorders) for window highlight

```
brew tap FelixKratz/formulae
brew install borders
```

```

```

## Other Configurations for mac

To enable press and hold for vscode in mac

```bash
defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false         # For VS Code
defaults write com.microsoft.VSCodeInsiders ApplePressAndHoldEnabled -bool false # For VS Code Insider
defaults write com.visualstudio.code.oss ApplePressAndHoldEnabled -bool false    # For VS Codium
defaults delete -g ApplePressAndHoldEnabled
```
