" This is my vimrc
"
" Init: {{{1
"##############################################################################
if has('nvim')
  set runtimepath^=~/.vim runtimepath+=~/.vim/after
endif

" Disable extra plugins
let g:loaded_gzip               =  1
let g:loaded_tarPlugin          =  1
let g:loaded_zipPlugin          =  1
let g:loaded_2html_plugin       =  1

let g:loaded_netrw              =  1
" Remote plugins
let g:loaded_rrhelper           =  1
let g:loaded_remote_plugins     =  1
let g:loaded_netrw              =  1
let g:loaded_netrwPlugin        =  1

" custom
let g:ale_enabled = 1
" let g:loaded_miniSnip = 1
" 1}}} "Init

" General {{{1
"##############################################################################

setglobal nocompatible          " We're running Vim, not Vi!

" Enables syntax color and ftplugin, see :h filetype-overview
syntax on                       " Set syntax color on
filetype plugin indent on       " Enable filetype-specific indenting plugin

setglobal dir=~/.cache/vim

setglobal history=500           " number of command-lines that are remembered

set tabstop=4                   " number of spaces that <Tab> in file uses

setglobal expandtab             " Convert tabs to spaces
setglobal softtabstop=2         " number of spaces that <Tab> uses while editing
setglobal shiftwidth=0          " number of spaces to use for (auto)indent step

setglobal shiftround
setglobal backspace=2           " Backspace deletes like most programs in insert mode

setglobal autoindent            " New lines inherit indentation of previous line
setglobal smartindent
setglobal nojoinspaces          " Use one space, not two, after punctuation.
setglobal textwidth=0           " Make it obvious where 80 characters is
setglobal colorcolumn=80
setglobal autoread              " Set to auto read when a file is changed
setglobal diffopt+=vertical     " Always use vertical diffs

if has('unnamedplus')
  setglobal clipboard=unnamedplus
endif

let mapleader=','         " map the leader to ','

"  Unsaved modified buffer when opening a new file is hidden instead of closed
setglobal hidden

autocmd FocusGained,BufEnter * checktime

" :W sudo saves the file
" (useful for handling the permission-denied error)
command! W execute 'w !sudo tee % > /dev/null' <bar> edit!

" Remap gf: create buffer if file does not exists
function! s:GotoFile(path)
  echo(a:path)
  if isdirectory(a:path)
    exec("NERDTreeToggle " . a:path)
  else
    exec("edit " . a:path)
  endif
endfunction

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
if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

source ~/.vim/colors/background.vim

" Theme
" let g:solarized_termcolors=256
let s:terminal_italic=1
colorscheme solarized

setglobal cursorline
highlight clear CursorLine
highlight CursorLineNR cterm=bold ctermfg=yellow

" Set highlight search and map to <leader> <space>
setglobal hlsearch
nnoremap <leader><space> :nohlsearch<CR>

" makes * and # work on visual mode too.
" From http://got-ravings.blogspot.com/2008/07/vim-pr0n-visual-search-mappings.html
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

" Cursor changed in insertmode
let &t_SI = "\e[6 q"            " steady bar, insert mode
let &t_EI = "\e[2 q"            " steady block, edit mode

" Redraw on VimResume
if has('patch-8.2.2128')
autocmd VimEnter,InsertLeave,VimResume *
  \ silent execute '!echo -ne "\e[2 q"' | redraw!
endif

autocmd InsertEnter,InsertChange *
  \ if v:insertmode == 'i' |
  \   silent execute '!echo -ne "\e[6 q"' | redraw! |
  \ elseif v:insertmode == 'r' |
  \   silent execute '!echo -ne "\e[4 q"' | redraw! |
  \ endif
autocmd VimLeave * silent execute '!echo -ne "\e[ q"' | redraw!

autocmd BufReadPost quickfix nnoremap <buffer> <CR> <CR>

"##########################################################################}}}1

" Folding {{{1
"##############################################################################

" nnoremap z1 :set foldlevel=1<CR>
" nnoremap z2 :set foldlevel=2<CR>
" nnoremap z3 :set foldlevel=3<CR>
" nnoremap z4 :set foldlevel=4<CR>

" augroup vimrc
"   autocmd!
"   autocmd BufEnter * for f in ['vimrc', 'zshrc', 'tmux.conf'] | if @% =~ f | set foldmethod=marker | endif | endfor
" augroup END

set foldopen&
function! s:toggleFoldClose()
  " toggle automatic folds close when you move out of it
  if &foldclose ==? 'all'
    set foldclose&vim
  else
    set foldclose=all
  endif
endfunction

command! ToggleFoldClose :call <SID>toggleFoldClose()


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

function s:ZoomPane()
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
  nmap <c-w>z :call <SID>ZoomPane()<CR>
