"""""""""
" Startup
set nocompatible        " Forget Vi...
set ttymouse=xterm2     " makes it work in everything
let s:is_windows = has("win16") || has("win32") || has("win64")
" TODO: fix this at some point; too much bother right now.
"if s:is_windows
"    silent call mkdir ($HOME.'/vimfiles', 'p')
"    silent call mkdir ($HOME.'/vimfiles/backup', 'p')
"    silent call mkdir ($HOME.'/vimfiles/temp', 'p')
"    set backupdir=~/vimfiles/backup " where to put backup files
"    set directory=~/vimfiles/temp   " directory to place swap files in
"else
"    let l:base = $HOME . '/.vim/'
"    let l:backup = l:base . 'backup/'
"    let l:temp = l:base . 'temp/'
"    if !isdirectory(l:base)
"        silent call mkdir ($HOME.'/.vim', 'p')
"    endif
"    if !isdirectory(l:backup)
"        silent call mkdir ($HOME.'/.vim/backup', 'p')
"    endif
"    if !isdirectory(l:temp)
"        silent call mkdir ($HOME.'/.vim/temp', 'p')
"    endif
"    set backupdir=l:backup "~/.vim/backup " where to put backup files
"    set directory=l:temp "~/.vim/temp   " directory to place swap files in
"endif
set encoding=utf-8

""""""""
" Colors
colorscheme evening
"colorscheme badwolf        " awesome colorscheme
set background=dark
syntax enable              " enable syntax processing
filetype indent plugin on  " enable file type detection
hi Normal guifg=lightgray guibg=black ctermfg=lightgray ctermbg=black
hi Visual guifg=black guibg=lightgray ctermfg=black ctermbg=lightgray
"hi Comment guifg=DarkGreen ctermfg=DarkGreen
"hi Constant guifg=LightRed ctermfg=LightRed
"hi Special guifg=LightRed ctermfg=LightRed gui=bold cterm=bold
"hi Identifier guifg=Cyan ctermfg=Cyan gui=bold cterm=bold
"hi Statement guifg=Blue ctermfg=Blue gui=bold cterm=bold
"hi PreProc guifg=Blue ctermfg=Blue
"hi Type guifg=LightGreen ctermfg=LightGreen
"hi Number guifg=LightRed ctermfg=LightRed
"hi String guifg=Yellow ctermfg=Yellow cterm=none

"""""""""""""""""
" Spaces and tabs
set tabstop=4       " number of visual spaces per TAB
set softtabstop=4   " number of spaces in tab when editing
set shiftwidth=4
set smarttab
set expandtab       " tabs are spaces
" Allow backspacing over autoindent, line breaks and start of insert action
set backspace=indent,eol,start
set autoindent      " keep current indentation if no special indentation is known
set smartindent     " try to be smart about indenting (C-style)

""""""""
" Typing
"set digraph         " Use Ctrl-H to type: e Ctrl-H : -> ë

"""""""""""
" UI config
set number               " show line numbers
"set cursorline           " highlight current line
filetype indent on       " load filetype-specific indent files
set wildmenu             " visual autocomplete for command menu
set lazyredraw           " redraw only when we need to.
set showmatch            " highlight matching [{()}]
set ruler                " Always show current position
set cmdheight=1          " Height of the command bar
" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500
set laststatus=2         " Always show the status line
set mouse=a              " Enable use of the mouse for all modes
" Move down as expected
inoremap <Down> <C-o>gj
" Move up as expected
inoremap <Up> <C-o>gk
" Format the status line
"set statusline=\ %F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l
set statusline=%F%m%r%h%w\ \ [%L][%{&ff}]%y[%p%%][%6l,%6v]
"              | | | | |      |   |      |  |     |    |
"              | | | | |      |   |      |  |     |    + current column
"              | | | | |      |   |      |  |     +-- current line
"              | | | | |      |   |      |  +-- current % into file
"              | | | | |      |   |      +-- current syntax in square brackets
"              | | | | |      |   +-- current fileformat
"              | | | | |      +-- number of lines
"              | | | | +-- preview flag in square brackets
"              | | | +-- help flag in square brackets
"              | | +-- readonly flag in square brackets
"              | +-- modified flag in square brackets
"              +-- full path to file in the buffer

if has('gui_running')
  set guioptions-=T  " no toolbar
  set columns=132 lines=50
  set guifont=Inconsolata\ 10
endif

""""""""
" Search
set incsearch           " search as characters are entered
set hlsearch            " highlight matches
set ignorecase          " Ignore case when searching
set smartcase           " ?
set nohlsearch          " turn off highlighting for searched expressions
" turn off search highlight
nnoremap <leader><space> :nohlsearch<CR>
" Center next search result
map N Nzz
map n nzz

"""""""""
" Buffers
function! SwitchToNextBuffer(incr)
    let help_buffer = (&filetype == 'help')
    let current = bufnr("%")
    let last = bufnr("$")
    let new = current + a:incr
    while 1
        if new != 0 && bufexists(new) && ((getbufvar(new, "&filetype") == 'help') == help_buffer)
            execute ":buffer ".new
            break
        else
            let new = new + a:incr
            if new < 1
                let new = last
            elseif new > last
                let new = 1
            endif
            if new == current
                break
            endif
        endif
    endwhile
endfunction
nnoremap <silent> <C-n> :call SwitchToNextBuffer(1)<CR>
nnoremap <silent> <C-p> :call SwitchToNextBuffer(-1)<CR>

""""""""
" Coding
autocmd FileType c,cpp setlocal equalprg=clang-format\ -style='{BasedOnStyle:\ google,\ ColumnLimit:\ 100}'

"""""""""""
" Shortcuts
set pastetoggle=<f11>        " hit f11 to paste
" tab switch
nnoremap <Tab> <ESC>:tabn<CR>
nnoremap <S-Tab> <ESC>:tabp<CR>

""""""""""""""""""
" Leader '\' shortcuts
" edit vimrc and reload vimrc bindings
nnoremap <leader>ev :vsp $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>
" Remove the Windows ^M - when the encodings gets messed up
noremap <Leader>m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

""""""""""
" Commands
" Remove any trailing whitespace that is in the file - Disabled because for
" Markdown this is significant whitespace...
"autocmd BufRead,BufWrite * if ! &bin | silent! %s/\s\+$//ge | endif
"
" Syntax highlight gradle as groovy files
au BufNewFile,BufRead *.gradle setf groovy

