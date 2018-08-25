" VIM configuration, by Steffen Haug
" ==================================
"
" Designed for general use (programming, as well as typing) on
" 60% keyboards, such as the Pok3r, as well as macbook keyboards.
" It is compatible with ZSH on Linux and MacOS, using standard
" VIM, compiled with Python3 support.
"
" The config calls some functions which are defined at the bottom
" of the file, so this is where you need to look.
"
" I assume that the path of this file is
" "   $HOME/dotfiles/vim/rc.vim
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

" disable backwards-compat. with vi; this enables cool vim stuff.
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

" the unnamed register i the one pasting and yanking defaults to,
" so it makes sense to use the clipboard for this
set clipboard=unnamed

" vim uses the deprecated imp; make it shut up.
if has('python3')
  silent! python3 1
endif


" ZSH and Iterm2 'workarounds'
" ----------------------------

" ZSH uses escape for key-sequences, which causes a delay;
" this eliminates said delay.
set timeoutlen=1000 ttimeoutlen=0

" Enable the mouse; otherwise ZSH will let you scroll back
" past the vim window.
set mouse=a
nnoremap <MiddleMouse> <Nop>
vnoremap <MiddleMouse> <Nop>
inoremap <MiddleMouse> <Nop>


" Plugins
" -------
execute pathogen#infect()

" Plugin configs live in another file.
source $HOME/dotfiles/vim/plugins.vim

" Controls
" --------

" every time i hit :X it is a mistake and i intended to type :x
cabbrev X x
" yay for reinforcing bad habits!
cabbrev W w

" allow backspace across end of lines, and across the start of an insert.
set backspace=indent,eol,start

" incremental search
set incsearch

" search for current selection with / or ?
vnoremap <silent> / :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> ? :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>

" <leader>cs to clear the search.
" this is not the standard :noh solution; it actually clears the
" searct properly, so you cant search again by accident.
nnoremap <silent> <leader>cs :<C-u>call ClearSearch()<CR>
" navigate a search
nnoremap <silent> <leader>h Nzz
nnoremap <silent> <leader>l nzz

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

"scheme
set background=dark
colorscheme gruvbox

" Gui Vim
" -------
if has("gui_running")
    source $HOME/dotfiles/vim/gui.vim
endif

" User-defined Functions
" ======================
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

" Auto-generated junk
" ===================

" ## added by OPAM user-setup for vim / base ## 93ee63e278bdfc07d1139a748ed3fff2 ## you can edit, but keep this line
let s:opam_share_dir = system("opam config var share")
let s:opam_share_dir = substitute(s:opam_share_dir, '[\r\n]*$', '', '')

let s:opam_configuration = {}

function! OpamConfOcpIndent()
  execute "set rtp^=" . s:opam_share_dir . "/ocp-indent/vim"
endfunction
let s:opam_configuration['ocp-indent'] = function('OpamConfOcpIndent')

function! OpamConfOcpIndex()
  execute "set rtp+=" . s:opam_share_dir . "/ocp-index/vim"
endfunction
let s:opam_configuration['ocp-index'] = function('OpamConfOcpIndex')

function! OpamConfMerlin()
  let l:dir = s:opam_share_dir . "/merlin/vim"
  execute "set rtp+=" . l:dir
endfunction
let s:opam_configuration['merlin'] = function('OpamConfMerlin')

let s:opam_packages = ["ocp-indent", "ocp-index", "merlin"]
let s:opam_check_cmdline = ["opam list --installed --short --safe --color=never"] + s:opam_packages
let s:opam_available_tools = split(system(join(s:opam_check_cmdline)))
for tool in s:opam_packages
  " Respect package order (merlin should be after ocp-index)
  if count(s:opam_available_tools, tool) > 0
    call s:opam_configuration[tool]()
  endif
endfor
" ## end of OPAM user-setup addition for vim / base ## keep this line
" ## added by OPAM user-setup for vim / ocp-indent ## 288d2c332a2e8a17fb50a48ca45ff3e4 ## you can edit, but keep this line
if count(s:opam_available_tools,"ocp-indent") == 0
  source "$HOME/.opam/system/share/ocp-indent/vim/indent/ocaml.vim"
endif
