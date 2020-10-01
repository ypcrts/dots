function! daclipz#ToggleClipboardUnnamedPlus()
  let &cb = (&cb == 'unnamedplus' ?  '' : 'unnamedplus')
  echo "cb := " . ( &cb == 'unnamedplus' ? &cb : '[empty]' )
endfunction
