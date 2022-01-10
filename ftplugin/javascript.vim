" ---------------- JS ----------------------

autocmd! BufNewFile,BufReadPost *.{js,ts,json} set filetype=javascript foldmethod=expr
autocmd! BufNewFile,BufRead *.{js,html,css} set tabstop=2 softtabstop=2 shiftwidth=2
"-- FOLDING --
" set foldmethod=syntax "syntax highlighting items specify folds
" set foldcolumn=1 "defines 1 col at window left, to indicate folding
" let javaScript_fold=1 "activate folding by JS syntax
set foldlevelstart=0 "start file with all folds opened
set filetype=javascript foldmethod=expr

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

" autocmd FileType javascript syntax region braceFold start="{" end="}" transparent fold
" autocmd FileType javascript setlocal foldexpr=JSFolds()
" autocmd FileType javascript setlocal foldlevel=1

map <leader>r yi":!npm run <C-r>"<CR>
autocmd FileType javascript nnoremap <leader>r :!node %<cr>

let b:ale_fixers = ['prettier']
let b:ale_linters = ['tsserver', 'eslint']
