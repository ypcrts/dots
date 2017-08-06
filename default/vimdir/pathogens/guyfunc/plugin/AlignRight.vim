" https://github.com/godlygeek/vim-files/blob/master/.vimrc#L442

" Right align the portion of the current line to the right of the cursor.
" If an optional argument is given, it is used as the width to align to,
" otherwise textwidth is used if set, otherwise 80 is used.
function! AlignRight(...)
  if getline('.') =~ '^\s*$'
    call setline('.', '')
  else
    let line = Retab(getline('.'))

    let prefix = matchstr(line, '.*\%' . virtcol('.') . 'v')
    let suffix = matchstr(line, '\%' . virtcol('.') . 'v.*')

    let prefix = substitute(prefix, '\s*$', '', '')
    let suffix = substitute(suffix, '^\s*', '', '')

    let len = len(substitute(prefix, '.', 'x', 'g'))
    let len += len(substitute(suffix, '.', 'x', 'g'))

    let width = (a:0 == 1 ? a:1 : (&tw <= 0 ? 80 : &tw))

    let spaces = width - len

    call setline('.', prefix . repeat(' ', spaces) . suffix)
  endif
endfunction
com! -nargs=? AlignRight :call AlignRight(<f-args>)
