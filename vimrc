"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""jm33_ng's VIMRC""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ==>> Disclaimer
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Tested on Kali Rolling 2017, works fine for me
" Supported languages:
"  - Go
"  - Python3
"  - Bash
"  - C
" This vimrc file might seem ugly, but it will work as long as
" you have installed all dependencies, for more info please go
" to https://github.com/w0rp/ale#standard-installation, you
" will know what to do
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ==>> VUNDLE
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" General dev
Plugin 'w0rp/ale' " general linter
" Plugin 'Valloric/YouCompleteMe' " general completer
Plugin 'majutsushi/tagbar' " tag list
Plugin 'scrooloose/nerdtree' " file explorer
Plugin 'jiangmiao/auto-pairs'
Plugin 'tomtom/tcomment_vim'

" Languages
Plugin 'fatih/vim-go'
" Plugin 'davidhalter/jedi-vim'
Plugin 'rust-lang/rust.vim'
Plugin 'PProvost/vim-ps1'

" Appearance
Plugin 'flazz/vim-colorschemes'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

" deoplete
"Plugin 'Shougo/deoplete.nvim'
"Plugin 'roxma/nvim-yarp'
"Plugin 'roxma/vim-hug-neovim-rpc'

" Not used anymore
"Plugin 'honza/vim-snippets'
"Plugin 'ctrlpvim/ctrlp.vim'
"Plugin 'vim-syntastic/syntastic'
"Plugin 'weekmonster/gofmt.vim'
"Plugin 'terryma/vim-multiple-cursors'
"Plugin 'chrisbra/csv.vim'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ==>> Comfortable editing
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set to auto read when a file is changed from the outside
set autoread

"Dismiss the start screen
set shortmess=atI

"Hightlight current line and column
set cursorline
set cursorcolumn
" Enable Elite mode, No ARRRROWWS!!!!
let g:elite_mode = 1
" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = ","
let g:mapleader = ","

" Fast saving
nmap <leader>w :w!<cr>
" Quit without saving
nmap <leader>q :q!<cr>
" Save and quit
nmap <leader>x :wq<cr>

" :W sudo saves the file
" (useful for handling the permission-denied error)
command W w !sudo tee % > /dev/null

" Hex edit
command XXD %!xxd

" Set paste
set pastetoggle=<F2>
" command P set paste
" command NP set nopaste

" Remove trailing whitespaces
command T %s/\s\+$//e


" Auto format C code using indent
au BufWritePost *.c :silent! execute "!indent -linux %" | redraw!
au BufWritePost *.ino :silent! execute "!indent -linux %" | redraw!

" Auto format Python code using indent
au BufWritePost *.py :silent! execute "!autopep8 --in-place --aggressive --aggressive %" | redraw!

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ==>> VIM user interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nu

" Set 7 lines to the cursor - when moving vertically using j/k
set so=7

" Turn on the WiLd menu
set wildmenu

" Ignore compiled files
set wildignore=*.o,*~,*.pyc
if has("win16") || has("win32")
else
    set wildignore+=.git\*,.hg\*,.svn\*
endif

"Always show current position
set ruler

" Height of the command bar
" set cmdheight=1

" A buffer becomes hidden when it is abandoned
set hid

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" In many terminal emulators the mouse works just fine, thus enable it.
"if has('mouse')
"  set mouse=a
"endif

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch

" Don't redraw while executing macros (good performance config)
set lazyredraw

" For regular expressions turn magic on
set magic

" Show matching brackets when text indicator is over them
set showmatch
" How many tenths of a second to blink when matching brackets
set mat=2

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" Add a bit extra margin to the left
set foldcolumn=1

set foldenable
set foldlevelstart=10
set foldnestmax=10
set foldmethod=syntax

" copy and paste
nnoremap Y "+y

" space open/closes folds
nnoremap <space> za

" move vertically by visual line
nnoremap j gj
nnoremap k gk

" move to beginning/end of line
nnoremap B ^
nnoremap E $

" $/^ doesn't do anything
nnoremap $ <nop>
nnoremap ^ <nop>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ==>> Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable syntax highlighting
syntax enable
syntax on

