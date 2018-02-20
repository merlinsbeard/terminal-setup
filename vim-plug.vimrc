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
" Theme
Plug 'altercation/vim-colors-solarized'
Plug 'jnurmine/Zenburn'
Plug 'sickill/vim-monokai'
Plug 'chriskempson/base16-vim'
Plug 'mattn/emmet-vim'
" Git plugins
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'junegunn/gv.vim'
" Plugin for markdown
Plug 'gabrielelana/vim-markdown'
" Airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'junegunn/seoul256.vim'
" Thrift syntax highlighting
Plug 'solarnz/thrift.vim'
" Syntax autocomplete
Plug 'valloric/youcompleteme'
" better whitespace
Plug 'ntpeters/vim-better-whitespace'
Plug 'nvie/vim-flake8'
Plug 'junegunn/vim-github-dashboard'
Plug 'junegunn/vim-emoji'
" vim-tmux-navigator
Plug 'christoomey/vim-tmux-navigator'
" Distraction Free
Plug 'junegunn/goyo.vim'
" Limelight highlights the focus block code
Plug 'junegunn/limelight.vim'
" Game
Plug 'johngrib/vim-game-code-break'

Plug 'NLKNguyen/papercolor-theme'

" Vim startify
Plug 'mhinz/vim-startify'

Plug 'tpope/vim-vinegar'

" Javascripts
Plug 'pangloss/vim-javascript'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'mxw/vim-jsx'
Plug 'w0rp/ale'

" Indent
Plug 'Yggdroot/indentLine'

call plug#end()

set autoread
set ruler
set hid
set foldcolumn=1
set noswapfile

set number
au BufNewFile,BufRead *.py
	\ set tabstop=4 |
	\ set softtabstop=4 |
	\ set shiftwidth=4 |
	\ set textwidth=79 |
	\ set expandtab |
	\ set autoindent |
	\ set fileformat=unix


autocmd filetype javascript set sw=2 ts=2 expandtab
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
"set nu

" Show statusline
set laststatus=2

" new
"
" Airline Theme
let g:airline_powerline_fonts=1
let g:airline_theme='distinguished'
let g:airline#extensions#tabline#enabled=1

map <S-h> :bprev<CR>
map <S-l> :bnext<CR>


let python_highlight_all=1
syntax on

" Start NerdTreeTabs
let g:nerdtree_tabs_open_on_console_startup=1
"colorscheme zenburn
" colorscheme seoul256
colorscheme PaperColor
let g:NERDTreeDirArrow=0

" Keybinds
nnoremap <F9> :NERDTreeToggle<cr>
nnoremap <F10> :TagbarToggle<cr>
nnoremap <F4> :set hlsearch! hlsearch?<CR>
" flake
autocmd FileType python map <buffer> <F3> :call Flake8()<cr>

set background=dark
" Transparency
hi Normal ctermbg=none
highlight NonText ctermbg=none

" Github dashboard settings
let g:github_dashboard = {'username':'merlinsbeard', 'password': '$GITHUB_PASSWORD'}

" Limelight auto on in Goyo mode
autocmd! User GoyoEnter Limelight
autocmd! User GoyoLeave Limelight!

" Javascript Configuration
"let g:vim_jsx_pretty_colorful_config = 1 " default 0
"let g:syntastic_javascript_checkers = ['eslint']
"let g:jsx_ext_required = 0 " Allow JSX in normal JS files

" Indent options
let g:indentLine_setColors = 0
let g:indentLine_char = '┆'
