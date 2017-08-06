" Remove trailing spaces from lines
" http://vim.wikia.com/wiki/Remove_unwanted_spaces
function! DeleteTrailingSpaces()
  :let _s=@/
  :%s/\s\+$//e
  :let @/=_s
  :nohl
endfunction
