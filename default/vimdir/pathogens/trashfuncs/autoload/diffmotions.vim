" DiffMotions.vim
" Originally part of unimpaired.vim by Tim Pope
" https://github.com/tpope/vim-unimpaired
"

nnoremap <silent> <Plug>diffmotionsContextPrevious :call <SID>Context(1)<CR>
nnoremap <silent> <Plug>diffmotionsContextNext     :call <SID>Context(0)<CR>
onoremap <silent> <Plug>diffmotionsContextPrevious :call <SID>ContextMotion(1)<CR>
onoremap <silent> <Plug>diffmotionsContextNext     :call <SID>ContextMotion(0)<CR>


function! diffmotions#Context(reverse)
  call search('^\(@@ .* @@\|[<=>|]\{7}[<=>|]\@!\)', a:reverse ? 'bW' : 'W')
endfunction

function! diffmotions#ContextMotion(reverse)
  if a:reverse
    -
  endif
  call search('^@@ .* @@\|^diff \|^[<=>|]\{7}[<=>|]\@!', 'bWc')
  if getline('.') =~# '^diff '
    let end = search('^diff ', 'Wn') - 1
    if end < 0
      let end = line('$')
    endif
  elseif getline('.') =~# '^@@ '
    let end = search('^@@ .* @@\|^diff ', 'Wn') - 1
    if end < 0
      let end = line('$')
    endif
  elseif getline('.') =~# '^=\{7\}'
    +
    let end = search('^>\{7}>\@!', 'Wnc')
  elseif getline('.') =~# '^[<=>|]\{7\}'
    let end = search('^[<=>|]\{7}[<=>|]\@!', 'Wn') - 1
  else
    return
  endif
  if end > line('.')
    execute 'normal! V'.(end - line('.')).'j'
  elseif end == line('.')
    normal! V
  endif
endfunction
