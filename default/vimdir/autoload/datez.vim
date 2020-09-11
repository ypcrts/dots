function! s:Strip(val)
    return substitute(a:val, '[\r\n]*$', '', '')
endfunction

if exists("*strftime")
    function! datez#Local()
        return strftime("%d.%m.%Y")
    endfunction

    function! datez#LocalTime()
        return strftime("%Y.%m.%d %H:%M")
    endfunction
else
    function! datez#Local()
        echoerr "datez#Local() missing stftime, not impl"
    endfunction

    function! datez#LocalTime()
        echoerr "datez#LocalTime() missing stftime, not impl"
    endfunction

endif

if has('win_32')
    function! datez#Universal()
        echoerr "datez#Universal() not impl on win32: try datez#Local()"
    endfunction
    function! datez#UniversalTime()
        echoerr "datez#UniversalTime() not impl on win32: try datez#Local()"
    endfunction
else
    " Returns UTC date
    function! datez#Universal()
        echom "UTC date"
        return s:Strip(system('date -u \+\%Y\%m\%d'))
    endfunction

    " Returns UTC datetime
    function! datez#UniversalTime()
        echom "UTC datetime"
        return s:Strip(system('date -u \+\%Y\%m\%dT\%H\%MZ'))
    endfunction
endif