endif

"##########################################################################}}}1

" User Interface Options {{{1
"##############################################################################
set number                  " Show line numbers on the sidebars
setglobal noerrorbells      " Disable beep on errors
setglobal mouse=a           " Enable mouse for scrolling and resizing

setglobal laststatus=2      " Always display the status bar
" setglobal statusline+=%#warningmsg#
" setglobal statusline+=%{SyntasticStatuslineFlag()}
" setglobal statusline+=%*
"##########################################################################}}}1

" Plugins {{{1
"##############################################################################
let g:db_ui_use_nerd_fonts=1
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
" tabline activated
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'

" Unicode emoij
" http://unicode.org/emoji/charts/full-emoji-list.html
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

let g:airline_symbols = {
  \ 'space': ' ',
  \ 'paste': 'PASTE',
  \ 'spell': 'SPELL',
  \ 'notexists': '⚠',
  \ 'maxlinenr': ' ',
  \ 'linenr': '📄',
  \ 'readonly': '🔒',
  \ 'dirty': '💥',
  \ 'modified': '✏ ',
  \ 'crypt': '🔑',
  \ 'keymap': 'Keymap:',
  \ 'ellipsis': '...',
  \ 'branch': '⎇',
  \ 'whitespace': '☲',
  \ }
"##########################################################################}}}2

" LanguageClient {{{2
"##############################################################################
" let g:LanguageClient_serverCommands = {

" let g:LanguageClient_loggingFile = "/tmp/LSP.log"
" let g:LanguageClient_loggingLevel = "DEBUG"
" let g:LanguageClient_settingsPath="/home/manu/.vim/coc-settings.json"
" let g:LanguageClient_trace = "verbose"

" For references, see
" https://microsoft.github.io/language-server-protocol/specifications/specification-current/#textDocument_hover
command! FindReference :ALEFindReferences
command! GoToDefinition :ALEGoToDefinition
command! Rename :ALERename
" command! Completion :call LanguageClient#textDocument_completion()
" command! Hover :call LanguageClient#textDocument_hover()
" command! DocumentFormatting :call LanguageClient#textDocument_formatting()
" command! LSPMenu :call LanguageClient_contextMenu()
" command! SignatureHelp :call LanguageClient#textDocument_signatureHelp()
"
" set cmdheight=2
let g:echodoc#enable_at_startup = 1
let g:echodoc#type = 'signature'

" augroup LanguageServerOpts
"   autocmd!
"   autocmd FileType yaml,python,js,c,go,vim call SetLSPShortcuts()
"   " autocmd FileType yaml,python,js,c,go,vim setlocal omnifunc=LanguageClient#complete
" augroup END

"#######################################################################}}}2

" Minisnip {{{2
" let g:minisnip_autoindent = 0
let g:name = 'Emmanuel Roux'
let g:email = ' '
let g:miniSnip_trigger = '<F4>'
let g:miniSnip_dirs = [ expand('%:p:h') . '/extra/snip',  '~/.vim/extra/snip' ]
let g:miniSnip_opening = '{{'
let g:miniSnip_closing = '}}'
" 2}}}

" Mucomplete

let g:mucomplete#user_mappings = {
					\'mini': "\<C-r>=MUcompleteMinisnip#complete()\<CR>",
					\ }
let g:mucomplete#chains = {}
    let g:mucomplete#chains['default']   =  {
                \              'default': ['mini',  'list',  'omni',  'path',  'c-n',   'uspl'],
              \              '.*string.*': ['uspl'],
              \              '.*comment.*': ['uspl']
              \            }

" NERDTree {{{2
"##############################################################################
" Those must be set before NERDTree is loaded
let g:NERDTreeGitStatusIndicatorMapCustom = {
                \ 'Modified'  :'✏ ',
                \ 'Staged'    :'➕',
                \ 'Untracked' :'⚠ ',
                \ 'Renamed'   :'➜ ',
                \ 'Unmerged'  :'⛓',
                \ 'Deleted'   :'🗑',
                \ 'Dirty'     :'💥',
                \ 'Ignored'   :'✅',
                \ 'Clean'     :'✔︎ ',
                \ 'Unknown'   :'❓',
                \ }
let g:NERDTreeMapCloseDir = "h"
let g:NERDTreeMapActivateNode = "l"
let g:NERDTreeIgnore = ['__pycache__']
" CWD is changed when the NERDTree is first loaded to the directory it is
" initialized in
let g:NERDTreeChDirMode = 1

autocmd BufEnter *
  \ if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree')
  \ && b:NERDTree.isTabTree() | quit | endif
"##########################################################################}}}2