let g:rehash256 = 1
let g:molokai_original = 1
set background=dark
set t_Co=256

let base16colorspace=256
if (has("termguicolors"))
    set termguicolors
endif

try
    colorscheme material
catch
    colorscheme mango
endtry


" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" Use Unix as the standard file type
set ffs=unix,dos,mac

" Controls pop-up window color
highlight clear SpellBad
highlight SpellBad term=standout ctermfg=1 term=underline cterm=underline
highlight clear SpellCap
highlight SpellCap term=underline cterm=underline
highlight clear SpellRare
highlight SpellRare term=underline cterm=underline
highlight clear SpellLocal
highlight SpellLocal term=underline cterm=underline
highlight Pmenu ctermfg=7 ctermbg=234 guibg=#d0d0d0 guifg=#8a8a8a
highlight CursorColumn ctermbg=234
highlight Search cterm=NONE ctermfg=grey ctermbg=black guibg=#2a241a guifg=#8a8a8a



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ==>> Files, backups and undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn backup off, since most stuff is in SVN, git et.c anyway...
set nobackup
set nowb
set noswapfile



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ==>> Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use spaces instead of tabs
set expandtab

" Be smart when using tabs ;)
set smarttab

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4

" Linebreak on 500 characters
"set lbr
"set tw=80
set ai "Auto indent
set si "Smart indent
"set wrap "Wrap lines



""""""""""""""""""""""""""""""
" ==>> Status line
""""""""""""""""""""""""""""""
" Always show the status line
set laststatus=2
" Height of the command bar
set cmdheight=1




""""""""""""""""""""""""""""""
" ==>> Plugins
""""""""""""""""""""""""""""""


" YCM conf
let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/YouCompleteMe/third_party/ycmd/examples/.ycm_extra_conf.py'
let g:ycm_confirm_extra_conf = 0
let g:ycm_seed_identifiers_with_syntax = 1
let g:ycm_collect_identifiers_from_tags_files = 1
"let g:ycm_autoclose_preview_window_after_completion = 1
"let g:ycm_autoclose_preview_window_after_insertion = 1
set completeopt-=preview
let g:ycm_add_preview_to_completeopt = 0
" Hail Py3
let g:ycm_python_binary_path = 'python3'


" ALE linters
let g:airline#extensions#ale#enabled = 1
let g:ale_lint_delay = 500
let g:ale_open_list = 0
let g:ale_set_loclist = 0
let g:ale_lint_on_enter = 1

let g:ale_linters = {
\   'javascript': ['eslint'],
\   'c': ['clang'],
\   'python': ['pylint'],
\   'cpp': ['clang'],
\   'go': ['golint'],
\}

nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)
" if linter got annoying, you can the frq set to normal
"let g:ale_lint_on_text_changed = 'normal'
"let g:ale_set_quickfix = 1
"let g:ale_keep_list_window_open = 1


" Vim-Airline Configuration
let g:airline_theme = 'murmur'
let g:airline#extensions#tabline#enabled = 1
let g:hybrid_custom_term_colors = 1
let g:hybrid_reduced_contrast = 1
let g:airline_powerline_fonts = 1
let g:airline#extensions#whitespace#mixed_indent_algo = 2
let airline#extensions#c_like_langs = ['c', 'cpp', 'cuda', 'go', 'javascript', 'ld', 'php']
" for C files, disable Airline whitespace warning
au bufenter *.c :silent! call airline#extensions#whitespace#disable()
au bufenter *.ino :silent! call airline#extensions#whitespace#disable()

" rust.vim
let g:rustfmt_autosave = 1

" vim-go
" since we have ALE enabled, vim-go doesn't have to run lint here
"let g:go_metalinter_enabled = ['vet', 'golint', 'errcheck']
let g:go_highlight_operators = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1

" Tagbar
nmap <C-b> :TagbarToggle<CR>


" NerdTree

" Auto starts NerdTREE
" autocmd vimenter * NERDTree

" Toggle NerdTREE
map <C-z> :NERDTreeToggle<CR>

" Switch to next buffer
map <F10> :bn<CR>
"map <F5> :SyntasticCheck<CR>

" How can I close vim if the only window left open is a NERDTree?
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
