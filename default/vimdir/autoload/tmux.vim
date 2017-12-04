function! tmux#switch(wincmd, tmuxdir)
  let l:previous_winnr = winnr()
  silent! execute "wincmd " . a:wincmd
  if l:previous_winnr == winnr()
    call system("tmux select-pane -" . a:tmuxdir)
    redraw!
  endif
endfunction

function! tmux#previous()
  let l:nr = winnr()
  if !g:tmux_is_last_pane
    silent! execute 'wincmd p'
  endif
  if g:tmux_is_last_pane || l:nr == winnr()
    silent call system('tmux select-pane -l')
    let g:tmux_is_last_pane = 1
  else
    let g:tmux_is_last_pane = 0
  endif
endfunction
