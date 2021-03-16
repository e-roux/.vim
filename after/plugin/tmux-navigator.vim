
"
if exists("g:loaded_tmux_navigator")
    noremap <silent> <C-w><C-h> :TmuxNavigateLeft<cr>
    noremap <silent> <C-w><C-j> :TmuxNavigateDown<cr>
    noremap <silent> <C-w><C-k> :TmuxNavigateUp<cr>
    noremap <silent> <C-w><C-l> :TmuxNavigateRight<cr>
    noremap <silent> <C-w>h :TmuxNavigateLeft<cr>
    noremap <silent> <C-w>j :TmuxNavigateDown<cr>
    noremap <silent> <C-w>k :TmuxNavigateUp<cr>
    noremap <silent> <C-w>l :TmuxNavigateRight<cr>
    noremap <silent> <C-w>\ :TmuxNavigatePrevious<cr>
endif
