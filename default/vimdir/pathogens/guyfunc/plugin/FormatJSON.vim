func! FormatJSON()
  :%!python -m json.tool
  :set ft=json
endfunction
command FormatJSON call FormatJSON()
