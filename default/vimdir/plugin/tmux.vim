  let g:tmux_is_last_pane = 1
  augroup TMUX
    au WinEnter * let g:tmux_is_last_pane = 0
  augroup END
