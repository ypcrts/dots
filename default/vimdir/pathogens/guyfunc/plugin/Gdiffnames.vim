func! Gdiffnames(...)
  let a:branch = get(a:, 1, 'HEAD')
  set efm=%f
  silent exec ':!git diff --name-only ' . a:branch . ' > /tmp/.codereviewdiff.tmp'
  normal :cgetfile /tmp/.codereviewdiff.tmp
  silent !rm -f /tmp/.codereviewdiff.tmp
endfunc

com! -nargs=? Gdiffnames :call Gdiffnames(<args>)
