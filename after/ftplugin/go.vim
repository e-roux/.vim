
let g:go_def_mode='gopls'
let g:go_info_mode='gopls'

autocmd BufWritePre *.go :call CocAction('runCommand', 'editor.action.organizeImport')

map <leader>r yi":!go run % <C-r>"<CR>
