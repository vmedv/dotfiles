set nocompatible            " disable compatibility to old-time vi
set showmatch               " show matching 
set ignorecase              " case insensitive 
set hlsearch                " highlight search 
set incsearch               " incremental search
set tabstop=2               " number of columns occupied by a tab 
set softtabstop=2           " see multiple spaces as tabstops so <BS> does the right thing
set expandtab               " converts tabs to white space
set shiftwidth=2            " width for autoindents
set autoindent              " indent a new line the same amount as the line just typed
set number                  " add line numbers
set wildmode=longest,list   " get bash-like tab completions
set cc=100                  " set an 80 column border for good coding style
filetype plugin indent on   "allow auto-indenting depending on file type
syntax on                   " syntax highlighting
set clipboard+=unnamedplus   " using system clipboard
filetype plugin on
set cursorline              " highlight current cursorline
set ttyfast                 " Speed up scrolling in Vim
set termguicolors
set encoding=utf-8
set noshowmode

call plug#begin()

Plug 'jiangmiao/auto-pairs'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'windwp/nvim-autopairs'
Plug 'Shadorain/shadotheme'
Plug 'patstockwell/vim-monokai-tasty'
Plug 'ghifarit53/tokyonight-vim'
Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}
Plug 'ms-jpq/coq.artifacts', {'branch': 'artifacts'}
Plug 'itchyny/lightline.vim'
Plug 'srcery-colors/srcery-vim'
Plug 'lervag/vimtex'

call plug#end()


" let g:vim_monokai_tasty_italic = 1
" let g:airline_theme='monokai_tasty'                   " airline theme
" let g:lightline = { 'colorscheme': 'monokai_tasty' }  " lightline theme

" colorscheme vim-monokai-tasty
let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead'
      \ },
      \ }

colorscheme srcery
let g:srcery_italic = 1

" vimtex
filetype plugin indent on
syntax enable
let g:vimtex_view_general_viewer = 'okular'
let g:vimtex_view_method = 'zathura'

