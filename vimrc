" This is my vimrc
"
" General {{{1
"##############################################################################

setglobal nocompatible          " We're running Vim, not Vi!
syntax on                 " Set syntax color on

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
setglobal textwidth=80          " Make it obvious where 80 characters is
setglobal colorcolumn=+1
setglobal autoread              " Set to auto read when a file is changed
setglobal diffopt+=vertical     " Always use vertical diffs

let &t_SI = "\e[6 q"            " steady bar, insert mode
let &t_EI = "\e[2 q"            " steady block, edit mode

if has("autocmd")
  " Redraw on VimResume
  au VimEnter,InsertLeave,VimResume *
    \ silent execute '!echo -ne "\e[2 q"' | redraw!
  au InsertEnter,InsertChange *
    \ if v:insertmode == 'i' |
    \   silent execute '!echo -ne "\e[6 q"' | redraw! |
    \ elseif v:insertmode == 'r' |
    \   silent execute '!echo -ne "\e[4 q"' | redraw! |
    \ endif
  au VimLeave * silent execute '!echo -ne "\e[ q"' | redraw!
endif

if has('unnamedplus')
  setglobal clipboard=unnamedplus
endif

let mapleader=','         " map the leader to ','

filetype on               " Enable filetype detection
filetype plugin on        " Enable filetype-specific plugins
filetype indent on        " Enable filetype-specific indenting
filetype plugin indent on " Enable filetype-specific indenting plugin

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

function! s:Saving_scroll(cmd)
  let save_scroll = &scroll
  execute 'normal! ' . a:cmd
  let &scroll = save_scroll
endfunction



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

command! ToggleFoldClose :call s:toggleFoldClose()


"##########################################################################}}}1
"Buffers {{{1
"##############################################################################
"
"  Unsaved modified buffer when opening a new file is hidden instead of closed
setglobal hidden

function! s:BufferPrev()
  let l:bufferNr = len(getbufinfo({'buflisted':1}))
  if &buftype != 'nofile' && l:bufferNr > 1
    exec('bprev')
    if &buftype == 'terminal'
      exec('bprev')
    endif
  endif
endfunction

function! s:BufferNext()
  let l:bufferNr = len(getbufinfo({'buflisted':1}))
  if &buftype != 'nofile' && l:bufferNr > 1
    exec('bnext')
    if &buftype == 'terminal'
      exec('bnext')
    endif
  endif
endfunction

function! s:BufferDelete()
  if &filetype == "help" || &filetype == "nerdtree"
    exec('bd')
  else
    " https://stackoverflow.com/questions/4465095
    let l:bufferNr = len(getbufinfo({'buflisted':1}))
    if l:bufferNr > 1
      exec('bprev|bd #')
    else
      exe('bd|Startify|NERDTree')
    endif
  endif
endfunction

" nnoremap <leader>d :bp\|bd #<CR>  " buffer previous, buffer delete alternate
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

setglobal cursorline
highlight clear CursorLine
highlight CursorLineNR cterm=bold ctermfg=yellow

" Set highlight search and map to <leader> <space>
setglobal hlsearch
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
" vnoremap <silent> gv :call VisualSelection('gv', '')<CR>

" When you press <leader>r you can search and replace the selected text
" vnoremap <silent> <leader>r :call VisualSelection('replace', '')<CR>
"
" Make sure that enter is never overriden in the quickfix window
autocmd BufReadPost quickfix nnoremap <buffer> <CR> <CR>

"##########################################################################}}}1
" User Interface Options {{{1
"##############################################################################
setglobal laststatus=2      " Always display the status bar
" setglobal statusline+=%#warningmsg#
" setglobal statusline+=%{SyntasticStatuslineFlag()}
" setglobal statusline+=%*

set number            " Show line numbers on the sidebars
setglobal noerrorbells      " Disable beep on errors
setglobal mouse=a           " Enable mouse for scrolling and resizing

"##########################################################################}}}1
" Completion {{{1
"###############################################################################

setglobal dictionary=/usr/share/dict/british-english
setglobal omnifunc=ale#completion#OmniFunc

let g:ale_completion_symbols = {
  \ 'text': '',
  \ 'method': '',
  \ 'function': '',
  \ 'constructor': '',
  \ 'field': '',
  \ 'variable': '',
  \ 'class': '',
  \ 'interface': '',
  \ 'module': '',
  \ 'property': '',
  \ 'unit': 'unit',
  \ 'value': 'val',
  \ 'enum': '',
  \ 'keyword': 'keyword',
  \ 'snippet': '',
  \ 'color': 'color',
  \ 'file': '',
  \ 'reference': 'ref',
  \ 'folder': '',
  \ 'enum member': '',
  \ 'constant': '',
  \ 'struct': '',
  \ 'event': 'event',
  \ 'operator': '',
  \ 'type_parameter': 'type param',
  \ '<default>': 'v'
  \ }
