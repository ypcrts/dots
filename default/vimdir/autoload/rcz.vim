function! rcz#VimFilesDir()
    let l:dir = fnamemodify($MYVIMRC, ":h")
    return l:dir
endfunction

function! rcz#DotfilesVimDir()
    let l:dir = fnamemodify(resolve($MYVIMRC), ":h")
    return l:dir
endfunction

function! rcz#PlugVimDir()
  return rcz#VimFilesDir() . '/plugged'
endfunction

function! rcz#VimFileRealpath(filename)
  let l:dir = rcz#DotfilesVimDir()
  let l:path = l:dir  . "/" . a:filename
  if filereadable(l:path)
    return l:path
  endif
  echoerr a:filename . ' not found in ' . l:dir
  return ''
endfunction

function! rcz#Todo()
  let entries = []
  let args = '-e TODO -e FIXME -e XXX -e BUG -e ERROR -e BLACKMAGIC'
  for cmd in ['git grep -niI ' . args . ' 2> /dev/null',
            \ 'grep -rniI ' . args . ' * 2> /dev/null']
    let lines = split(system(cmd), '\n')
    if v:shell_error != 0 | continue | endif
    for line in lines
      let [fname, lno, text] = matchlist(line, '^\([^:]*\):\([^:]*\):\(.*\)')[1:3]
      call add(entries, { 'filename': fname, 'lnum': lno, 'text': text })
    endfor
    break
  endfor

  if !empty(entries)
    call setqflist(entries)
    copen
  endif
endfunction

 
function! rcz#PlugPathFirstOf(...)
  let l:ret = 0
  for p in a:000
    let l:ret = rcz#PlugPathIfExists(p)
    if l:ret
      return l:ret
    endif
  endfor
endfunction

function! rcz#PlugPathIfExists(path)
  let fullpath = expand(a:path)
  if isdirectory(fullpath)
    " return plug#load(fullpath)
    return plug#(a:path)
  endif
  return 0
endfunction
