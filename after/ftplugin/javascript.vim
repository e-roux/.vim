" ---------------- JS ----------------------

autocmd! BufNewFile,BufReadPost *.{js,ts,json}
      \ set filetype=javascript foldmethod=expr

autocmd! BufNewFile,BufRead *.{js,html,css}
    \ set tabstop=2
    \ set softtabstop=2
    \ set shiftwidth=2

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
autocmd FileType javascript setlocal foldexpr=JSFolds()
autocmd FileType javascript setlocal foldlevel=1

map <leader>r yi":!npm run <C-r>"<CR>
autocmd FileType javascript nnoremap <leader>r :!node %<cr>
