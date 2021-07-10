function! s:Strip(val)
    return substitute(a:val, '[\r\n]*$', '', '')
endfunction

function! datez#LightVi()
    if !empty($LIGHTVI)
      if $LIGHTVI == '1'
        echomsg '[LIGHTVI] enabled'
        return 1
      endif
      echomsg '[LIGHTVI] disabled'
      return 0
    endif
    if ! exists("*strftime")
        return 0
    endif
    let s:local_hour = strftime("%k")
    if 6 < s:local_hour ||  s:local_hour > 10
        return 0
    endif
    return 1
endfunction

if exists("*strftime")
    function! datez#Local()
        return strftime("%d.%m.%Y")
    endfunction

    function! datez#LocalTime()
        return strftime("%d.%m.%Y %H:%M %z")
    endfunction

    function! datez#LocalTimeNato()
        return strftime("%d.%m.%Y %H:%M") . s:TimeZoneToCode()
    endfunction

    function! s:TimeZoneToCode()
        let l:zone = strftime("%z")
        let l:timezone_codes = {
                    \ '+0000': 'Z',
                    \ '-0000': 'Z',
                    \ '+0100': 'A',
                    \ '+0200': 'B',
                    \ '+0300': 'C',
                    \ '+0400': 'D',
                    \ '+0500': 'E',
                    \ '+0600': 'F',
                    \ '+0700': 'G',
                    \ '+0800': 'H',
                    \ '+0900': 'I',
                    \ '+1000': 'K',
                    \ '+1100': 'L',
                    \ '+1200': 'M',
                    \ '+1300': 'N',
                    \ '-0100': 'N',
                    \ '-0200': 'O',
                    \ '-0300': 'P',
                    \ '-0400': 'Q',
                    \ '-0500': 'R',
                    \ '-0600': 'S',
                    \ '-0700': 'T',
                    \ '-0800': 'U',
                    \ '-0900': 'V',
                    \ '-1000': 'W',
                    \ '-1100': 'X',
                    \ '-1200': 'Y',
                    \ }
        return get(l:timezone_codes, l:zone, 'undefined time zone')
    endfunction

else
    function! datez#Local()
        echoerr "datez#Local() missing stftime, not impl"
    endfunction

    function! datez#LocalTime()
        echoerr "datez#LocalTime() missing stftime, not impl"
    endfunction

endif

if has('win32')
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

    " Returns UTC datetime with separators
    function! datez#UniversalTime8601()
        echom "UTC datetime"
        return s:Strip(system('date -u \+\%Y-\%m-\%dT\%H:\%MZ'))
    endfunction
endif
