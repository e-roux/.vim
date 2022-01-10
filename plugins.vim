" File: plugins.vim
" Maintainer: Emmanuel Roux <>
" Created: Sam  1 jan 12:35:47 2022
" License:
" Copyright (c) Emmanuel Roux.  Distributed under the same terms as Vim itself.
" See :help license
"
" Description:
" Desc

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
  " Interface · tagbar
  call minpac#add('preservim/tagbar')

  "Source version control
  call minpac#add('airblade/vim-gitgutter')
  call minpac#add('tpope/vim-fugitive')
  " call minpac#add('mattn/gist-vim')

  " Code edition
  call minpac#add('e-roux/vim-minisnip', { 'branch': 'optionalautoindent' })
  call minpac#add('lifepillar/vim-mucomplete')

  call minpac#add('jiangmiao/auto-pairs', {'type': 'opt'})
  call minpac#add('dhruvasagar/vim-table-mode')

  call minpac#add('tpope/vim-commentary')
  call minpac#add('tpope/vim-surround')
  " call minpac#add('ThePrimeagen/refactoring.nvim')
  " deps of refactoring.nvim
  " call minpac#add('nvim-lua/plenary.nvim')
  " call minpac#add('nvim-treesitter/nvim-treesitter')

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

  call minpac#add('robertbasic/vim-hugo-helper')
  call minpac#add('phelipetls/vim-hugo')

  call minpac#add('skywind3000/asyncrun.vim') " dependency of vim-test
  " call minpac#add('tpope/vim-scriptease')
  " call minpac#add('mattn/webapi-vim') " dependency of gist

  call minpac#add('neovim/nvim-lspconfig')

endfunction


function! s:install_minpac() abort
  let l:packdir = split(&packpath, ',')[0]
  let l:minipac_src_url = 'https://github.com/k-takata/minpac.git'
  "
  let job = system(["/bin/sh", "-c", "echo hello"])
endfunction


command! -bar PackUpdate call PackInit() | call minpac#update('', {'do': 'call minpac#status()'})
command! -bar PackClean  call PackInit() | call minpac#clean()
command! -bar PackStatus call PackInit() | call minpac#status()


" Configuration {{{1
" Argumentative {{{2
" https://github.com/PeterRincker/vim-argumentative
let g:argumentative_no_mappings = 1
nmap <localleader>ah <Plug>Argumentative_MoveLeft
nmap <localleader>al <Plug>Argumentative_MoveRight
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
imap <Nop> <Plug>(minisnip-complete)
let g:name = 'Emmanuel Roux'
let g:email = ''
" let g:miniSnip_trigger = '<C-F4>'
let g:minisnip_finalstartdelim = '{{_'
let g:minisnip_finalenddelim = '_}}'
let g:minisnip_autoindent = 0
let g:minisnip_trigger = '<CR>'
let g:minisnip_dir = join([
      \ expand('%:p:h') . '/extra/snip',
      \ expand('~/.vim/extra/snip')
      \], ":")

" }}}2
" Mucomplete {{{2
let g:mucomplete#user_mappings = {
      \ 'mini': "\<C-r>=minisnip#complete()\<CR>",
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
let g:table_mode_map_prefix="<localleader>t"
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
" 2}}}
" 1}}}
" vim:set et sw=2 fdm=marker:
