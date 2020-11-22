" setlocal foldmethod=indent
" setlocal foldnestmax=2

func! FoldIndent() abort
    let indent = indent(v:lnum)/&sw
    let indent_next = indent(nextnonblank(v:lnum+1))/&sw
    if indent_next > indent && getline(v:lnum) !~ '^\s*$'
        return ">" . (indent+1)
    elseif indent != 0
        return indent
    else
        return -1
    endif
endfunc

" setlocal foldexpr=FoldIndent()
" setlocal foldmethod=expr

" let g:ale_python_black_executable="johnny"
function! MyFoldText()
    let nblines = v:foldend - v:foldstart + 1
    " let w = winwidth(0) - &foldcolumn - (&number ? 8 : 0)
    let w = 80
    let line = getline(v:foldstart)
    let comment = substitute(line, '/\*\|\*/\|{{{\d\=', '', 'g')
    let expansionString = repeat(".", w - strwidth(nblines.comment.'"'))
    let txt = '' . comment . expansionString . nblines
    return txt
endfunction
set foldtext=MyFoldText()
