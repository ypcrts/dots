function! tmuxbuf#MakeTmuxGreatAgain(first, last)
  let l:file="/tmp/".$USER.".tmuxbuf"
  sil! exe a:first . ',' . a:last . 'w! ' . l:file
  sil! exe '!tmux load-buffer ' . l:file . '; rm -f ' . l:file
endfunction
