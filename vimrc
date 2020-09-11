"##############################################################################
"# ===    General   ===
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


"##############################################################################
"# ===    Buffers    ===
"##############################################################################
"  Unsaved modified buffer when opening a new file is hidden instead of closed

set hidden
nnoremap <C-h> :bprev<CR>
nnoremap <C-l> :bnext<CR>

"##############################################################################
"# ===     Fold   ===
"##############################################################################
set foldcolumn=4

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
let g:tmux_navigator_no_mappings = 1
" execute "set <M-".a:char.">=\<Esc>".a:char
" execute "set <M-j>=\x1bj"
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

" colorscheme molokai
" let g:molokai_original = 0
colorscheme solarized
set background=light

highlight Normal ctermbg=black 

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


set cursorline
highlight clear CursorLine
highlight CursorLineNR cterm=bold ctermfg=yellow

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
map <leader>n :cn<cr>
" map <leader>p :cp<cr>

" Make sure that enter is never overriden in the quickfix window
autocmd BufReadPost quickfix nnoremap <buffer> <CR> <CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" User Interface Options
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set laststatus=2      " Always display the status bar
set statusline+=%#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

set number            " Show line numbers on the sidebars
set noerrorbells      " Disable beep on errors
set mouse=a           " Enable mouse for scrolling and resizing

let g:airline_right_sep=''
let g:airline_left_sep=''
" tabline acivated in airline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
" let g:airline_theme = 'sonokai'
let g:airline_powerline_fonts = 1

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


" ---------------- YAML ----------------------
" add yaml stuffs
" autocmd! BufNewFile,BufReadPost *.{yaml,yml} set filetype=yaml foldmethod=indent

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


function! SmartTabComplete()
  " get 
  let if_char_preceding = strpart(getline('.'), col('.') - 1, 1)      " from the start of the current
  if strlen(if_char_preceding)                            " nothing to match on empty string
    " echo strlen(if_char_preceding)
    return "\<tab>"
  else
    " echo "no"
    return "\<C-X>\<C-O>"                         " plugin matching
  endif
endfunction

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

set background=light
" use <tab> for trigger completion and navigate to the next complete item
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()

" Use <Tab> and <S-Tab> to navigate the completion list:
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
" Use <cr> to confirm completion
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

nnoremap <Leader>a  ggvG$yggvG$"+y 
nmap <leader>w :w!<cr>    " Fast saving
map <leader>z :FZF<CR>


nnoremap <leader>d :bd<CR>  " Delete buffer 
" see https://vi.stackexchange.com/questions/84
vnoremap <Leader>P "+p
vnoremap <Leader>Y "+y
vnoremap <Leader>p "*p
vnoremap <leader>y "*y

let g:slime_target = "tmux"
let g:slime_default_config = {"socket_name": "default", "target_pane": "{last}"}
