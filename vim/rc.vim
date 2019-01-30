" VIM configuration, by Steffen Haug
" ==================================
"
" Designed for general use (programming, as well as typing) on
" 60% keyboards, such as the Pok3r, as well as macbook keyboards.
" That means i never assume Arrow keys or the F-row is available.
"
" I try to keep it compatible with both Zsh and Fish.
"
" I assume that the path of this file is
"   $HOME/dotfiles/vim/rc.vim
"
" because then i can work with absolute paths, and that is nicer.
"
" I use pathogen [0] to manage plugins.
"  - I use the default directory ($HOME/.vim/bundle)
"  - Config lives in $HOME/dotfiles/vim/plugins.vim
"  - Plugins with large configs may have their own files,
"    in which case it is sourced from plugins.vim


" General settings
" ----------------

" make sure we have a posix-compatible shell (fish is not)
set shell=sh

" disable backwards-compat. with vi; this turns on the cool stuff
set nocompatible

set history=250

filetype plugin on
filetype indent on

set autoindent

" this is what git is for.
set nobackup
set nowb
set noswapfile

let mapleader = ","
let maplocalleader = ";"

" the unnamed register is the one pasting and yanking def. to.
" so it makes sense to use the clipboard for this
set clipboard=unnamed

" vim uses the deprecated imp; make it shut up.
if has('python3')
  silent! python3 1
endif

" permanent undo
if !isdirectory($HOME."/.vim")
    call mkdir($HOME."/.vim", "", 0770)
endif
if !isdirectory($HOME."/.vim/vimdid")
    call mkdir($HOME."/.vim/vimdid", "", 0700)
endif
set undodir=~/.vim/vimdid
set undofile


" ZSH and Iterm2 'workarounds'
" ----------------------------

" ZSH uses escape for key-sequences, which causes a delay
set timeoutlen=1000 ttimeoutlen=0

" ZSH will let you scroll back past the vim window.
set mouse=a
nnoremap <MiddleMouse> <Nop>
vnoremap <MiddleMouse> <Nop>
inoremap <MiddleMouse> <Nop>


" Plugins
" -------
execute pathogen#infect()

" fzf
" ---
set rtp+=$HOME/.fzf

let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

let g:fzf_layout = { 'down': '~20%' }

" find file
nnoremap <silent> <leader>ff :<C-u>Files<CR>
" find buffer
nnoremap <silent> <leader>fb :<C-u>Buffers<CR>
" find line
nnoremap <silent> <leader>fl :<C-u>BLines<CR>

" airline
" -------
let g:airline_mode_map = {
            \ '__' : '-',
            \ 'n'  : 'N',
            \ 'i'  : 'I',
            \ 'R'  : 'R',
            \ 'c'  : 'C',
            \ 'v'  : 'V',
            \ 'V'  : 'V',
            \ '' : 'V',
            \ 's'  : 'S',
            \ 'S'  : 'S',
            \ '' : 'S',
            \ }
let g:airline_section_y = ''
let g:airline_section_z = '%l/%L, %c'
let g:airline#extensions#wordcount#enabled = 0

" this is not needed when airline is installed
set nomodeline
set noshowmode

" Controls
" --------

" every single time i hit :X it is a
" mistake and i intended to type :x
cabbrev X x
" same goes for :W
cabbrev W w

" allow backspace across end of lines, and across the start of an insert.
set backspace=indent,eol,start

" incremental search
set incsearch

" search for current selection with / or ?
vnoremap <silent> / :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> ? :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>

nnoremap <silent> <esc><esc> :<C-u>call ClearSearch()<CR>

" navigate a search centered vertically
nnoremap <silent> N Nzz
nnoremap <silent> n nzz

" Editing
" -------
set tabstop=4		" render tab-characters as 4 spaces
set shiftwidth=4	" indenting with > ("shifting") is 4 spaces
set expandtab		" convert inserted tabs to spaces

" User Interface
" --------------
set ruler
set number
set relativenumber
set wildmenu

set showcmd

" pretty colors
syntax on
set termguicolors

set t_Co=256

" highlight search results
set hlsearch

" color scheme
set background=dark
colorscheme gruvbox

" Gui Vim
" -------
if has("gui_running")
    source $HOME/dotfiles/vim/gui.vim
endif

" custom functions
" ================
function! VisualSelection(direction, extra_filter) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", "\\/.*'$^~[]")
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'gv'
        call CmdLine("Ack '" . l:pattern . "' " )
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

function! ClearSearch()
  let @/ = ""
  echo "Search Cleared"
endfunction

" Sources
" =======
" [0]: https://github.com/tpope/vim-pathogen
