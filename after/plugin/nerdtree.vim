if exists("g:loaded_nerd_tree")
    " Open NERDTree and Startify if no file specified
    autocmd StdinReadPre * let s:std_in=1

    autocmd VimEnter *
        \ if !argc() && !exists("s:std_in") && exists("g:loaded_nerd_tree") |
        \ NERDTree | wincmd w | endif

endif
