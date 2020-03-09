" For package management using git submodules:
" https://shapeshed.com/vim-packages/

set expandtab
set shiftwidth=2
set softtabstop=2
set number

"##################################################################
" Theming
"##################################################################
"" https://github.com/tomasr/molokai
colorscheme molokai
set background=dark
let g:molokai_original = 0
let g:rehash256 = 1
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


