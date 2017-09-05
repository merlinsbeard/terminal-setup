# Contains my settings for VIM, TMUX, and ZSH

## VIM settings
Has 2 options for package

1. [Vundle](https://github.com/VundleVim/Vundle.vim)
2. [vim-plug](https://github.com/junegunn/vim-plug)

### Vundle Installation

` $ git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim `

Copy the vundle.vimrc to home folder

` $ cp vundle.vimrc ~/.vimrc `

Open vim then run ` :PluginInstall `this will install all the plugins.


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

ty
