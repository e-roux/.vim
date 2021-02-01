
if exists('g:loaded_mkdocs') || &cp
  finish
endif
let g:loaded_mkdocs = 1

" Section: Commands
"
command! Mkdocs :Files ~/development/gwin-zegal.github.io/
