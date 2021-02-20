
" let g:go_def_mode='gopls'
" let g:go_info_mode='gopls'

" autocmd BufWritePre *.go :call CocAction('runCommand', 'editor.action.organizeImport')

" map <leader>r yi":!go run % <C-r>"<CR>
"
" ---------------- GO ----------------------
" autocmd! BufLeave *.go syntax off
" autocmd Filetype go BufWrite :GoImports
" auto :GoImports on save
let g:go_imports_autosave = 1
nmap <leader>tf <Plug>(go-test)
nmap <leader>tn <Plug>(go-test-func)
nmap <leader>r <Plug>(go-rename)
nmap <leader>gd <Plug>(go-def)

" let g:go_gopls_enabled = 0
"
" n  <Plug>(go-diagnostics) * :<C-U>call go#lint#Diagnostics(!g:go_jump_to_error)<CR>
" n  <Plug>(go-iferr) * :<C-U>call go#iferr#Generate()<CR>
" n  <Plug>(go-alternate-split) * :<C-U>call go#alternate#Switch(0, "split")<CR>
" n  <Plug>(go-alternate-vertical) * :<C-U>call go#alternate#Switch(0, "vsplit")<CR>
" n  <Plug>(go-alternate-edit) * :<C-U>call go#alternate#Switch(0, "edit")<CR>
" n  <Plug>(go-vet) * :<C-U>call go#lint#Vet(!g:go_jump_to_error)<CR>
" n  <Plug>(go-lint) * :<C-U>call go#lint#Golint(!g:go_jump_to_error)<CR>
" n  <Plug>(go-metalinter) * :<C-U>call go#lint#Gometa(!g:go_jump_to_error, 0)<CR>
" n  <Plug>(go-doc-browser) * :<C-U>call go#doc#OpenBrowser()<CR>
" n  <Plug>(go-doc-split) * :<C-U>call go#doc#Open("new", "split")<CR>
" n  <Plug>(go-doc-vertical) * :<C-U>call go#doc#Open("vnew", "vsplit")<CR>
" n  <Plug>(go-doc-tab) * :<C-U>call go#doc#Open("tabnew", "tabe")<CR>
" n  <Plug>(go-doc) * :<C-U>call go#doc#Open("new", "split")<CR>
" n  <Plug>(go-def-stack-clear) * :<C-U>call go#def#StackClear()<CR>
" n  <Plug>(go-def-stack) * :<C-U>call go#def#Stack()<CR>
" n  <Plug>(go-def-pop) * :<C-U>call go#def#StackPop()<CR>
" n  <Plug>(go-def-type-tab) * :<C-U>call go#def#Jump("tab", 1)<CR>
" n  <Plug>(go-def-type-split) * :<C-U>call go#def#Jump("split", 1)<CR>
" n  <Plug>(go-def-type-vertical) * :<C-U>call go#def#Jump("vsplit", 1)<CR>
" n  <Plug>(go-def-type) * :<C-U>call go#def#Jump('', 1)<CR>
" n  <Plug>(go-def-split) * :<C-U>call go#def#Jump("split", 0)<CR>
" n  <Plug>(go-def-vertical) * :<C-U>call go#def#Jump("vsplit", 0)<CR>
" n  <Plug>(go-def) * :<C-U>call go#def#Jump('', 0)<CR>
" n  <Plug>(go-decls-dir) * :<C-U>call go#decls#Decls(1, '')<CR>
" n  <Plug>(go-decls) * :<C-U>call go#decls#Decls(0, '')<CR>
" n  <Plug>(go-sameids-toggle) * :<C-U>call go#guru#ToggleSameIds()<CR>
" n  <Plug>(go-whicherrs) * :<C-U>call go#guru#Whicherrs(-1)<CR>
" n  <Plug>(go-pointsto) * :<C-U>call go#guru#PointsTo(-1)<CR>
" n  <Plug>(go-sameids) * :<C-U>call go#guru#SameIds(1)<CR>
" n  <Plug>(go-referrers) * :<C-U>call go#referrers#Referrers(-1)<CR>
" n  <Plug>(go-channelpeers) * :<C-U>call go#guru#ChannelPeers(-1)<CR>
" x  <Plug>(go-freevars) * :<C-U>call go#guru#Freevars(0)<CR>
" n  <Plug>(go-callstack) * :<C-U>call go#guru#Callstack(-1)<CR>
" n  <Plug>(go-describe) * :<C-U>call go#guru#Describe(-1)<CR>
" n  <Plug>(go-callers) * :<C-U>call go#guru#Callers(-1)<CR>
" n  <Plug>(go-callees) * :<C-U>call go#guru#Callees(-1)<CR>
" n  <Plug>(go-implements) * :<C-U>call go#implements#Implements(-1)<CR>
" n  <Plug>(go-imports) * :<C-U>call go#fmt#Format(1)<CR>
" n  <Plug>(go-import) * :<C-U>call go#import#SwitchImport(1, '',
" expand('<cword>'), '')<CR>
" n  <Plug>(go-info) * :<C-U>call go#tool#Info(1)<CR>
" n  <Plug>(go-deps) * :<C-U>call go#tool#Deps()<CR>
" n  <Plug>(go-files) * :<C-U>call go#tool#Files()<CR>
" n  <Plug>(go-coverage-browser) * :<C-U>call
" go#coverage#Browser(!g:go_jump_to_error)<CR>
" n  <Plug>(go-coverage-toggle) * :<C-U>call
" go#coverage#BufferToggle(!g:go_jump_to_error)<CR>
" n  <Plug>(go-coverage-clear) * :<C-U>call go#coverage#Clear()<CR>
" n  <Plug>(go-coverage) * :<C-U>call
" go#coverage#Buffer(!g:go_jump_to_error)<CR>
" n  <Plug>(go-test-compile) * :<C-U>call go#test#Test(!g:go_jump_to_error,
" 1)<CR>
" n  <Plug>(go-install) * :<C-U>call go#cmd#Install(!g:go_jump_to_error)<CR>
" n  <Plug>(go-generate) * :<C-U>call go#cmd#Generate(!g:go_jump_to_error)<CR>
" n  <Plug>(go-build) * :<C-U>call go#cmd#Build(!g:go_jump_to_error)<CR>
" n  <Plug>(go-run-tab) * :<C-U>call go#cmd#RunTerm(!g:go_jump_to_error, 'tabe',
" [])<CR>
" n  <Plug>(go-run-split) * :<C-U>call go#cmd#RunTerm(!g:go_jump_to_error,
" 'split', [])<CR>
" n  <Plug>(go-run-vertical) * :<C-U>call go#cmd#RunTerm(!g:go_jump_to_error,
" 'vsplit', [])<CR>
" n  <Plug>(go-run) * :<C-U>call go#cmd#Run(!g:go_jump_to_error)<CR>
"
