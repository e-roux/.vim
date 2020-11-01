" This is my vimrc
"
" General {{{1
"##############################################################################

set nocompatible          " We're running Vim, not Vi!
syntax on                 " Set syntax color on

set dir=~/.cache/vim

set history=500           " number of command-lines that are remembered

" softtabs, 2 spaces
set softtabstop=2         " number of spaces that <Tab> uses while editing
set tabstop=2             " number of spaces that <Tab> in file uses
set shiftwidth=2          " number of spaces to use for (auto)indent step
set shiftround
set expandtab             " Convert tabs to spaces

set backspace=2           " Backspace deletes like most programs in insert mode

" Use one space, not two, after punctuation.
set nojoinspaces

" Make it obvious where 80 characters is
set textwidth=80
set colorcolumn=+1
"
let mapleader=','         " map the leader to ','

filetype on               " Enable filetype detection
filetype plugin on        " Enable filetype-specific plugins

set autoindent            " New lines inherit indentation of previous line
set smartindent
filetype indent on        " Enable filetype-specific indenting

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

" Always use vertical diffs
set diffopt+=vertical

"---------------------------------------------------------------------------{{{0
" Clipboard
"---------------------------------------------------------------------------}}}0
" Yank selection, word or line to system clipboard
" https://vi.stackexchange.com/questions/84/how-can-i-copy-text-to-the-system-clipboard-from-vim
set clipboard=unnamedplus
vnoremap <leader>y "+y
nnoremap <leader>yy "+yy
nnoremap <leader>yw "+yw
nnoremap <leader>ye "+ye

" Search vim help for subject under cursor: K in normal mode
" set keywordprg=:help

" see https://vi.stackexchange.com/questions/84
" vnoremap <leader>P "+p
" vnoremap <leader>Y "+y
" vnoremap <leader>p "*p
" vnoremap <leader>y "*y

"##########################################################################}}}1
" Folding {{{1
"##############################################################################

" nnoremap z1 :set foldlevel=1<CR>
" nnoremap z2 :set foldlevel=2<CR>
" nnoremap z3 :set foldlevel=3<CR>
" nnoremap z4 :set foldlevel=4<CR>

augroup vimrc 
  autocmd!
  autocmd BufEnter * for f in ['vimrc', 'zshrc', 'tmux.conf'] | if @% =~ f | set foldmethod=marker | endif | endfor
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
nnoremap <C-w>\| <C-w>v

"# ┌─┰─┐ Splitting windows into panes with memorizable commands
"# │ ┃ │ A horizontal split positions panes left and right.
"# └─┸─┘ Think of | (pipe symbol) as the separating line.
nnoremap <C-w>_ <C-w>s

" let s:resize_tmux_pane=system('tmux resize-pane -Z')

function ZoomPane()
  let l:buffer_count = len(tabpagebuflist())
  let l:pane_count = system('tmux list-panes | wc -l')
  let l:is_vim_zoomed = zoom#statusline() != '' ? 1 : 0
  let l:is_tmux_zoomed = system('tmux list-panes -F "#F" | grep -q Z && echo 1')

  if l:is_tmux_zoomed
    silent exec('!tmux resize-pane -Z')
    call zoom#toggle()
  elseif l:buffer_count > 1 && ! l:is_vim_zoomed
    call zoom#toggle()
    " silent exe<Plug>(zoom-toggle)c('!tmux resize-pane -Z')
  else 
    silent exec('!tmux resize-pane -Z')
  endif 
endfunction

if !hasmapto('<Plug>(zoom-toggle)')
  nmap <c-w>z :call ZoomPane()<CR>
endif

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
colorscheme solarized

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

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Ack searching and cope displaying
"    requires ack.vim - it's much better than vimgrep/grep
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" When you press gv you Ack after the selected text
vnoremap <silent> gv :call VisualSelection('gv', '')<CR>

" When you press <leader>r you can search and replace the selected text
vnoremap <silent> <leader>r :call VisualSelection('replace', '')<CR>
"
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
" Completion {{{1 
"###############################################################################
" function! Smart_TabComplete()
"   let line = getline('.')                         " current line
"   " from the start of the current line to one character right of the cursor
"   let substr = strpart(line, -1, col('.')+1)     
"   let substr = matchstr(substr, "[^ \t]*$")       " word till cursor
"   if (strlen(substr)==0)                          " nothing to match on empty string
"     return "\<tab>"
"   endif
"   let has_period = match(substr, '\.') != -1      " position of period, if any
"   let has_slash = match(substr, '\/') != -1       " position of slash, if any
"   if (!has_period && !has_slash)
"     return "\<C-X>\<C-P>"                         " existing text matching
"   elseif ( has_slash )
"     return "\<C-X>\<C-F>"                         " file matching
"   else
"     return "\<C-X>\<C-O>"                         " plugin matching
"   endif
" endfunction

" inoremap <tab> <c-r>=Smart_TabComplete()<CR>

" set omnifunc=syntaxcomplete#Complete
" set completepopup=height:10,width:60,highlight:InfoPopup
" set wildmenu
" set wildmode=longest,list,full

" https://vimhelp.org/options.txt.html#%27completeopt%27
" menu: Use a popup menu to show the possible completions
" preview
" set completeopt=menu,longest,noinsert,preview
" set completeopt+=menuone
" augroup completion
" 	autocmd!
" 	autocmd FileType go,python setlocal omnifunc=LanguageClient#complete
" augroup END

set omnifunc=ale#completion#OmniFunc
set dictionary=/usr/share/dict/british-english

