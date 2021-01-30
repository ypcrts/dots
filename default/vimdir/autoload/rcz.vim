function! rcz#VimrcDir()
  return fnamemodify($MYVIMRC, ":h")
endfunction

let s:vimfilesdir = '~/.vim'
function! rcz#VimfilesDir()
  return   s:vimfilesdir
endfunction

let s:dotfilesvimdir = fnamemodify(resolve($MYVIMRC), ":h")
function! rcz#DotfilesVimDir()
    return s:dotfilesvimdir
endfunction

if has('win32') || has('win64')
  let s:vimfilesdir = '~\vimfiles'
  let s:dotfilesvimdir = s:vimfilesdir
endif

function! rcz#VimFileRealpath(filename)
  return rcz#DotfilesVimDir() . "/" . a:filename
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
    let ret = plug#(a:path)
    if ret
      return 1
    endif
  endif
  return 0
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
