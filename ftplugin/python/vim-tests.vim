" File: vim-tests.vim
" Maintainer: Emmanuel Roux <>
" Created: Mar 15 fév 07:36:58 2022
" License:
" Copyright (c) Emmanuel Roux.  Distributed under the same terms as Vim itself.
" See :help license
"
" Description:

let test#python#runner = 'pytest'
let test#filename_modifier = ':p'  " generate filename absolute paths
