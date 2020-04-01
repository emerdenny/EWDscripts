set nocompatible              " required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" add all your plugins here (note older versions of Vundle
" used Bundle instead of Plugin)

" Activate split windows
set splitbelow
set splitright
"split navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Enable code folding 
set foldmethod=indent
set foldlevel=99
" Enable folding
set foldmethod=indent
set foldlevel=99
" Cleaner folding
Plugin 'tmhedberg/SimpylFold'

" Indent to PEP 8 standards
au BufNewFile,BufRead *.py:
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set textwidth=79 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix
" Fix Auto Indent
Plugin 'vim-scripts/indentpython.vim'

Plugin 'flazz/vim-colorschemes'
colorscheme darkburn  

"define BadWhitespace before using in a match
highlight BadWhitespace ctermbg=red guibg=darkred
" Show bad whitespace
au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/

" Enforce UTF-8 encoding
set encoding=utf-8

" Syntax check on save
Plugin 'vim-syntastic/syntastic'
" PEP 8 check
Plugin 'nvie/vim-flake8'
" Syntax beautification
let python_highlight_all=1
syntax on

" Sidebar file tree
Plugin 'scrooloose/nerdtree'
" file tree autostart when vim starts with no file selected
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
" set ctrl-n hotkey to toggle file tree
map <C-n> :NERDTreeToggle<CR>
" nerdtree show hidden files by default
let NERDTreeShowHidden=1
" nerdtree ignore .pyc files
let NERDTreeIgnore=['\.pyc$', '\~$']

" Search function
Plugin 'kien/ctrlp.vim'

" Line numbering
set nu

" Status bar
Plugin 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
