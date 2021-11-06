if exists('g:loaded_virtualenv') | finish | endif

let g:loaded_virtualenv = 1

" Only python3
if !has('python3') || !executable('fd')| finish | endif

let s:save_cpo = &cpo
set cpo&vim

if !exists("g:virtualenv_directory")
    if filereadable("Makefile")
        let s:srv_branch = trim(system('git branch --show-current'))
        let g:virtualenv_directory = '.work/.venv-'.s:srv_branch
    else
        let g:virtualenv_directory = '~/.venv'
    endif
endif

let g:virtualenv_directory = expand(g:virtualenv_directory)

command! -bar VirtualEnvList :call virtualenv#list()
command! -bar VirtualEnvDeactivate :call virtualenv#deactivate()
command! -bar -nargs=? -complete=customlist,s:CompleteVirtualEnv VirtualEnvActivate :call virtualenv#activate(<q-args>)

function! s:CompleteVirtualEnv(arg_lead, cmd_line, cursor_pos)
    return virtualenv#names(a:arg_lead)
endfunction

if get(g:, "virtualenv_auto_activate", 0) == 1
    call virtualenv#activate('', 1)
endif

let &cpo = s:save_cpo
