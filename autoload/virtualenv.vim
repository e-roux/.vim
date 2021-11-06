
function! virtualenv#activate(...)
  let l:virtualenv_list = virtualenv#names('')
  if len(l:virtualenv_list) == 1
    echo "Activate ".l:virtualenv_list[0]
    let $PATH =  l:virtualenv_list[0]."/bin:".$PATH
  endif
endfunction

function! virtualenv#activate_bla(...)
    let name   = a:0 > 0 ? a:1 : ''
    let silent = a:0 > 1 ? a:2 : 0
    let env_dir = ''
    if len(name) == 0  "Figure out the name based on current file
        if isdirectory($VIRTUAL_ENV)
            let name = fnamemodify($VIRTUAL_ENV, ':t')
            let env_dir = $VIRTUAL_ENV
        elseif isdirectory($PROJECT_HOME)
            let fn = expand('%:p')
            let pat = '^'.$PROJECT_HOME.'/'
            if fn =~ pat
                let name = fnamemodify(substitute(fn, pat, '', ''), ':h')
                if name != '.'  "No project directory
                    let env_dir = g:virtualenv_directory.'/'.name
                endif
            endif
        endif
    else
        let env_dir = g:virtualenv_directory.'/'.name
    endif

    "Couldn't figure it out, so DIE
    if !isdirectory(env_dir)
        if !silent
            echoerr "No virtualenv could be auto-detected and activated."
        endif
        return
    endif

    let bin = env_dir.'/bin'
    call virtualenv#deactivate()

    let s:prev_path = $PATH

    let g:virtualenv_name = name
    let $VIRTUAL_ENV = env_dir

endfunction

function! virtualenv#deactivate()

    call system(deactivate)

    unlet! g:virtualenv_name

    let $VIRTUAL_ENV = '' " can't delete parent variables

    if exists('s:prev_path')
        let $PATH = s:prev_path
    endif

    " if exists("*airline#extensions#virtualenv#update")
    "        call airline#extensions#virtualenv#update()
    " endif
endfunction

function! virtualenv#list()
    for name in virtualenv#names('')
        echo name
    endfor
endfunction

function! virtualenv#statusline()
    if exists('g:virtualenv_name')
        " Status line format
        return substitute(get(g:, "virtualenv_stl_format", "%n"), '\C%n', g:virtualenv_name, 'g')
    else
        return ''
    endif
endfunction

function! virtualenv#names(prefix)
    let venvs = []
    for fn in split(system('fd -HIp "bin/activate$"'), '\n')
        if !filereadable(fn)
            continue
        endif
        call add(venvs, expand(fnamemodify(fn, ':p:h:h')))
    endfor
    return venvs
endfunction
