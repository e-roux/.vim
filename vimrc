"For package management using git submodules:
" https://shapeshed.com/vim-packages/

"##############################################################################
"# ===    General   ===
"##############################################################################

set nocompatible      " We're running Vim, not Vi!
syntax on             " Set syntax color on

" Sets how many lines of history VIM has to remember
set history=500
set expandtab
set shiftwidth=2
set softtabstop=2
set number

set backspace=2
set mouse=a

" map the leader to ','
let mapleader=','

filetype on           " Enable filetype detection
filetype indent on    " Enable filetype-specific indenting
filetype plugin on    " Enable filetype-specific plugins

set omnifunc=syntaxcomplete#Complete

" Set to auto read when a file is changed from the outside
set autoread
au FocusGained,BufEnter * checktime

" Fast saving
nmap <leader>w :w!<cr>    

" :W sudo saves the file 
" (useful for handling the permission-denied error)
command! W execute 'w !sudo tee % > /dev/null' <bar> edit!

" Remap gf: create buffer if file does not exists
:nnoremap gf :e <cfile><cr>

function! s:Saving_scroll(cmd)
  let save_scroll = &scroll
  execute 'normal! ' . a:cmd
  let &scroll = save_scroll
endfunction

nnoremap <C-J> :call <SID>Saving_scroll("1<C-V><C-D>")<CR>
vnoremap <C-J> <Esc>:call <SID>Saving_scroll("gv1<C-V><C-D>")<CR>
nnoremap <C-K> :call <SID>Saving_scroll("1<C-V><C-U>")<CR>
vnoremap <C-K> <Esc>:call <SID>Saving_scroll("gv1<C-V><C-U>")<CR>



"##############################################################################
"# ===    Buffers    ===
"##############################################################################
"  Unsaved modified buffer when opening a new file is hidden instead of closed

set hidden
nnoremap <C-h> :bprev<CR>
nnoremap <C-l> :bnext<CR>

" Delete buffer
nnoremap <leader>d :bd<CR>

"##############################################################################
"# ===     Fold   ===
"##############################################################################
set foldcolumn=4

"##############################################################################
"# ===     Copy and clipboard      ===
"##############################################################################
" see https://vi.stackexchange.com/questions/84
vnoremap <leader>y "*y
vnoremap <Leader>p "*p
vnoremap <Leader>Y "+y
vnoremap <Leader>P "+p

nnoremap <Leader>a  ggvG$yggvG$"+y 
"###############################################################################
"# ===   Panes   ===
"###############################################################################
"#
"# ┌───┐ Splitting windows into panes with memorizable commands
"# ┝━━━┥ A vertical split positions panes up and down.
"# └───┘ Think of - as the separating line.
nnoremap \| <C-w>v

"# ┌─┰─┐ Splitting windows into panes with memorizable commands
"# │ ┃ │ A horizontal split positions panes left and right.
"# └─┸─┘ Think of | (pipe symbol) as the separating line.
nnoremap _ <C-w>s

" From here, Vim Tmux Navigator
" https://github.com/christoomey/vim-tmux-navigator
" Navigation
let g:tmux_navigator_no_mappings = 1

nnoremap <silent> h :TmuxNavigateLeft<cr>
nnoremap <silent> j :TmuxNavigateDown<cr>
nnoremap <silent> k :TmuxNavigateUp<cr>
nnoremap <silent> l :TmuxNavigateRight<cr>
nnoremap <silent> \ :TmuxNavigatePrevious<cr>

" Disable tmux navigator when zooming the Vim pane
let g:tmux_navigator_disable_when_zoomed = 1

nnoremap <c-w>z <c-w>_ \| <c-w>\|

"##############################################################################
"# ===    Appearence and status bar  ===
"##############################################################################
" ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
" ┃buf01 │ buf02 │ buf03                                                      ┃
" ┃                                                                           ┃
" ┃                                                                           ┃
" ┃                                                                           ┃
" ┃                                                                           ┃
" ┃                                                                           ┃
" ┃                                                                           ┃
" ┃                                                                           ┃
" ┃                                                                           ┃
" ┃                                                                           ┃
" ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
"
" Theme
"" https://github.com/tomasr/molokai

