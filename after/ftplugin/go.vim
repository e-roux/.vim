
" let g:go_def_mode='gopls'
" let g:go_info_mode='gopls'

" autocmd BufWritePre *.go :call CocAction('runCommand', 'editor.action.organizeImport')

" map <leader>r yi":!go run % <C-r>"<CR>
"
" ---------------- GO ----------------------
" autocmd! BufLeave *.go syntax off


" autocmd Filetype go BufWrite :GoImports
" augroup go_file_types
" 	autocmd!
" 	autocmd FileType go setlocal omnifunc=LanguageClient#complete
" augroup END


" auto :GoImports on save
let g:go_imports_autosave = 1

" let g:go_gopls_enabled = 0