"##########################################################################}}}1
" Custom functions {{{1
"###############################################################################
:command! BadgeStars :normal i <badge-stars repo=''></badge-stars><ESC>T=
:command! BadgeStars :normal i <badge-stars repo=''></badge-stars><ESC>T=
:command! BadgeWiki :normal i <badge-wiki href=''></badge-wiki><ESC>T=
:command! BadgeDoc :normal i <badge-doc href=''></badge-doc><ESC>T=
:command! Link :normal i [🔗]()<ESC>

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
" Plugins {{{1
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
" NERDTree {{{2
"##############################################################################
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
let NERDTreeIgnore = ['__pycache__']

" Open NERDTree if no file specified
autocmd StdinReadPre * let s:std_in=1
" autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
autocmd VimEnter *
            \   if !argc()
            \ |   Startify
            \ |   NERDTree
            \ |   wincmd w
            \ | endif
"##########################################################################}}}2
" ale {{{2
"##############################################################################

let g:ale_completion_autoimport = 1
" Fix files when they are saved.
let g:ale_fix_on_save=1
" When to lint
let g:ale_lint_on_enter = 1
let g:ale_lint_on_filetype_changed = 1
let g:ale_lint_on_insert_leave = 1
let g:ale_lint_on_save = 1
let g:ale_lint_on_text_changed = 'normal'

"##########################################################################}}}2
" fzf {{{2
"##############################################################################

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
\ {
\ 'fg':      ['fg', 'Normal'],
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
\ 'header':  ['fg', 'Comment']
\ }

" Enable per-command history.
" CTRL-N and CTRL-P will be automatically bound to next-history and
" previous-history instead of down and up. If you don't like the change,
" explicitly bind the keys to down and up in your $FZF_DEFAULT_OPTS.
let g:fzf_history_dir = '~/.local/share/fzf-history'

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

augroup LanguageServerOpts
  autocmd!
  autocmd FileType yaml,python,js,c,go,vim call SetLSPShortcuts()
  " autocmd FileType yaml,python,js,c,go,vim setlocal omnifunc=LanguageClient#complete
augroup END

" DVC
autocmd! BufNewFile,BufRead Dvcfile,*.dvc,dvc.lock setfiletype yaml

let g:jedi#goto_command = '<leader>gd'
" g:goto_definitions_command = ''
autocmd FileType python setlocal completeopt-=preview

"#######################################################################}}}2
" markdown {{{2
"##############################################################################
" Activate markdown plugin
let g:markdown_folding = 1
"#######################################################################}}}2
" Python {{{2
"##############################################################################
" let g:pymode_python = 'python3'
" let g:pymode_virtualenv_path = $VIRTUAL_ENV
" let g:pymode_lint = 0
" let g:pymode_lint_checkers = ['pep8']
" " Trim unused white spaces on save.
" let g:pymode_trim_whitespaces = 1
" let g:jedi#auto_initialization=0
" Setup default python options.
"  g:pymode_options = 1
" is equivalent to:

" setlocal complete+=t
" setlocal formatoptions-=t

" Turn on the rope script
" let g:pymode_rope = 0
" Turn on code completion support in the plugin.
" let g:pymode_rope_completion = 1
" Keymap for autocomplete.
" let g:pymode_rope_completion_bind = '<C-Space>'

"##########################################################################}}}2
" SimplyFold {{{2
"##############################################################################
let g:SimpylFold_fold_import=0
let g:SimpylFold_docstring_preview=1
let g:SimpylFold_fold_docstring=0
" let g:SimpylFold_fold_blank=1
"##########################################################################}}}2
" slime {{{2
"##############################################################################

let g:slime_target = "vimterminal"
let g:slime_vimterminal_config = {"term_finish": "close"}
let g:slime_python_ipython = 1
"##########################################################################}}}2
" Startify {{{2
"##############################################################################
" read ~/.NERDTreeBookmarks file and takes its second column
function! s:nerdtreeBookmarks()
    let bookmarks = systemlist("cut -d' ' -f 2 ~/.NERDTreeBookmarks")
    let bookmarks = bookmarks[0:-2] " Slices an empty last line
    return map(bookmarks, "{'line': v:val, 'path': v:val}")
endfunction

" returns all modified files of the current git repo
" `2>/dev/null` makes the command fail quietly, so that when we are not
" in a git repo, the list will be empty
function! s:gitModified()
    let files = systemlist('git ls-files -m 2>/dev/null')
    return map(files, "{'line': v:val, 'path': v:val}")
endfunction

" same as above, but show untracked files, honouring .gitignore
function! s:gitUntracked()
    let files = systemlist('git ls-files -o --exclude-standard 2>/dev/null')
    return map(files, "{'line': v:val, 'path': v:val}")
endfunction

let g:startify_lists = [
        \ { 'type': 'files',     'header': ['   MRU']            },
        \ { 'type': 'dir',       'header': ['   MRU '. getcwd()] },
        \ { 'type': 'sessions',  'header': ['   Sessions']       },
        \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
        \ { 'type': function('s:gitModified'),  'header': ['   git modified']},
        \ { 'type': function('s:gitUntracked'), 'header': ['   git untracked']},
        \ { 'type': function('s:nerdtreeBookmarks'), 'header': ['   NERDTree Bookmarks']},
        \ { 'type': 'commands',  'header': ['   Commands']       },
        \ ]
