
# Configs and applications I use


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

`$ git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm`

After install copy tmux.conf to $HOME folder

`$ cp tmux.conf ~/.tmux.conf`

To Install the plugins start tmux and press

`Press Ctrl + A + I` 

## Oh my ZSH install

1. Install ZSH

```
$ sudo apt update
$ sudo apt install zsh
$ zsh --version
$ chsh -s $(which zsh)
$ echo $SHELL
```

2. Install oh my zsh

```
$ sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

3. Copy zsh file

```
$ cp zshrc ~/.zshrc
```

## Applications

### Gui

- [ ] [Brew](https://brew.sh/)
- [ ] [Kitty Terminal](https://sw.kovidgoyal.net/kitty/)
- [ ] [Postman](https://www.postman.com/)
- [ ] [Docker](https://www.docker.com/get-started/)
- [ ] [VSCode](https://code.visualstudio.com/)
- [ ] [Brave Browser](https://brave.com/)
- [ ] [Dbeaver](https://dbeaver.io/)
- [ ] [Authy](https://authy.com/)
- [ ]  [Birwarden](https://bitwarden.com/)
- [ ] [Obsidian note taking](https://obsidian.md/)
- [ ] [Raycast](https://www.raycast.com/)
- [ ] [Magnet tile windows](https://apps.apple.com/us/app/magnet/id441258766?mt=12)
- [ ] [Numi calculator](https://numi.app/)

### Terminal
- [ ] [nvm node manager](https://github.com/nvm-sh/nvm)
- [ ] [Neovim editor](https://neovim.io/)
- [ ] [Golang](https://go.dev/)
- [ ] [Rust](https://doc.rust-lang.org/cargo/getting-started/installation.html)
- [ ] [Bun.sh](https://bun.sh/)
- [ ] [pyenv](https://github.com/pyenv/pyenv)
- [ ] [pyenv-virtualenv](https://github.com/pyenv/pyenv-virtualenv)
- [ ] [miniconda](https://docs.anaconda.com/free/miniconda/index.html)
- [ ] [AWS cli v2](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- [ ] [Kubectl](https://kubernetes.io/docs/tasks/tools/#kubectl)



## Brew apps
```bash
brew install \
    tmux \ 
    zoxide \
    fzf \
    tree \
    tig \
    ripgrep \
    rsync \
    jq
```
