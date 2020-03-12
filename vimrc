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

" source /usr/share/doc/fzf/examples/plugin/fzf.vim

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

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Ack searching and cope displaying
"    requires ack.vim - it's much better than vimgrep/grep
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use the the_silver_searcher
if executable('ag')
  let g:ackprg = 'ag --vimgrep --smart-case'
endif

" When you press gv you Ack after the selected text
vnoremap <silent> gv :call VisualSelection('gv', '')<CR>

" Open Ack and put the cursor in the right position
map <leader>g :Ack 

" When you press <leader>r you can search and replace the selected text
vnoremap <silent> <leader>r :call VisualSelection('replace', '')<CR>

" Do :help cope if you are unsure what cope is. It's super useful!
"
" When you search with Ack, display your results in cope by doing:
"   <leader>cc
"
" To go to the next search result do:
"   <leader>n
"
" To go to the previous search results do:
"   <leader>p
"
map <leader>cc :botright cope<cr>
map <leader>co ggVGy:tabnew<cr>:set syntax=qf<cr>pgg
map <leader>n :cn<cr>
map <leader>p :cp<cr>

" Make sure that enter is never overriden in the quickfix window
autocmd BufReadPost quickfix nnoremap <buffer> <CR> <CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" AIRLINE
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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

set rtp+=/usr/bin/fzf


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Python-mode
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:pymode_python = 'python3'
let g:pymode_virtualenv_path = $VIRTUAL_ENV
let g:pymode_lint = 0
let g:pymode_lint_checkers = ['pep8']



