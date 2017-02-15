call plug#begin('~/.vim/plugged')
" Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
Plug 'junegunn/vim-easy-align'

" Any valid git URL is allowed
Plug 'https://github.com/junegunn/vim-github-dashboard.git'

" Multiple Plug commands can be written in a single line using | separators
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'

" On-demand loading
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'tpope/vim-fireplace', { 'for': 'clojure' }


" Plugin outside ~/.vim/plugged with post-update hook
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

Plug 'junegunn/fzf.vim'

Plug 'jistr/vim-nerdtree-tabs'
Plug 'majutsushi/tagbar'
Plug 'tmhedberg/SimpylFold'
Plug 'tpope/vim-fugitive'
Plug 'altercation/vim-colors-solarized'
Plug 'jnurmine/Zenburn'
Plug 'sickill/vim-monokai'
Plug 'mattn/emmet-vim'

call plug#end()

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

" ZFZ
nnoremap <C-P> :FZF <return>

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
colorscheme zenburn
let g:NERDTreeDirArrow=0

