" DieYouTrolls.vim
" https://github.com/ypcrts/dots
" whet? read http://vim.wikia/wiki/File_format
function! formatz#DieYouTrolls()
  " Todo add checking if not saved or not a file (i.e. directory)
  :w
  " Read file as DOS so any ending with CLF or LF is EOL
  :e ++ff=dos
  " Force all as DOS
  :w!
  " Switch to Unix (LF)
  :set ff=unix
  :w!
endfunction

func! formatz#FormatJSON(first, last)
  sil! exe a:first . ',' . a:last . '!python -m json.tool'
endfunction

function! formatz#StripHtml(first, last)
  sil! exe a:first . ',' . a:last . '!links2 -dump file:///dev/stdin'
  sil! '[,']s/\(^ \|\s*$\)//g
endfunction

" Remove trailing spaces from lines
" http://vim.wikia.com/wiki/Remove_unwanted_spaces
function! formatz#DeleteTrailingSpaces()
  :let _s=@/
  :%s/\s\+$//e
  :let @/=_s
  :nohl
endfunction
