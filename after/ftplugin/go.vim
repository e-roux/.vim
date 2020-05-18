autocmd BufWritePre *.go :call CocAction('runCommand', 'editor.action.organizeImport')

map <leader>r yi":!go run % <C-r>"<CR>
