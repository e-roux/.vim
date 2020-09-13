" This is my vimrc
"
" General {{{1
"##############################################################################

set nocompatible          " We're running Vim, not Vi!
syntax on                 " Set syntax color on

set dir=~/.cache/vim

set history=500           " number of command-lines that are remembered
set shiftwidth=2          " number of spaces to use for (auto)indent step
set softtabstop=2         " number of spaces that <Tab> uses while editing
set tabstop=4             " number of spaces that <Tab> in file uses

set bs=2   " how backspace (bs) works at start of line

let mapleader=','         " map the leader to ','

filetype on               " Enable filetype detection
filetype plugin on        " Enable filetype-specific plugins

set expandtab             " Convert tabs to spaces
set autoindent            " New lines inherit indentation of previous line
set smartindent
filetype indent on        " Enable filetype-specific indenting

set clipboard=unnamedplus
" https://vi.stackexchange.com/questions/84/how-can-i-copy-text-to-the-system-clipboard-from-vim
inoremap <tab> <c-r>=Smart_TabComplete()<CR>
function! Smart_TabComplete()
  let line = getline('.')                         " current line

  let substr = strpart(line, -1, col('.')+1)      " from the start of the current
                                                  " line to one character right
                                                  " of the cursor
  let substr = matchstr(substr, "[^ \t]*$")       " word till cursor
  if (strlen(substr)==0)                          " nothing to match on empty string
    return "\<tab>"
  endif
  let has_period = match(substr, '\.') != -1      " position of period, if any
  let has_slash = match(substr, '\/') != -1       " position of slash, if any
  if (!has_period && !has_slash)
    return "\<C-X>\<C-P>"                         " existing text matching
  elseif ( has_slash )
    return "\<C-X>\<C-F>"                         " file matching
  else
    return "\<C-X>\<C-O>"                         " plugin matching
  endif
endfunction

set omnifunc=syntaxcomplete#Complete

" Set to auto read when a file is changed from the outside
set autoread
autocmd FocusGained,BufEnter * checktime

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
nnoremap <leader>a  ggvG$yggvG$"+y
nnoremap <leader>w :w!<cr>    " Fast saving


" see https://vi.stackexchange.com/questions/84
" vnoremap <leader>P "+p
" vnoremap <leader>Y "+y
" vnoremap <leader>p "*p
" vnoremap <leader>y "*y

"##########################################################################}}}1
" Folding {{{1
"##############################################################################

nnoremap z1 :set foldlevel=1<CR>
nnoremap z2 :set foldlevel=2<CR>
nnoremap z3 :set foldlevel=3<CR>
nnoremap z4 :set foldlevel=4<CR>



augroup vimrc 
  autocmd!
  autocmd VimEnter * for f in ['vimrc', 'zshrc'] | if @% == f | set foldmethod=marker | endif | endfor
augroup END

"##########################################################################}}}1
"Buffers {{{1
"##############################################################################
"  Unsaved modified buffer when opening a new file is hidden instead of closed

set hidden
nnoremap <C-h> :bprev<CR>
nnoremap <C-l> :bnext<CR>

nnoremap <leader>d :bd<CR>  " Delete buffer
"##########################################################################}}}1
" Panes  {{{1
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
" Disable tmux navigator when zooming the Vim pane
let g:tmux_navigator_disable_when_zoomed = 1

nnoremap <silent> h :TmuxNavigateLeft<cr>
nnoremap <silent> j :TmuxNavigateDown<cr>
nnoremap <silent> k :TmuxNavigateUp<cr>
nnoremap <silent> l :TmuxNavigateRight<cr>
nnoremap <silent> \ :TmuxNavigatePrevious<cr>


nnoremap <c-w>z <c-w>_ \| <c-w>\|

" Close pane
nnoremap <leader>pc <C-w>c
nnoremap <leader>ph <C-w>H
nnoremap <leader>pj <C-w>J
nnoremap <leader>pk <C-w>K
nnoremap <leader>pl <C-w>L

"##########################################################################}}}1
" Appearence and status bar {{{1
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

" colorscheme molokai
" let g:molokai_original = 0
colorscheme solarized
set background=light

highlight Normal ctermbg=black

set cursorline
highlight clear CursorLine
highlight CursorLineNR cterm=bold ctermfg=yellow

" Set highlight search and map to <leader> <space>
set hlsearch
nnoremap <silent> <leader><space> :nohlsearch<CR>

" From http://got-ravings.blogspot.com/2008/07/vim-pr0n-visual-search-mappings.html

