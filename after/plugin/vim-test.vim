
if exists("g:loaded_test")
    let test#strategy = {
    \ 'nearest': 'asyncrun_background',
    \ 'file':    'asyncrun_background_term',
    \ 'suite':    'asyncrun_background_term',
    \}

    function! s:syncrun_background_buff(cmd) abort
    let g:test#strategy#cmd = a:cmd
    call test#strategy#asyncrun_setup_unlet_global_autocmd()
    execute 'AsyncRun -mode=term -focus=0 -post=echo\ eval("g:asyncrun_code\ ?\"Failure\":\"Success\"").":"'
            \ .'\ substitute(g:test\#strategy\#cmd,\ "\\",\ "",\ "") '.a:cmd
    endfunction
    let g:test#custom_strategies = {'echo': function('s:syncrun_background_buff')}
    let g:test#strategy = 'echo'
endif