colorscheme molokai
" set background=dark
let g:molokai_original = 0
" let g:rehash256 = 1
" Set background as black
highlight Normal ctermbg=black 

" Set highlight search and map to <leader> <space>
set hlsearch
nnoremap <silent> <leader><space> :nohlsearch<CR>

set cursorline
highlight clear CursorLine
highlight CursorLineNR cterm=bold ctermfg=yellow

" Completion
set wildmenu
set wildmode=longest,list,full

"##############################################################################
"    ===   Motion   ===
"##############################################################################



"#############################################################################
" ===   Extensions   ===
"#############################################################################

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Ack searching and cope displaying
"    requires ack.vim - it's much better than vimgrep/grep
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" When you press gv you Ack after the selected text
vnoremap <silent> gv :call VisualSelection('gv', '')<CR>


" When you press <leader>r you can search and replace the selected text
vnoremap <silent> <leader>r :call VisualSelection('replace', '')<CR>
" Do :help cope if you are unsure what cope is. It's super useful!
"
map <leader>cc :botright cope<cr>
map <leader>co ggVGy:tabnew<cr>:set syntax=qf<cr>pgg
map <leader>n :cn<cr>
" map <leader>p :cp<cr>

" Make sure that enter is never overriden in the quickfix window
autocmd BufReadPost quickfix nnoremap <buffer> <CR> <CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ===   Coc  ===
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
command! -nargs=0 Prettier :CocCommand prettier.formatFile
map <leader>p :Prettier
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ===   AIRLINE   ===
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'

set statusline+=%#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

" let g:airline_theme = 'sonokai'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ===   fzf   ===
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
	
map <leader>z :FZF<CR>

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)


" Use fd for ctrlp.
if executable('fd')
    let g:ctrlp_user_command = 'fd -c never "" "%s"'
    let g:ctrlp_use_caching = 0
endif

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

" --------------- Python ---------------------
au! BufNewFile,BufRead *.py set foldmethod=indent

" ---------------- YAML ----------------------
" add yaml stuffs
autocmd! BufNewFile,BufReadPost *.{yaml,yml} set filetype=yaml foldmethod=indent
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab foldlevel=2


" ---------------- JS ----------------------
function! JSFolds() 
  let thisline = getline(v:lnum)
  if thisline =~? '\v^\s*$'
    return '-1'
  endif

  if thisline =~ '^import.*$'
    return 1
  else
    return indent(v:lnum) / &shiftwidth
  endif
endfunction

autocmd! BufNewFile,BufReadPost *.{js,ts,json} set filetype=javascript foldmethod=expr
" autocmd FileType javascript syntax region braceFold start="{" end="}" transparent fold
autocmd FileType javascript setlocal foldexpr=JSFolds()
autocmd FileType javascript setlocal foldlevel=1
map <leader>r yi":!npm run <C-r>"<CR>

autocmd FileType javascript nnoremap <leader>r :!node %<cr>

" ---------------- C ----------------------
autocmd FileType c nnoremap <leader>r :!clear && gcc % -o %< && %< && read<cr>

" ---------------- GO ----------------------
autocmd! BufNewFile,BufReadPost *.{go} set filetype=go 
" map <leader>r yi":!go run % <C-r>"<CR>
" foldmethod=indent

" Use <Tab> and <S-Tab> to navigate the completion list:
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
" Use <cr> to confirm completion
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" make <cr> select the first completion item and confirm the completion when
" no item has been selected
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>"
" Close the preview window when completion is done.
autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif


let g:ruby_indent_access_modifier_style = 'indent'
let g:ruby_indent_block_style = 'expression'
let g:ruby_indent_assignment_style = 'hanging'
let g:polyglot_disabled = ['ruby']

"###############################################################################
"# ===   Custom functions   ===
"###############################################################################
function! GoogleSearch()
   let searchterm = getreg("g")
   silent! exec "silent! !firefox \"http://google.com/search?q=" . searchterm . "\" > /dev/null 2>&1 &"
   redraw!
endfunction

vnoremap <F6> "gy<Esc>:call GoogleSearch()<CR> 


