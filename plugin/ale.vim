
if !exists('g:ale_enabled') || g:ale_enabled == 0
  finish
endif


augroup LazyLoadAle
    autocmd!
    autocmd VimEnter *
                \ packadd ale |
                \ call LoadAle() |
                \ autocmd! LazyLoadAle
augroup end

function! LoadAle()

    let g:ale_completion_symbols = {
    \ 'text': '',
    \ 'method': '',
    \ 'function': '',
    \ 'constructor': '',
    \ 'field': '',
    \ 'variable': '',
    \ 'class': '',
    \ 'interface': '',
    \ 'module': '',
    \ 'property': '',
    \ 'unit': 'unit',
    \ 'value': 'val',
    \ 'enum': '',
    \ 'keyword': 'keyword',
    \ 'snippet': '',
    \ 'color': 'color',
    \ 'file': '',
    \ 'reference': 'ref',
    \ 'folder': '',
    \ 'enum member': '',
    \ 'constant': '',
    \ 'struct': '',
    \ 'event': 'event',
    \ 'operator': '',
    \ 'type_parameter': 'type param',
    \ '<default>': 'v'
    \ }

    " let g:ale_linters = {
    "     \ 'bash': ['bash-language-server', 'start'],
    "     \ 'c': ['ccls', '--log-file=/tmp/cc.log'],
    "     \ 'cpp': ['ccls', '--log-file=/tmp/cc.log'],
    "     \ 'go': ['gopls'],
    "     \ 'ruby': ['~/.rbenv/shims/solargraph', 'stdio'],
    "     \ 'rust': ['~/.cargo/bin/rustup', 'run', 'stable', 'rls'],
    "     \ 'vim': ['vim-language-server', '--stdio'],
    "     \ 'yaml': ['yaml-language-server', '--stdio'],
    "     \}
        " \ 'javascript': ['/usr/local/bin/javascript-typescript-stdio'],
        " \ 'javascript.jsx': ['tcp://127.0.0.1:2089'],


    let g:ale_fixers = {
        \   '*': ['remove_trailing_lines', 'trim_whitespace'],
        \}

    " When to lint
    let g:ale_lint_on_enter = 1
    let g:ale_lint_on_filetype_changed = 1
    let g:ale_lint_on_insert_leave = 0
    let g:ale_lint_on_save = 1
    let g:ale_lint_on_text_changed = 'normal'

    " This setting must be set to `1` before ALE is loaded for this behavior to be
    " enabled.
    let g:ale_completion_enabled = 0
    let g:ale_completion_autoimport = 1

    let g:ale_disable_lsp = 0
    let g:ale_fix_on_save = 1

endfunction
