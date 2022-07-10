" File: auto-mkdir.vim
" Maintainer: Emmanuel Roux <>
" Created: {{+~strftime("%c")+}}
" License:
" Copyright (c) {{+~g:name+}}.  Distributed under the same terms as Vim itself.
" See :help license
"
" Description:
" {{+Desc+}}
" https://stackoverflow.com/a/4294176

function s:MkNonExDir(file, buf)
    if empty(getbufvar(a:buf, '&buftype')) && a:file!~#'\v^\w+\:\/'
        let dir=fnamemodify(a:file, ':h')
        if !isdirectory(dir)
            call mkdir(dir, 'p')
        endif
    endif
endfunction
augroup BWCCreateDir
    autocmd!
    autocmd BufWritePre * :call s:MkNonExDir(expand('<afile>'), +expand('<abuf>'))
augroup END
