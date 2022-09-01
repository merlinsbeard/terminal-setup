set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc
if !has('nvim')
set ttymouse=xterm3
endif


" Options
set clipboard=unnamedplus " Enables the clipboard between Vim/Neovim and other applications.
set completeopt=noinsert,menuone,noselect " Modifies the auto-complete menu to behave more like an IDE.
set cursorline " Highlights the current line in the editor
set hidden " Hide unused buffers
set autoindent " Indent a new line
set inccommand=split " Show replacements in a split screen
set mouse=a " Allow to use the mouse in the editor
set number " Shows the line numbers
set splitbelow splitright " Change the split screen behavior
set title " Show file title
set wildmenu " Show a more advance menu
set cc=90 " Show at 80 column a border for good code style
filetype plugin indent on   " Allow auto-indenting depending on file type
syntax on
" set spell " enable spell check (may need to download language package)
set ttyfast " Speed up scrolling in Vim

call plug#begin(has('nvim') ? stdpath('data') . '/plugged' : '~/.vim/plugged')
Plug 'morhetz/gruvbox'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'ryanoasis/vim-devicons'
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/nerdcommenter'
Plug 'sheerun/vim-polyglot'
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-fugitive'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'Yggdroot/indentLine'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

Plug 'kyazdani42/nvim-web-devicons' " for file icons
Plug 'kyazdani42/nvim-tree.lua'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'airblade/vim-gitgutter'
Plug 'github/copilot.vim'
call plug#end()

let NERDTreeQuitOnOpen=1
let g:bargreybars_auto=0


nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
let g:go_def_mapping_enabled = 0
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

nnoremap <C-n> :NvimTreeToggle<CR>
nnoremap <leader>r :NvimTreeRefresh<CR>
nnoremap <leader>n :NvimTreeFindFile<CR>

nnoremap <space> za

" ZFZ
nnoremap <C-P> :FZF <return>
nnoremap <C-t> :IndentLinesToggle <return>

colorscheme gruvbox
let g:nerdtree_tabs_open_on_console_startup=1


nnoremap <F9> :NERDTreeToggle<cr>
nnoremap <F4> :set hlsearch! hlsearch?<CR>
" Show all tabs:
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()   
let NERDTreeShowHidden=1
let g:indentLine_setColors = 0
let g:indentLine_char_list = ['|', '¦', '┆', '┊']
let g:indentLine_concealcursor = 'inc'
let g:indentLine_conceallevel = 2

let g:indentLine_enabled = 0
nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>
nnoremap <Leader>fc :lua require'telescope.builtin'.git_status{}<cr>
autocmd User TelescopePreviewerLoaded setlocal wrap
command! -nargs=0 Prettier :CocCommand prettier.forceFormatDocument

vmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

function! DoesFileExists()
	if filereadable("./format_disable")
		echo "elo"
	else
		autocmd BufWritePre *.tsx Prettier
		autocmd BufWritePre *.ts Prettier
	endif
endfunction

call DoesFileExists()

nnoremap <silent> <A-Up> :resize -1<CR>
nnoremap <silent> <A-Down> :resize +1<CR>

nnoremap <silent> <C-l> :vertical resize -1<CR>
nnoremap <silent> <C-h> :vertical resize +1<CR>