"##########################################################################}}}1
" Custom functions {{{1 
"###############################################################################
function! GoogleSearch()
   let searchterm = getreg("g")
   silent! exec "silent! !firefox \"http://google.com/search?q=" . searchterm . "\" > /dev/null 2>&1 &"
   redraw!
endfunction

vnoremap <F6> "gy<Esc>:call GoogleSearch()<CR>


:command! BadgeStars :normal i <badge-stars repo=''></badge-stars><ESC>T=
:command! BadgeStars :normal i <badge-stars repo=''></badge-stars><ESC>T=
:command! BadgeWiki :normal i <badge-wiki href=''></badge-wiki><ESC>T=
:command! BadgeDoc :normal i <badge-doc href=''></badge-doc><ESC>T= 

function! Codify()

endfunction

" https://vim.fandom.com/wiki/Diff_current_buffer_and_the_original_file
function! s:DiffWithSaved()
  let filetype=&ft
  diffthis
  vnew | r # | normal! 1Gdd
  diffthis
  exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
endfunction
com! DiffSaved call s:DiffWithSaved()

"##########################################################################}}}1"}}}
" Plugins {{{1{{{
"##############################################################################
" airline {{{2
"##############################################################################

let g:airline_right_sep=''
let g:airline_right_alt_sep = ''
let g:airline_left_sep=''
let g:airline_left_alt_sep = ''

" Diplay only encoding if not 'utf-8[unix]'
let g:airline#parts#ffenc#skip_expected_string='utf-8[unix]'
  
let g:airline_powerline_fonts = 1
"
" tabline acivated in airline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'

" Unicode emoij
" http://unicode.org/emoji/charts/full-emoji-list.html
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_symbols.dirty='💥'

" let g:airline#extensions#ale#enabled = 0
" let g:airline#extensions#battery#enabled = 0
" let g:airline#extensions#bookmark#enabled = 0
" let g:airline#extensions#coc#enabled = 0
" let g:airline#extensions#lsp#enabled = 0


"##########################################################################}}}2
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
" let g:LanguageClient_serverCommands = {

let g:LanguageClient_loggingFile = "/tmp/LSP.log"
let g:LanguageClient_loggingLevel = "DEBUG"
let g:LanguageClient_settingsPath="/home/manu/.vim/coc-settings.json"
let g:LanguageClient_trace = "verbose"

" For references, see
" https://microsoft.github.io/language-server-protocol/specifications/specification-current/#textDocument_hover
command! Completion :call LanguageClient#textDocument_completion()
command! Hover :call LanguageClient#textDocument_hover()
command! Definition :call LanguageClient#textDocument_definition()
command! DocumentFormatting :call LanguageClient#textDocument_formatting()
command! LSPMenu :call LanguageClient_contextMenu()
command! Reference :call LanguageClient#textDocument_references()
command! Rename :call LanguageClient#textDocument_rename()
command! SignatureHelp :call LanguageClient#textDocument_signatureHelp()

" nnoremap <Esc> A
" nnoremap <Esc> <NOP>

function SetLSPShortcuts() " {{{3
  nnoremap <leader>gd :Definition<CR>
  nnoremap <leader>gx :Reference<CR>
  nnoremap <leader>lr :Rename<CR>
  nnoremap <leader>lf :DocumentFormatting<CR>
  nnoremap <leader>lt :call LanguageClient#textDocument_typeDefinition()<CR>
  nnoremap <leader>la :call LanguageClient_workspace_applyEdit()<CR>
  nnoremap <leader>lc :Completion<CR>
  nnoremap <leader>lh :Hover<CR>
  nnoremap <leader>ls :call LanguageClient_textDocument_documentSymbol()<CR>
  nnoremap <leader>lm LSPMenu<CR>
  " nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
  " nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
  " nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
  " nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
  " nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
  " nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
  " nnoremap <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
  " nnoremap <silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
  " nnoremap <silent> gd    <cmd>lua vim.lsp.buf.declaration()<CR>

endfunction() " }}}3

" augroup LanguageServerOpts
"   autocmd!
"   autocmd FileType yaml,python,js,c,go,vim call SetLSPShortcuts()
"   autocmd FileType yaml,python,js,c,go,vim setlocal omnifunc=LanguageClient#complete
" augroup END

" set cmdheight=2
let g:echodoc#enable_at_startup = 1
let g:echodoc#type = 'signature'

" DVC
autocmd! BufNewFile,BufRead Dvcfile,*.dvc,dvc.lock setfiletype yaml

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

"##########################################################################}}}2
" slime {{{2
"##############################################################################

let g:slime_target = "tmux"
let g:slime_default_config = {"socket_name": "default", "target_pane": "{last}"}
"##########################################################################}}}2
" Tmux Navigator {{{2
"##############################################################################
" https://github.com/christoomey/vim-tmux-navigator
"
" Navigation
let g:tmux_navigator_no_mappings = 1
" Disable tmux navigator when zooming the Vim pane
let g:tmux_navigator_disable_when_zoomed = 1

noremap <silent> <C-w>h :TmuxNavigateLeft<cr>
noremap <silent> <C-w>j :TmuxNavigateDown<cr>
noremap <silent> <C-w>k :TmuxNavigateUp<cr>
noremap <silent> <C-w>l :TmuxNavigateRight<cr>
noremap <silent> <C-w>\ :TmuxNavigatePrevious<cr>
"##########################################################################}}}2
" netrw{{{2
"##############################################################################
" Disable netrw.
let g:loaded_netrw  = 1
"##########################################################################}}}2
"##########################################################################}}}1


packloadall
" Load all of the helptags now, after plugins have been loaded.
" All messages and errors will be ignored.
silent! helptags ALL