" netrw{{{2
"##############################################################################
" suppress the banner
let g:netrw_banner = 0
" when browsing, <cr> will open the file by:
" act like "P" (ie. open previous window)
let g:netrw_browse_split = 4
" change from left splitting to right splitting
let g:netrw_altv = 1
" preview window shown in a vertically split window.
let g:netrw_preview   = 1
" tree style listing
let g:netrw_liststyle = 3
" specify initial size of new windows made with "o" (see |netrw-o|), "v" (see
" |netrw-v|), |:Hexplore| or |:Vexplore|.
let g:netrw_winsize = 25
" augroup ProjectDrawer
"   autocmd!
"   autocmd VimEnter * :Vexplore
" augroup END

"##########################################################################}}}2

" nnn{{{2
"##############################################################################
let g:nnn#layout = { 'left': '~20%' }
"##########################################################################}}}2

" SimplyFold {{{2
"##############################################################################
let g:SimpylFold_fold_import=0
let g:SimpylFold_docstring_preview=1
let g:SimpylFold_fold_docstring=0
" let g:SimpylFold_fold_blank=1
"##########################################################################}}}2

" Table mode {{{2
"##############################################################################
let g:table_mode_disable_tableize_mappings=1
"##########################################################################}}}2

" Tmux Navigator {{{2
"##############################################################################
" https://github.com/christoomey/vim-tmux-navigator
"
" Navigation
let g:tmux_navigator_no_mappings = 1
" Disable tmux navigator when zooming the Vim pane
let g:tmux_navigator_disable_when_zoomed = 1

"##########################################################################}}}2

" vim-test {{{2
"##############################################################################
"
let test#strategy = {
  \ 'nearest':       'asyncrun_background',
  \ 'file':          'asyncrun_background_term',
  \ 'suite':         'asyncrun_background_term',
  \}

function! s:syncrun_background_buff(cmd) abort
  let g:test#strategy#cmd = a:cmd
  call test#strategy#asyncrun_setup_unlet_global_autocmd()
  execute 'AsyncRun -mode=term -focus=0 -post=echo\ eval("g:asyncrun_code\ ?\"Failure\":\"Success\"").":"'
          \ .'\ substitute(g:test\#strategy\#cmd,\ "\\",\ "",\ "") '.a:cmd
endfunction
let g:test#custom_strategies = {'echo': function('s:syncrun_background_buff')}
let g:test#strategy = 'echo'
"##########################################################################}}}2
"##########################################################################}}}1
" }}}1 "Plugins

" General Mappings: {{{1
"###############################################################################
" KEY BINDINGS
"###############################################################################

" <C-J|K> Saving scroll: {{{2
"###############################################################################
function! s:Saving_scroll(cmd)
  let save_scroll = &scroll
  execute 'normal! ' . a:cmd
  let &scroll = save_scroll
endfunction

nnoremap <C-J> :call <SID>Saving_scroll("1<C-V><C-D>")<CR>
nnoremap <C-K> :call <SID>Saving_scroll("1<C-V><C-U>")<CR>
vnoremap <C-J> <Esc>:call <SID>Saving_scroll("gv1<C-V><C-D>")<CR>
vnoremap <C-K> <Esc>:call <SID>Saving_scroll("gv1<C-V><C-U>")<CR>
"##########################################################################}}}2

" Insert Completion mode
" h popupmenu-keys
inoremap <C-J> <C-R>=pumvisible() ? "\<lt>C-N>" : "\<lt>C-J>"<CR>
inoremap <C-K> <C-R>=pumvisible() ? "\<lt>C-P>" : "\<lt>C-K>"<CR>
inoremap <C-H> <C-R>=pumvisible() ? "\<lt>C-E>" : "\<lt>C-H>"<CR>
inoremap <C-L> <C-R>=pumvisible() ? "\<lt>C-Y>" : "\<lt>C-L>"<CR>

" Basic search for visually selected text: //
" https://vim.fandom.com/wiki/Search_for_visually_selected_text
vnoremap // y/\V<C-R>=escape(@",'/\')<CR><CR>
inoremap jj <ESC>
nnoremap gf :call <SID>GotoFile(expand('<cfile>'))<CR>

" <ctrl>w Pane related {{{2
nnoremap <silent> C-W><up> :silent resize -1<CR>
nnoremap <silent> C-W><down> :silent resize +1<CR>
nnoremap <silent> C-W><left> :silent vertical resize +1<CR>
nnoremap <silent> C-W><right> :silent vertical resize -1<CR>
nnoremap <silent> <C-Right> <c-w>l
nnoremap <silent> <C-Left> <c-w>h
nnoremap <silent> <C-Up> <c-w>k
nnoremap <silent> <C-Down> <c-w>j
"---------------------------------------------------------------------------2}}}