" makes * and # work on visual mode too.
function! s:VSetSearch(cmdtype)
  let temp = @s
  norm! gv"sy
  let @/ = '\V' . substitute(escape(@s, a:cmdtype.'\'), '\n', '\\n', 'g')
  let @s = temp
endfunction

xnoremap * :<C-u>call <SID>VSetSearch('/')<CR>/<C-R>=@/<CR><CR>
xnoremap # :<C-u>call <SID>VSetSearch('?')<CR>?<C-R>=@/<CR><CR>

" recursively vimgrep for word under cursor or selection if you hit leader-star
if maparg('<leader>*', 'n') == ''
  nmap <leader>* :execute 'noautocmd vimgrep /\V' . substitute(escape(expand("<cword>"), '\'), '\n', '\\n', 'g') . '/ **'<CR>
endif
if maparg('<leader>*', 'v') == ''
  vmap <leader>* :<C-u>call <SID>VSetSearch()<CR>:execute 'noautocmd vimgrep /' . @/ . '/ **'<CR>
endif


" Completion
set wildmenu
set wildmode=longest,list,full

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
" map <leader>cc :botright cope<cr>
" map <leader>co ggVGy:tabnew<cr>:set syntax=qf<cr>pgg
" map <leader>n :cn<cr>
" map <leader>p :cp<cr>

" Make sure that enter is never overriden in the quickfix window
autocmd BufReadPost quickfix nnoremap <buffer> <CR> <CR>

"##########################################################################}}}1
" User Interface Options {{{1
"##############################################################################
set laststatus=2      " Always display the status bar
set statusline+=%#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

set number            " Show line numbers on the sidebars
set noerrorbells      " Disable beep on errors
set mouse=a           " Enable mouse for scrolling and resizing

"##########################################################################}}}1
" Custom functions {{{1 
"###############################################################################
function! GoogleSearch()
   let searchterm = getreg("g")
   silent! exec "silent! !firefox \"http://google.com/search?q=" . searchterm . "\" > /dev/null 2>&1 &"
   redraw!
endfunction

vnoremap <F6> "gy<Esc>:call GoogleSearch()<CR>

" use <tab> for trigger completion and navigate to the next complete item
" function! s:check_back_space() abort
"   let col = col('.') - 1
"   return !col || getline('.')[col - 1]  =~ '\s'
" endfunction

" inoremap <silent><expr> <Tab>
"       \ pumvisible() ? "\<C-n>" :
"       \ <SID>check_back_space() ? "\<Tab>" :
"       \ coc#refresh()

" " Use <Tab> and <S-Tab> to navigate the completion list:
" inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
" inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
" " Use <cr> to confirm completion
" inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

"##########################################################################}}}1"}}}
" Plugins {{{1{{{
"##############################################################################

let g:airline_right_sep=''
let g:airline_left_sep=''
" tabline acivated in airline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
" let g:airline_theme = 'sonokai'
let g:airline_powerline_fonts = 1

set background=light

"##############################################################################
" fzf {{{2
"##############################################################################
 
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

nnoremap <leader>z :FZF<CR>

"##########################################################################}}}2
" LanguageClient {{{2
"##############################################################################
let g:LanguageClient_serverCommands = {
    \ 'c': ['ccls', '--log-file=/tmp/cc.log'],
    \ 'cpp': ['ccls', '--log-file=/tmp/cc.log'],
    \ 'go': ['/home/manu/go/bin/gopls'],
    \ 'javascript': ['/usr/local/bin/javascript-typescript-stdio'],
    \ 'javascript.jsx': ['tcp://127.0.0.1:2089'],
    \ 'python': ['/tmp/pls/bin/pyls'],
    \ 'ruby': ['~/.rbenv/shims/solargraph', 'stdio'],
    \ 'rust': ['~/.cargo/bin/rustup', 'run', 'stable', 'rls'],
    \ 'vim': ['/usr/bin/vim-language-server', '--stdio'],
    \ 'yaml': ['/usr/lib/node_modules/yaml-language-server/bin/yaml-language-server', '--stdio'],
    \}

function SetLSPShortcuts()
  nnoremap <leader>gd :call LanguageClient#textDocument_definition()<CR>
  nnoremap <leader>gx :call LanguageClient#textDocument_references()<CR>
  nnoremap <leader>lr :call LanguageClient#textDocument_rename()<CR>
  nnoremap <leader>lf :call LanguageClient#textDocument_formatting()<CR>
  nnoremap <leader>lt :call LanguageClient#textDocument_typeDefinition()<CR>
  nnoremap <leader>la :call LanguageClient_workspace_applyEdit()<CR>
  nnoremap <leader>lc :call LanguageClient#textDocument_completion()<CR>
  nnoremap <leader>lh :call LanguageClient#textDocument_hover()<CR>
  nnoremap <leader>ls :call LanguageClient_textDocument_documentSymbol()<CR>
  nnoremap <leader>lm :call LanguageClient_contextMenu()<CR>
endfunction()

augroup LanguageServerOpts
  autocmd!
  autocmd FileType yaml,python,js,go call SetLSPShortcuts()
  autocmd FileType yaml,python,js,go setlocal omnifunc=LanguageClient#complete
augroup END

"#######################################################################}}}2
" Python mode {{{2
"##############################################################################
" let g:pymode_python = 'python3'
" let g:pymode_virtualenv_path = $VIRTUAL_ENV
" let g:pymode_lint = 0
" let g:pymode_lint_checkers = ['pep8']
" " Trim unused white spaces on save.
" let g:pymode_trim_whitespaces = 1
" let g:py

" Setup default python options.
"  g:pymode_options = 1
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


" ---------------- C ----------------------
autocmd FileType c nnoremap <leader>r :!clear && gcc % -o %< && %< && read<cr>

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


"##########################################################################}}}2
" slime {{{2
"##############################################################################

let g:slime_target = "tmux"
let g:slime_default_config = {"socket_name": "default", "target_pane": "{last}"}
"##########################################################################}}}2
"#######################################################################}}}1
