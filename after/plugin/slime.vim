
if exists("g:loaded_slime")
    let g:slime_target = "tmux"
    let g:slime_vimterminal_config = {"term_finish": "close"}
    let g:slime_default_config = {"socket_name": "default", "target_pane": "{last}"}
    let g:slime_python_ipython = 0
endif