function SetLSPShortcuts()
  nnoremap <leader>gr :FindReference<CR>
  nnoremap <leader>gd :GoToDefinition<CR>
  " nnoremap <unique> <leader>r :Rename<CR>
  " nnoremap <leader>lf :DocumentFormatting<CR>
  " nnoremap <leader>lt :call LanguageClient#textDocument_typeDefinition()<CR>
  " nnoremap <leader>la :call LanguageClient_workspace_applyEdit()<CR>
  " nnoremap <leader>lh :Hover<CR>
  " nnoremap <leader>ls :call LanguageClient_textDocument_documentSymbol()<CR>
  " nnoremap <leader>lm LSPMenu<CR>
endfunction()

nnoremap <leader>b :Buffers<CR>
nnoremap <leader>a  ggvG$yggvG$"+y
nnoremap <leader>w :w!<cr>    " Fast saving
nnoremap <leader>z :Files<CR>
" nnoremap <unique> <leader>r :Rename<CR>


" <leader>h Help {{{2
"-------------------------------------------------------------------------------
" nnoremap <leader>hc :help change.txt<CR>
" nnoremap <leader>he :help editing.txt<CR>
" nnoremap <leader>hh :help<CR>
" nnoremap <leader>hi :help insert.txt<CR>
" nnoremap <leader>hm :help motion.txt<CR>
" nnoremap <leader>hr :help quickref.txt<CR>
" nnoremap <leader>hv :help visual.txt<CR>
nnoremap <leader>hw :normal yiw<ESC>:help <C-r>"<CR>
vnoremap <leader>h y<ESC> :help <C-r>"<CR>
"---------------------------------------------------------------------------1}}}

" <leader>l Linting {{{2
"-------------------------------------------------------------------------------
nnoremap <leader>l<Space> :ALELint<CR>
nnoremap <leader>lf :ALEFirst<CR>
nnoremap <leader>li :ALEInfo<CR>
nnoremap <leader>ll :ALELast<CR>
nnoremap <leader>ln :ALENext<CR>
nnoremap <leader>lp :ALEPrevious<CR>
"---------------------------------------------------------------------------1}}}

" <leader>n NERDTree {{{2
nnoremap <leader>nt :NERDTreeToggle<CR>
nnoremap <leader>nf :NERDTreeFocus<CR>
"---------------------------------------------------------------------------1}}}

" <leader>s SVN (git) commands {{{2
"-------------------------------------------------------------------------------
nnoremap <leader>s :Git<CR>
nnoremap <leader>sa :Git add %<CR>
nnoremap <leader>sc :Git commit<CR>
nnoremap <leader>spp :Git push<CR>
"---------------------------------------------------------------------------1}}}

" <leader>t Tests {{{2
"-------------------------------------------------------------------------------
nnoremap <leader>tf :TestFile<CR>
nnoremap <leader>tl :TestLast<CR>
nnoremap <leader>tn :TestNearest<CR>
nnoremap <leader>ts :TestSuite<CR>
nnoremap <leader>tv :TestVisit<CR>
"---------------------------------------------------------------------------1}}}

" <leader>y Yank {{{2
"-------------------------------------------------------------------------------
" Yank selection, word or line to system clipboard
" https://vi.stackexchange.com/questions/84/how-can-i-copy-text-to-the-system-clipboard-from-vim
nnoremap <leader>ye "+ye
nnoremap <leader>yw "+yw
nnoremap <leader>yy "+yy
vnoremap <leader>y "+y

" WSL yank support: https://superuser.com/questions/1291425
let s:clip = 'clip.exe'
if executable(s:clip)
    augroup WSLYank
        autocmd!
        autocmd TextYankPost * if v:event.operator ==# 'y' |
              \ call system(s:clip, @0) | endif
    augroup END
endif

" Search vim help for subject under cursor: K in normal mode
" set keywordprg=:help

"---------------------------------------------------------------------------1}}}

" 1}}} "General

" DVC
autocmd! BufNewFile,BufRead Dvcfile,*.dvc,dvc.lock setfiletype yaml

" setglobal omnifunc=ale#completion#OmniFunc
" setglobal omnifunc=lsc#complete#complete
"
setglobal dictionary=/usr/share/dict/british-english

if filereadable(expand('~/.vim/vimrc.local'))
  source ~/.vim/vimrc.local
endif

" set g:myopt = "yes"

" Load all of the helptags now, after plugins have been loaded.
" All messages and errors will be ignored.
" packloadall
" silent! helptags ALL


set wildmode=list:longest,full
"----------- completion chains
" set complete-=i
" set complete-=t
" remove beeps during completion
set belloff=all
set completeopt-=preview
set completeopt+=menuone,noselect,noinsert
let g:mucomplete#enable_auto_at_startup = 1

let g:xml_syntax_folding = 1

" vim:set et sw=2 fdm=marker:
