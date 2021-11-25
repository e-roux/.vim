" This is my vimrc, borrowed from various places

" Init: {{{1

if has('nvim')
  set runtimepath^=~/.vim runtimepath+=~/.vim/after
else
  let g:lspconfig = 1
endif

" Use minpac as pkg manager
function! PackInit() abort
  try
    packadd minpac
  catch /.*/ " catch error E123
    echoc "minpac is not installed, no package will be installed"
  endtry

  call minpac#init()

  " Interface
  call minpac#add('vim-airline/vim-airline')
  call minpac#add('christoomey/vim-tmux-navigator')
  call minpac#add('dhruvasagar/vim-zoom')
  call minpac#add('tmhedberg/SimpylFold')
  " Interface · nerdtree
  call minpac#add('preservim/nerdtree')
  call minpac#add('ryanoasis/vim-devicons')
  " Interface · startify
  call minpac#add('mhinz/vim-startify')

  "Source version control
  call minpac#add('airblade/vim-gitgutter')
  call minpac#add('tpope/vim-fugitive')
  " call minpac#add('mattn/gist-vim')

  " Code edition
  call minpac#add('e-roux/vim-minisnip', { 'branch': 'optionalautoindent' })
  " call minpac#add('Jorengarenar/miniSnip')
  call minpac#add('lifepillar/vim-mucomplete')
  call minpac#add('jonasw234/vim-mucomplete-minisnip')

  call minpac#add('jiangmiao/auto-pairs', {'type': 'opt'})
  call minpac#add('dhruvasagar/vim-table-mode')

  call minpac#add('tpope/vim-commentary')
  call minpac#add('tpope/vim-surround')
  " manipulating and moving between function arguments
  call minpac#add('PeterRincker/vim-argumentative')

  " Linting
  call minpac#add('dense-analysis/ale')

  " Tests
  call minpac#add('vim-test/vim-test')

  " Buffer to REPL
  call minpac#add('jpalardy/vim-slime')

  call minpac#add('junegunn/fzf')
  call minpac#add('junegunn/fzf.vim')

  " Themes
  call minpac#add('morhetz/gruvbox', {'type': 'opt'}) " gruvbox theme
  call minpac#add('lifepillar/vim-solarized8')
  call minpac#add('vim-airline/vim-airline-themes')

  " DB related
  call minpac#add('tpope/vim-dadbod')
  call minpac#add('kristijanhusak/vim-dadbod-ui')

  " Vim sugar for the UNIX shell commands
  call minpac#add('tpope/vim-eunuch')

  " language specific
  call minpac#add('davidhalter/jedi-vim')
  call minpac#add('jelera/vim-javascript-syntax')
  " call minpac#add('leafgarland/typescript-vim')
  call minpac#add('rust-lang/rust.vim')
  call minpac#add('fatih/vim-go')
  call minpac#add('cespare/vim-toml')

  call minpac#add('skywind3000/asyncrun.vim') " dependency of vim-test
  " call minpac#add('tpope/vim-scriptease')
  " call minpac#add('mattn/webapi-vim') " dependency of gist

  call minpac#add('neovim/nvim-lspconfig')

endfunction

"
function! s:install_minpac() abort
  let l:packdir = split(&packpath, ',')[0]
  let l:minipac_src_url = 'https://github.com/k-takata/minpac.git'
  "
  let job = system(["/bin/sh", "-c", "echo hello"])
endfunction


command! -bar PackUpdate call PackInit() | call minpac#update('', {'do': 'call minpac#status()'})
command! -bar PackClean  call PackInit() | call minpac#clean()
command! -bar PackStatus call PackInit() | call minpac#status()

" Disable extra plugins
let g:loaded_2html_plugin       =  1
let g:loaded_gzip               =  1
let g:loaded_netrw              =  1
let g:loaded_netrwPlugin        =  1
let g:loaded_remote_plugins     =  1
let g:loaded_rrhelper           =  1
let g:loaded_tarPlugin          =  1
let g:loaded_zipPlugin          =  1



if has('nvim')
  lua require("lspconfig")
endif

" }}}1 "Init

" General {{{1

set nocompatible          " We're running Vim
set history=500           " number of command-lines that are remembered

" Enables syntax color and ftplugin, see :h filetype-overview
syntax enable                       " Set syntax color on

" Set cache dir and creates it if does not exists
set dir=~/.cache/vim
if !isdirectory(&dir) | call mkdir(&dir) | endif

" Indentation {{{2
filetype plugin indent on       " Enable filetype-specific indenting plugin

set tabstop=4                   " number of spaces that <Tab> in file uses
set expandtab                   " Convert tabs to spaces
set softtabstop=2               " number of spaces used by <Tab> while editing
set shiftwidth=0                " number of spaces to use for (auto)indent step

set autoindent                  " New lines inherit indentation of prev. line
set smartindent
set shiftround                  " Round indent to multiple of 'shiftwidth'
" }}}2

set autoread                    " Set to auto read when a file is changed
set backspace=indent,eol,start  " Backspace deletes in insert mode, see h:bs

set colorcolumn=80              " Make it obvious where 80 characters is
set diffopt+=vertical           " Always use vertical diffs
set nojoinspaces                " Use one space, not two, after punctuation.
set textwidth=0

if has('unnamedplus') | set clipboard=unnamedplus | endif

let mapleader=','               " map the leader to ','
let maplocalleader=';'          " map the localleader to ';'

set hidden                      " Unsaved modified buffer when opening a new
                                " file is hidden instead of closed

set number                      " Show line numbers on the sidebars
set nrformats-=octal

set noerrorbells                " Disable beep on errors
set mouse=a                     " Enable mouse for scrolling and resizing

set laststatus=2                " Always display the status bar

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

" }}}1

" Appearence and status bar {{{1

" see :help xterm-true-color
if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

set cursorline
highlight clear CursorLine
highlight CursorLineNR cterm=bold ctermfg=yellow

source ~/.vim/colors/background.vim

" Theme
" let g:solarized_termcolors=256
let s:terminal_italic=1
colorscheme solarized8
" colorscheme gruvbox

" Set highlight search
set hlsearch
" Map 'stop highligting' to <leader><space>
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

" }}}1

" Folding {{{1

" nnoremap z1 :set foldlevel=1<CR>
" nnoremap z2 :set foldlevel=2<CR>
" nnoremap z3 :set foldlevel=3<CR>
" nnoremap z4 :set foldlevel=4<CR>

" augroup vimrc
"   autocmd!
"   autocmd BufEnter * for f in ['vimrc', 'zshrc', 'tmux.conf'] | if @% =~ f | set foldmethod=marker | endif | endfor
" augroup END

" set foldopen&
" function! s:toggleFoldClose()
"   " toggle automatic folds close when you move out of it
"   if &foldclose ==? 'all'
"     set foldclose&vim
"   else
"     set foldclose=all
"   endif
" endfunction

" command! ToggleFoldClose :call <SID>toggleFoldClose()


" }}}1

" Panes  {{{1

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

" }}}1

" User Interface Options {{{1

" setglobal statusline+=%#warningmsg#
" setglobal statusline+=%{SyntasticStatuslineFlag()}
" setglobal statusline+=%*
" }}}1

" Plugins {{{1

" Airline {{{2
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
" }}}2
" Argumentative {{{2
" https://github.com/PeterRincker/vim-argumentative
let g:argumentative_no_mappings = 1
nmap <leader>ah <Plug>Argumentative_MoveLeft
nmap <leader>al <Plug>Argumentative_MoveRight
" }}}2
" dbui {{{2
let g:db_ui_use_nerd_fonts=1
" }}}2
" gitgutter {{{2
" let g:gitgutter_enabled = 1
" set signcolumn=yes
"
" let g:gitgutter_override_sign_column_highlight = 1
" }}}2
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

" }}}2
" Minisnip {{{2
let g:minisnip_autoindent = 0
let g:minisnip_trigger = '<CR>'
imap <Nop> <Plug>(minisnip-complete)
let g:name = 'Emmanuel Roux'
let g:email = '15956441+fesaille@users.noreply.github.com'
" let g:miniSnip_trigger = '<C-F4>'
let g:minisnip_dir = join([
      \ expand('%:p:h') . '/extra/snip',
      \ expand('~/.vim/extra/snip/all')
      \], ":")

augroup bla
autocmd FileType * let g:minisnip_dir .= ':' . expand('~/.vim/extra/snip/') . &filetype
augroup END

" let g:minisnip_dir = s:snipdir . ':' . join(split(glob( s:snipdir . '**/'), '\n'), ':')
" }}}2
" Mucomplete {{{2
let g:mucomplete#user_mappings = {
      \ 'mini': "\<C-r>=MUcompleteMinisnip#complete()\<CR>",
      \ }
let g:mucomplete#chains   =  {
      \ 'default': ['mini',  'list',  'omni',  'path',  'c-n',   'uspl'],
      \ '.*string.*': ['uspl'],
      \ '.*comment.*': ['uspl'],
      \ 'zsh': ['mini'],
      \ 'go': ['list', 'omni', 'c-n']
      \ }
" let g:mucomplete#no_mappings = 1
" }}}2
" NERDTree {{{2
"##############################################################################
" Those must be set before NERDTree is loaded
let g:NERDTreeDirArrows = '▸'
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'
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

nnoremap <localleader>db :NERDTreeClose \| DBUIToggle<CR>

" }}}2
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

" }}}2
" nnn{{{2
"##############################################################################
let g:nnn#layout = { 'left': '~20%' }
" }}}2
" SimplyFold {{{2
"
let g:SimpylFold_fold_import=0
let g:SimpylFold_docstring_preview=1
let g:SimpylFold_fold_docstring=0
" let g:SimpylFold_fold_blank=1
" }}}2
" Table mode {{{2
let g:table_mode_disable_tableize_mappings=1
" }}}2
" Tmux Navigator {{{2
" https://github.com/christoomey/vim-tmux-navigator
"
let g:tmux_navigator_no_mappings = 1 " Navigation
" Disable tmux navigator when zooming the Vim pane
let g:tmux_navigator_disable_when_zoomed = 1

" }}}2
" vim-test {{{2
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
" }}}2

" }}}1 "Plugins

" General Mappings: {{{1

noremap <localleader>" 0f"Di                              <Esc>033\|P:s/\s*$//<CR>0
"
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
" }}}2

" Insert Completion mode
" h popupmenu-keys
" inoremap <C-J> <C-R>=pumvisible() ? "\<lt>C-N>" : "\<lt>C-J>"<CR>
" inoremap <C-K> <C-R>=pumvisible() ? "\<lt>C-P>" : "\<lt>C-K>"<CR>
" inoremap <C-H> <C-R>=pumvisible() ? "\<lt>C-E>" : "\<lt>C-H>"<CR>
" inoremap <C-L> <C-R>=pumvisible() ? "\<lt>C-Y>" : "\<lt>C-L>"<CR>

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
"---------------------------------------------------------------------------}}}2

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
nnoremap <leader>w :w!<cr>    " Fast saving
nnoremap <leader>z :Files<CR>
" nnoremap <unique> <leader>r :Rename<CR>

" <leader>e Execute {{{2

" }}}2

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
"---------------------------------------------------------------------------}}}1

" <leader>l Linting {{{2
nnoremap <leader>l<Space> :ALELint<CR>
nnoremap <leader>lf :ALEFirst<CR>
nnoremap <leader>li :ALEInfo<CR>
nnoremap <leader>ll :ALELast<CR>
nnoremap <leader>ln :ALENext<CR>
nnoremap <leader>lp :ALEPrevious<CR>
" }}}2

" <leader>n NERDTree {{{2
nnoremap <leader>nt :NERDTreeToggle<CR>
nnoremap <leader>nf :NERDTreeFocus<CR>
" }}}2

" <leader>s SVN (git) commands {{{2
nnoremap <leader>s :Git<CR>
nnoremap <leader>sa :Git add %<CR>
nnoremap <leader>sc :Git commit<CR>
nnoremap <leader>spp :Git push<CR>
" }}}2

" <leader>t Tests {{{2
nnoremap <leader>tf :TestFile<CR>
nnoremap <leader>tl :TestLast<CR>
nnoremap <leader>tn :TestNearest<CR>
nnoremap <leader>ts :TestSuite<CR>
nnoremap <leader>tv :TestVisit<CR>
" }}}2

" <leader>y Yank {{{2
" Yank selection, word or line to system clipboard
" https://vi.stackexchange.com/questions/84/how-can-i-copy-text-to-the-system-clipboard-from-vim
nnoremap <leader>ye "+ye
nnoremap <leader>yw "+yw
nnoremap <leader>yy "+yy
vnoremap <leader>y "+y
" }}}2

" }}}1 "General

set dictionary=/usr/share/dict/british-english

if filereadable(expand('~/.vim/vimrc.local'))
  source ~/.vim/vimrc.local
endif

" Load all of the helptags now, after plugins have been loaded.
" All messages and errors will be ignored.
" packloadall
" silent! helptags ALL

nnoremap <leader>q <Plug>(miniSnip)

set wildmode=list:longest,full
"----------- completion chains
" set complete-=i
" set complete-=t
" remove beeps during completion

set shortmess+=c    " Shut off completion messages
set belloff+=ctrlg  " If Vim beeps during completion

set belloff=all
set completeopt-=preview
set completeopt+=menuone,noselect,noinsert
let g:mucomplete#enable_auto_at_startup = 1

" vim:set et sw=2 fdm=marker:
