function! s:GoToBuffer(direction)
  let l:bufferNr = len(getbufinfo({'buflisted':1}))
  if &buftype != 'nofile' && l:bufferNr > 1
    exec(a:direction)
    if &buftype == 'terminal'
      exec(a:direction)
    endif
  endif
endfunction

function! s:BufferPrev() 
  call s:GoToBuffer('bprev')
endfunction

function! s:BufferNext()
  call s:GoToBuffer('bnext')
endfunction

function! s:BufferDelete()
  if &filetype == "help" || &filetype == "nerdtree"
    exec('bd')
  else
    " https://stackoverflow.com/questions/4465095
    let l:bufferNr = len(getbufinfo({'buflisted':1}))
    if l:bufferNr > 1
      exec('bprev|bd #')
    else
      exe('bd|Startify|NERDTree')
    endif
  endif
endfunction

nnoremap <C-h> :call <SID>BufferPrev()<CR>
nnoremap <C-l> :call <SID>BufferNext()<CR>
nnoremap <leader>d :call <SID>BufferDelete()<CR>
