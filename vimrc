" Vim configuration
" Minimal, secure, and functional setup

" Basic settings
set nocompatible
set encoding=utf-8
set fileencoding=utf-8

" Interface
set number
set ruler
set showcmd
set showmode
set laststatus=2
set wildmenu
set wildmode=list:longest

" Search
set hlsearch
set incsearch
set ignorecase
set smartcase

" Indentation
set autoindent
set smartindent
set tabstop=4
set shiftwidth=4
set expandtab
set softtabstop=4

" File handling
set autoread
set backup
set backupdir=~/.cache/vim/backup//
set directory=~/.cache/vim/swap//
set undofile
set undodir=~/.cache/vim/undo//

" Create backup directories if they don't exist
silent !mkdir -p $HOME/.cache/vim/{backup,swap,undo}

" Security
set modelines=0
set nomodeline

" Performance
set ttyfast
set lazyredraw

" Visual
set background=dark
syntax on
set cursorline

" Key mappings
let mapleader = ","
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>/ :nohlsearch<CR>

" File type detection
filetype plugin indent on

" Status line
set statusline=%F%m%r%h%w\ [%l,%c]\ [%L]\ %p%%