let g:startify_bookmarks = systemlist("cut -sd' ' -f 2 ~/.NERDTreeBookmarks")
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
" vim-test {{{2
"##############################################################################
"
let test#strategy = {
  \ 'nearest': 'asyncrun_background',
  \ 'file':    'asyncrun_background_term',
  \ 'suite':    'asyncrun_background_term',
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

"###############################################################################
" KEY BINDINGS
"###############################################################################
" vnoremap <F6> "gy<Esc>:call GoogleSearch()<CR>
nnoremap <C-h> :call <SID>BufferPrev()<CR>
nnoremap <C-l> :call <SID>BufferNext()<CR>

nnoremap <C-J> :call <SID>Saving_scroll("1<C-V><C-D>")<CR>
nnoremap <C-K> :call <SID>Saving_scroll("1<C-V><C-U>")<CR>
vnoremap <C-J> <Esc>:call <SID>Saving_scroll("gv1<C-V><C-D>")<CR>
vnoremap <C-K> <Esc>:call <SID>Saving_scroll("gv1<C-V><C-U>")<CR>

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

" <ctrl>w Pane related {{{1
"-------------------------------------------------------------------------------
noremap <silent> <C-w>h :TmuxNavigateLeft<cr>
noremap <silent> <C-w>j :TmuxNavigateDown<cr>
noremap <silent> <C-w>k :TmuxNavigateUp<cr>
noremap <silent> <C-w>l :TmuxNavigateRight<cr>
noremap <silent> <C-w>\ :TmuxNavigatePrevious<cr>
"---------------------------------------------------------------------------1}}}

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
nnoremap <leader>e :NERDTreeToggle<CR>
nnoremap <leader>d :call <SID>BufferDelete()<CR>
nnoremap <leader>a  ggvG$yggvG$"+y
nnoremap <leader>w :w!<cr>    " Fast saving
nnoremap <leader>z :Files<CR>
nnoremap <unique> <leader>r :Rename<CR>
" ---------------- C ----------------------
autocmd FileType c nnoremap <leader>r :!clear && gcc % -o %< && %< && read<cr>

" <leader>h Help {{{1
"-------------------------------------------------------------------------------
nnoremap <leader>hc :help change.txt<CR>
nnoremap <leader>he :help editing.txt<CR>
nnoremap <leader>hh :help<CR>
nnoremap <leader>hi :help insert.txt<CR>
nnoremap <leader>hm :help motion.txt<CR>
nnoremap <leader>hr :help quickref.txt<CR>
nnoremap <leader>hv :help visual.txt<CR>
nnoremap <leader>hw :normal yt <ESC> :help <C-r>"<CR>
vnoremap <leader>h y<ESC> :help <C-r>"<CR>
"---------------------------------------------------------------------------1}}}
" <leader>l Linting {{{1
"-------------------------------------------------------------------------------
nnoremap <leader>l<Space> :ALELint<CR>
nnoremap <leader>lf :ALEFirst<CR>
nnoremap <leader>li :ALEInfo<CR>
nnoremap <leader>ll :ALELast<CR>
nnoremap <leader>ln :ALENext<CR>
nnoremap <leader>lp :ALEPrevious<CR>

"---------------------------------------------------------------------------1}}}
" <leader>s SVN (git) commands {{{1
"-------------------------------------------------------------------------------
nnoremap <leader>s :Git<CR>
nnoremap <leader>sa :Git add %<CR>
nnoremap <leader>sc :Git commit<CR>
nnoremap <leader>spp :Git push<CR>
"---------------------------------------------------------------------------1}}}
" <leader>t Tests {{{1
"-------------------------------------------------------------------------------
nnoremap <leader>tf :TestFile<CR>
nnoremap <leader>tl :TestLast<CR>
nnoremap <leader>tn :TestNearest<CR>
nnoremap <leader>ts :TestSuite<CR>
nnoremap <leader>tv :TestVisit<CR>
"---------------------------------------------------------------------------1}}}
" <leader>y Yank {{{1
"-------------------------------------------------------------------------------
" Yank selection, word or line to system clipboard
" https://vi.stackexchange.com/questions/84/how-can-i-copy-text-to-the-system-clipboard-from-vim
nnoremap <leader>ye "+ye
nnoremap <leader>yw "+yw
nnoremap <leader>yy "+yy
vnoremap <leader>y "+y

" Search vim help for subject under cursor: K in normal mode
" set keywordprg=:help

"---------------------------------------------------------------------------1}}}

if filereadable(expand('~/.vim/vimrc.local'))
  source ~/.vim/vimrc.local
endif

" Load all of the helptags now, after plugins have been loaded.
" All messages and errors will be ignored.
packloadall
silent! helptags ALL


" vim:set et sw=2 fdm=marker:
