func! FormatStdJS()
  :%!standard % --format
  :set ft=js
endfunction
command FormatStdJS call FormatStdJS()
command Standard call FormatStdJS()
