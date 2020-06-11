# Contains my settings for VIM, TMUX, and ZSH

## VIM settings

1. [vim-plug](https://github.com/junegunn/vim-plug)


### vim-plug Installation
Taken from [https://github.com/junegunn/vim-plug](https://github.com/junegunn/vim-plug)


```
$ curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```


Copy the vim-plug.vimrc to home folder

` $ cp vim-plug ~/.vimrc `

Open vim then run ` :PlugInstall `

#### Dependencies

##### You Complete Me vim Plugin

```bash
# go to youcompletemefolder
$ cd ~/.vim/plugged/youcompleteme
# Install cmake
$ sudo apt-get install cmake
# run installation script
$ ./install.py # or ./install.py --all 
```

```
# Needed for tagbar
$ sudo apt-get install exuberant-ctags

# Syntastic error checker
$ sudo apt-get install flake8

```

------------------------------------

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

