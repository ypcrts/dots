" DieYouTrolls.vim
" https://github.com/ypcrts/dots

" whet? read http://vim.wikia/wiki/File_format

function! DieYouTrolls()
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
command DieYouTrolls call DieYouTrolls()
