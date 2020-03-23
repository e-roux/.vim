" For package management using git submodules:
" https://shapeshed.com/vim-packages/

"##################################################################
" General
"##################################################################

" Sets how many lines of history VIM has to remember
set history=500
set expandtab
set shiftwidth=2
set softtabstop=2
set number

set mouse=a

" map the leader to ','
let mapleader = ','

" Enable filetype plugins
filetype plugin on
filetype indent on
set omnifunc=syntaxcomplete#Complete

" Set to auto read when a file is changed from the outside
set autoread
au FocusGained,BufEnter * checktime

" Fast saving
nmap <leader>w :w!<cr>

" :W sudo saves the file 
" (useful for handling the permission-denied error)
command! W execute 'w !sudo tee % > /dev/null' <bar> edit!

" Buffers
set hidden
nnoremap <C-N> :bnext<CR>
nnoremap <C-P> :bprev<CR>

" map <C-PageUp> :bprevious<CR>
" map <C-PageDown> :bNext<CR>
" unmap <M-j>

" Copy to system clipboard
" see https://vi.stackexchange.com/questions/84
vnoremap <leader>y "*y
vnoremap <Leader>p "*p
vnoremap <Leader>Y "+y
vnoremap <Leader>P "+p


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

" map <C-A> <Home>
" map <C-e> <End>
" inoremap <C-A> <Home>
" inoremap <C-E> <End>
" nnoremap <A-j> :m .+1<CR>==
" nnoremap <A-k> :m .-2<CR>==
" inoremap <A-j> <Esc>:m .+1<CR>==gi
" inoremap <A-k> <Esc>:m .-2<CR>==gi
" vnoremap <A-j> :m '>+1<CR>gv=gv
" vnoremap <A-k> :m '<-2<CR>gv=gv

" nnoremap <A-c> gcc

" Set highlight search and map 
set hlsearch
nnoremap <silent> <leader><space> :nohlsearch<CR>

set cursorline
highlight clear CursorLine
highlight CursorLineNR cterm=bold ctermfg=grey

" Completion
set wildmenu
set wildmode=longest,list,full

function! GoogleSearch()
     let searchterm = getreg("g")
     silent! exec "silent! !firefox \"http://google.com/search?q=" . searchterm . "\" > /dev/null 2>&1 &"
     redraw!
endfunction
vnoremap <F6> "gy<Esc>:call GoogleSearch()<CR> 


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


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" fzf
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Fix different install location on ubuntu
let s:ubuntu_fzf = [
  \ "/usr/share/doc/fzf/examples/fzf.vim",
  \ "/usr/local/share/fzf/plugin/fzf.vim",
  \ ]
for f in s:ubuntu_fzf
  if filereadable(f)
    execute 'source '.fnameescape(f)
  endif
endfor
" if filereadable("/usr/local/share/fzf/plugin/fzf.vim")
"   source /usr/local/share/fzf/plugin/fzf.vim
" endif
  " set rtp+=/usr/bin/fzf

" This is the default extra key bindings
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

" An action can be a reference to a function that processes selected lines
function! s:build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cc
endfunction

let g:fzf_action = {
  \ 'ctrl-q': function('s:build_quickfix_list'),
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

" Default fzf layout
" - down / up / left / right
let g:fzf_layout = { 'down': '~40%' }

" You can set up fzf window using a Vim command (Neovim or latest Vim 8 required)
let g:fzf_layout = { 'window': 'enew' }
let g:fzf_layout = { 'window': '-tabnew' }
let g:fzf_layout = { 'window': '10new' }

" Customize fzf colors to match your color scheme
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

" Enable per-command history.
" CTRL-N and CTRL-P will be automatically bound to next-history and
" previous-history instead of down and up. If you don't like the change,
" explicitly bind the keys to down and up in your $FZF_DEFAULT_OPTS.
let g:fzf_history_dir = '~/.local/share/fzf-history'


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Python-mode
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" let g:pymode_python = 'python3'
" let g:pymode_virtualenv_path = $VIRTUAL_ENV
" let g:pymode_lint = 0
" let g:pymode_lint_checkers = ['pep8']
" " Trim unused white spaces on save.
" let g:pymode_trim_whitespaces = 1
" let g:py

" Setup default python options.
" let g:pymode_options = 1
" is equivalent to:
  
" setlocal complete+=t
" setlocal formatoptions-=t
" if v:version > 702 && !&relativenumber
"     setlocal number
" endif
" setlocal nowrap
" setlocal textwidth=79
" setlocal commentstring=#%s
" setlocal define=^\s*\\(def\\\\|class\\)

" Turn on the rope script
" let g:pymode_rope = 0
" Turn on code completion support in the plugin.
" let g:pymode_rope_completion = 1
" Keymap for autocomplete.
" let g:pymode_rope_completion_bind = '<C-Space>'
nnoremap <leader>r :CocCommand python.execInTerminal<cr>
