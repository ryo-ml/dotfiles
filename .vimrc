" Plain-vim config for machines without nvim (e.g. servers). Plugin-free,
" mirrors .config/nvim/lua/config/options.lua.

set nocompatible
filetype plugin indent on
syntax on

" Clipboard synchronization (only if this vim was built with it)
if has('clipboard')
    set clipboard=unnamed,unnamedplus
endif

" Appearance and Display
set number
set norelativenumber
set cursorline
if exists('+cursorlineopt')
    set cursorlineopt=number
endif
if has('termguicolors')
    set termguicolors
endif
set laststatus=2
set showcmd

" Indentation and Tabs
set expandtab
set shiftwidth=4
set tabstop=4
set smartindent
set autoindent

" Search
set ignorecase
set smartcase
set incsearch
set hlsearch
set wrapscan

" Command-line completion
set wildmenu
set wildmode=longest:full,full

" Behavior
set mouse=a
set backspace=indent,eol,start
set encoding=utf-8
set hidden
set ttimeoutlen=0

" Keep swap/undo/viminfo out of $HOME (XDG state dir)
let s:state = (empty($XDG_STATE_HOME) ? $HOME . '/.local/state' : $XDG_STATE_HOME) . '/vim'
for s:dir in ['swap', 'undo']
    if !isdirectory(s:state . '/' . s:dir)
        call mkdir(s:state . '/' . s:dir, 'p', 0700)
    endif
endfor
let &directory = s:state . '/swap//'
let &undodir = s:state . '/undo//'
set undofile
if exists('+viminfofile')
    let &viminfofile = s:state . '/viminfo'
endif
