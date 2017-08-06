" http://github.com/godlygeek/vim-files/blob/master/.vimrc#L483

function! StripHtml(first, last)
  sil! exe a:first . ',' . a:last . '!links2 -dump file:///dev/stdin'
  sil! '[,']s/\(^ \|\s*$\)//g
endfunction

command -range=% StripHtml call StripHtml(<line1>, <line2>)
