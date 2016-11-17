syntax enable

set nocompatible 	" required
filetype off		"required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" Add all plugins here
Plugin 'mattn/emmet-vim'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'scrooloose/syntastic'
Plugin 'nvie/vim-flake8'
Plugin 'scrooloose/nerdtree'
Bundle 'jistr/vim-nerdtree-tabs'
Plugin 'majutsushi/tagbar'
Plugin 'tmhedberg/SimpylFold'
Plugin 'tpope/vim-fugitive'
Plugin 'altercation/vim-colors-solarized'
Plugin 'jnurmine/Zenburn'



" All of your Plugins must be added before the follow line
call vundle#end()
filetype plugin indent on


set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set autoindent
set fileformat=unix 
au BufNewFile,BufRead *.py
	\ set tabstop=4 |
	\ set softtabstop=4 |
	\ set shiftwidth=4 |
	\ set textwidth=79 |
	\ set expandtab |
	\ set autoindent |
	\ set fileformat=unix 

"au BufNewFile,BufRead *.js, *.html, *.css
"	\ set tabstop=2 |
"	\ set softtabstop=2 |
"	\ set shiftwidth=2 

" Split Panes Contrl uses Control + J,K,L,H
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Code Folding
"set foldmethod=indent
"set foldlevel=99
nnoremap <space> za

set encoding=utf-8

" Line Numbering
set nu

" Show statusline
set laststatus=2

" new
"
" Airline Theme

let python_highlight_all=1
syntax on

" Start NerdTreeTabs
let g:nerdtree_tabs_open_on_console_startup=1
