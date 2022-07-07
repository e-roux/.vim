" This is my vimrc, borrowed from various places

" Init: {{{1

if has('nvim')
  set runtimepath^=~/.vim runtimepath+=~/.vim/after
else
  let g:lspconfig = 1
endif

" Disable extra plugins
let g:loaded_2html_plugin       =  1
let g:loaded_gzip               =  1
let g:loaded_netrw              =  1
let g:loaded_netrwPlugin        =  1
let g:loaded_remote_plugins     =  1
let g:loaded_rrhelper           =  1
let g:loaded_tarPlugin          =  1
let g:loaded_zipPlugin          =  1
"
" source plugins install and configuration
source ~/.vim/plugins.vim

if has('nvim')
  lua require("lspconfig")
endif

" }}}1 "Init

" General {{{1

set nocompatible                " We're running Vim
set history=500                 " number of command-lines that are remembered

" Enables syntax color and ftplugin, see :h filetype-overview
syntax enable                   " Set syntax color on

" Set cache dir and creates it if does not exists
set dir=~/.cache/vim
if !isdirectory(&dir) | call mkdir(&dir) | endif

" Indentation {{{2
" Enable filetype-specific indenting plugin
filetype plugin indent on

" number of spaces that <Tab> in file uses
set tabstop=4
" Convert tabs to spaces
set expandtab
set softtabstop=2               " number of spaces used by <Tab> while editing
set shiftwidth=0                " number of spaces to use for (auto)indent step

set autoindent                  " New lines inherit indentation of prev. line
set smartindent
set shiftround                  " Round indent to multiple of 'shiftwidth'
" }}}2

set autoread                    " Set to auto read when a file is changed
set backspace=indent,eol,start  " Backspace deletes in insert mode, see h:bs

set belloff=all

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

" Delete other buffers only
nnoremap <silent> <leader>do :%bd\|e#\|bd#<CR>

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

" General Mappings: {{{1

" Move comment to column (33)
" explanation:
"   - ident the line: ==
"   - mark the position to p
"   - go to begin of line and search ": 0f"
"   - delete to end of line and insert 32 space: D32i <ESC>
"   - go to begin of line back to col 33: 033|
"   - paste buffer and remove trailing characters: P:s/\s*$//<CR>
"   - go to mark p: `p
"   - no highlight search: :nohlsearch<CR>
noremap <localleader>" ==mp0f"D32i <Esc>033\|P:s/\s*$//<CR>`p:nohlsearch<CR>
" TODO: buffer specific comment string, using commentstring
" noremap <buffer> <localleader>" :execute "normal! '==mp0f' . split(&commentstring, '%s')[0] . 'D32i <Esc>033\|P:s/\s*$//<CR>`p:nohlsearch<CR>'"

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

" <leader>c quickfix {{{2
nnoremap <leader>co :copen<CR>
nnoremap <leader>cc :cclose<CR>
" 2}}}

" <leader>y Yank {{{2
" Yank selection, word or line to system clipboard
" https://vi.stackexchange.com/questions/84/how-can-i-copy-text-to-the-system-clipboard-from-vim
nnoremap <leader>ye "+ye
nnoremap <leader>yw "+yw
nnoremap <leader>yy "+yy
vnoremap <leader>y "+y
" }}}2

" <leader>p Paste {{{2
nnoremap <leader>p "+p
nnoremap <leader>P "+P
" 2}}}

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

" LSP {{{2
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>w :w!<cr>    " Fast saving
nnoremap <leader>z :Files<CR>
" 2}}}

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
"
"---------------------------------------------------------------------------2}}}

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
" }}}1 "General

set dictionary=/usr/share/dict/british-english

if filereadable(expand('~/.vim/vimrc.local'))
  source ~/.vim/vimrc.local
endif

" Load all of the helptags now, after plugins have been loaded.
" All messages and errors will be ignored.
" packloadall
" silent! helptags ALL

set wildmode=list:longest,full
"----------- completion chains
" set complete-=i
" set complete-=t
" remove beeps during completion

set shortmess+=c                " Shut off completion messages
set belloff+=ctrlg              " If Vim beeps during completion

set pumheight=10

set completeopt-=preview
set completeopt+=menuone,noselect,noinsert

if ! has('nvim')
  let g:mucomplete#enable_auto_at_startup = 1
  packadd vim-mucomplete
end

" vim:set et sw=2 fdm=marker:
