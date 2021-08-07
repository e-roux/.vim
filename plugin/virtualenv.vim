if exists('g:loaded_virtualenv')
    finish
endif
let g:loaded_virtualenv = 1

" Only python3
if !has('python3')
    finish
endif

let s:save_cpo = &cpo
set cpo&vim

if !exists("g:virtualenv_auto_activate")
    let g:virtualenv_auto_activate = 0
endif

if !exists("g:virtualenv_stl_format")
    let g:virtualenv_stl_format = '%n'
endif

if !exists("g:virtualenv_directory")
    if isdirectory($WORKON_HOME)
        let g:virtualenv_directory = $WORKON_HOME
    elseif filereadable("Makefile")
        let s:srv_branch = trim(system('git branch --show-current'))
        let g:virtualenv_directory = '.work'
        " let g:virtualenv_directory = '.work/.venv-'.s:srv_branch
    else
        let g:virtualenv_directory = '~/.venv'
    endif
endif

let g:virtualenv_directory = expand(g:virtualenv_directory)

command! -bar VirtualEnvList :call virtualenv#list()
command! -bar VirtualEnvDeactivate :call virtualenv#deactivate()
command! -bar -nargs=? -complete=customlist,s:CompleteVirtualEnv VirtualEnvActivate :call virtualenv#activate(<q-args>)

function! s:Error(message)
    echohl ErrorMsg | echo a:message | echohl None
endfunction

function! s:CompleteVirtualEnv(arg_lead, cmd_line, cursor_pos)
    return virtualenv#names(a:arg_lead)
endfunction

" DEPRECATED: Leaving in for compatibility
function! VirtualEnvStatusline()
    return virtualenv#statusline()
endfunction

if g:virtualenv_auto_activate == 1
    call virtualenv#activate('', 1)
endif

let &cpo = s:save_cpo
