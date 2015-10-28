"""""""""
" Startup
set nocompatible		" Forget Vi...
set ttymouse=xterm2 " makes it work in everything
let s:is_windows = has("win16") || has("win32") || has("win64")
if s:is_windows
		set backupdir=~/vimfiles/backup " where to put backup files
		set directory=~/vimfiles/temp   " directory to place swap files in
else
		set backupdir=~/.vim/backup " where to put backup files
		set directory=~/.vim/temp   " directory to place swap files in
endif
set encoding=utf-8

""""""""
" Colors
colorscheme koehler
"colorscheme badwolf      " awesome colorscheme
set background=dark
syntax enable           	" enable syntax processing
filetype indent plugin on " enable file type detection

"""""""""""""""""
" Spaces and tabs
syntax enable       " enable syntax processing
set tabstop=4       " number of visual spaces per TAB
set softtabstop=4   " number of spaces in tab when editing
set expandtab       " tabs are spaces
set ai 							" Auto indent
set si 							" Smart indent
" Allow backspacing over autoindent, line breaks and start of insert action
set backspace=indent,eol,start
set autoindent			" keep current indentation if no special indentation is known
set nostartofline

"""""""""""
" UI config
set number              " show line numbers
set cursorline          " highlight current line
filetype indent on      " load filetype-specific indent files
set wildmenu            " visual autocomplete for command menu
set lazyredraw          " redraw only when we need to.
set showmatch           " highlight matching [{()}]
set ruler							  " Always show current position
set cmdheight=2					" Height of the command bar
" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500
set laststatus=2				" Always show the status line
set mouse=a							" Enable use of the mouse for all modes
inoremap <Down> <C-o>gj	" Move down as expected
inoremap <Up> <C-o>gk 	" Move up as expected
" Format the status line
"set statusline=\ %F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l
set statusline=%F%m%r%h%w[%L][%{&ff}]%y[%p%%][%6l,%6v]
"              | | | | |  |   |      |  |     |    |
"              | | | | |  |   |      |  |     |    + current column
"              | | | | |  |   |      |  |     +-- current line
"              | | | | |  |   |      |  +-- current % into file
"              | | | | |  |   |      +-- current syntax in square brackets
"              | | | | |  |   +-- current fileformat
"              | | | | |  +-- number of lines
"              | | | | +-- preview flag in square brackets
"              | | | +-- help flag in square brackets
"              | | +-- readonly flag in square brackets
"              | +-- rodified flag in square brackets
"              +-- full path to file in the buffer

if has('gui_running')
  set guioptions-=T  " no toolbar
	set columns=132 lines=50
	set guifont=Consolas:h10
endif

""""""""
" Search
set incsearch           " search as characters are entered
set hlsearch            " highlight matches
set ignorecase				  " Ignore case when searching
nnoremap <leader><space> :nohlsearch<CR> " turn off search highlight
map N Nzz								" Center next search result
map n nzz								" Center next search result

""""""""""""""""""
" Leader shortcuts
" edit vimrc and reload vimrc bindings
nnoremap <leader>ev :vsp $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>
" Remove the Windows ^M - when the encodings gets messed up
noremap <Leader>m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

"""""""""""
" Shortcuts
set pastetoggle=<f11>		" hit f11 to paste
" tab switch
nnoremap <Tab> <ESC>:tabn<CR>
nnoremap <S-Tab> <ESC>:tabp<CR>

""""""""""
" Commands
" Remove any trailing whitespace that is in the file
autocmd BufRead,BufWrite * if ! &bin | silent! %s/\s\+$//ge | endif
