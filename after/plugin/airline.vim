" File: airline.vim
" Maintainer: Emmanuel Roux <>
" Created: Jeu 25 nov 22:04:17 2021
" License:
" Copyright (c) Emmanuel Roux.  Distributed under the same terms as Vim itself.
" See :help license
"
" Description:
" Desc

" let g:airline_experimental = 1      " Enable vim9 script implementation
let g:airline_right_sep=''
let g:airline_right_alt_sep = ''
let g:airline_left_sep=''
let g:airline_left_alt_sep = '|'

" Diplay only encoding if not 'utf-8[unix]'
let g:airline#parts#ffenc#skip_expected_string='utf-8[unix]'

let g:airline_powerline_fonts = 1
"
" tabline activated
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'

" Unicode emoij
" http://unicode.org/emoji/charts/full-emoji-list.html
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

let g:airline_symbols = {
      \ 'space': ' ',
      \ 'paste': 'PASTE',
      \ 'spell': 'SPELL',
      \ 'notexists': '⚠',
      \ 'maxlinenr': '',
      \ 'colnr': '  ',
      \ 'linenr': ' ☰ ',
      \ 'readonly': '🔒',
      \ 'dirty': ' 🄳 ',
      \ 'modified': '✏ ',
      \ 'crypt': '🔑',
      \ 'keymap': 'Keymap:',
      \ 'ellipsis': '...',
      \ 'branch': '⎇',
      \ 'whitespace': '☲',
      \ }
