" For package management using git submodules:
" https://shapeshed.com/vim-packages/

"##################################################################
" General
"##################################################################


" Sets how many lines of history VIM has to remember
set history=500

" Enable filetype plugins
filetype plugin on
filetype indent on

" Set to auto read when a file is changed from the outside
set autoread
au FocusGained,BufEnter * checktime

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = ","

" Fast saving
nmap <leader>w :w!<cr>

" :W sudo saves the file 
" (useful for handling the permission-denied error)
command! W execute 'w !sudo tee % > /dev/null' <bar> edit!



set expandtab
set shiftwidth=2
set softtabstop=2
set number

"##################################################################
" Theme
"##################################################################
"" https://github.com/tomasr/molokai
colorscheme molokai
set background=dark
let g:molokai_original = 0
" let g:rehash256 = 1
" Set background as black
highlight Normal ctermbg=black 

source /usr/share/doc/fzf/examples/plugin/fzf.vim

" map <C-o> :NERDTreeToggle<CR>
" nmap <F8> :TagbarToggle<CR>

map <C-A> <Home>
map <C-E> <End>
inoremap <C-A> <Home>
inoremap <C-E> <End>

"folding settings
set foldmethod=indent   "fold based on indent
set foldnestmax=10      "deepest fold is 10 levels
set nofoldenable        "dont fold by default
set foldlevel=1         "this is just what i use

nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

map <C-PageUp> :bprevious<CR>
map <C-PageDown> :bNext<CR>

set mouse=a

" Set highlight search
set hlsearch
  
" Use deoplete.
" let g:deoplete#enable_at_startup = 1

" enable ncm1 for all buffers
" autocmd BufEnter * call ncm2#enable_for_buffer()


set cursorline
highlight clear CursorLine
highlight CursorLineNR cterm=bold ctermfg=grey

" Completion
set wildmenu
set wildmode=longest,list,full

function! GoogleSearch()
     let searchterm = getreg("g")
     silent! exec "silent! !firefox \"http://google.com/search?q=" . searchterm . "\" &"
endfunction
vnoremap <F6> "gy<Esc>:call GoogleSearch()<CR> 

filetype plugin on
set omnifunc=syntaxcomplete#Complete

"#############################################################################
" Extensions
"#############################################################################

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0



