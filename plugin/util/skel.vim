" File: snippet_helpers.vim
" Maintainer: Gavin Jaeger-Freeborn <gavinfreeborn@gmail.com>
" Created: Mon 02 Dec 2019 10:10:49 PM MST
" License:
" Copyright (c) Gavin Jaeger-Freeborn.  Distributed under the same terms as Vim itself.
" See :help license
"
" Description:
" Simple Template functionality using read and a file
"
" Links:
" - https://shapeshed.com/vim-templates

let s:templates_search_dir = trim(get(g:, 'templates_search_dir', 'extra/templates'), '/', 2)

function! s:load_skeleton(type, name)
	" do nothing if no filetype
	if empty(a:type)
		return
	elseif a:name =~ "[0-9].sh"
		"prevent errors with dirvish
		return
	endif

	if !(line('$') == 1 && getline('$') == '') || filereadable(expand('%:p'))
		return
	endif
	" glob every directory of rtp to search for skeleton/filetype
	let skeletons = globpath(&rtp, s:templates_search_dir . '/' . a:name , 0, 1)

	if empty(skeletons)
		let skeletons = globpath(&rtp, s:templates_search_dir . '/' . a:type , 0, 1)
		if empty(skeletons)
			return
		endif
	endif
	" read last skeleton into 1st line.
	exe 'silent! 0read ' . skeletons[-1]
	call feedkeys("i\<Plug>(miniSnip)", "x")
endfunction

if has("autocmd")
  augroup aug_skeleton
	autocmd!
	autocmd BufNewFile * call s:load_skeleton(&filetype, expand('%'))
  augroup end
endif
