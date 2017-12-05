let s:wincmd_to_tmux = {
      \'h': 'L',
      \'j': 'D',
      \'k': 'U',
      \'l': 'R'
      \}
function! tmux#switch(wincmd)
  let l:previous_winnr = winnr()

  exe "wincmd" a:wincmd

  if empty($TMUX)
    return
  endif

  let l:tmuxdir = s:wincmd_to_tmux[a:wincmd]

  if l:previous_winnr == winnr()
    call system("tmux select-pane -" . l:tmuxdir)
    redraw!
  endif
endfunction

let g:tmux_is_last_pane = 0
augroup TMUX
  au!
  au WinEnter * let g:tmux_is_last_pane = 0
augroup END

function! tmux#previous()
  let l:nr = winnr()
  let l:not_tmux = empty($TMUX)

  if l:not_tmux || !g:tmux_is_last_pane
    silent! execute 'wincmd p'
    if l:not_tmux
      return
    endif
  endif

  if g:tmux_is_last_pane || l:nr == winnr()
    silent call system('tmux select-pane -l')
    let g:tmux_is_last_pane = 1
  " else
    " let g:tmux_is_last_pane = 0
  endif
endfunction
