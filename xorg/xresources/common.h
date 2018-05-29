! vim:fenc=utf-8:nu:ai:si:et:ts=4:sw=4:ft=xdefaults:
! {{{1 Font settings
Xft.autohint:                        0
Xft.lcdfilter:                       lcddefault
Xft.hintstyle:                       hintslight
Xft.hinting:                         1
Xft.antialias:                       1
Xft.rgba:                            rgb
Xft.dpi:                             92

! {{{1 Urxvt
URxvt.cursorBlink:         false
URxvt.geometry:            80x22
URxvt.borderLess:          false
URxvt*urgentOnBell:        true
URxvt.internalBorder:      1
URxvt.scrollBar_right:     false
URxvt.scrollBar:           false
! {{{2 Annoying insert mode
URxvt.iso14755:            true
URxvt.iso14755_52:         false
!URxvt.altSendsEscape:     true ! this is evil!
URxvt.transparent:         false
URxvt.insecure: false
! {{{2 Scrollback
URxvt*scrollTtyKeypress:   false
! URxvt*scrollTtyKeypress: true
URxvt*saveLines:           2048
URxvt*skipBuiltinGlyphs:   true

! {{{2 Extensions
URxvt.perl-ext-common:   default,matcher,font-size
URxvt.url-launcher:      firefox
URxvt.matcher.pattern.1: \\bwww\\.[\\w-]\\.[\\w./?&@#-]*[\\w/-]
URxvt.keysym.M-S-Insert: perl:matcher:last
URxvt.keysym.M-Insert:   perl:matcher:list
URxvt.keysym.C-M-Up:     perl:font-size:increase
URxvt.keysym.C-M-Down:   perl:font-size:decrease
URxvt.keysym.C-M-S-Up:   perl:font-size:incglobal
URxvt.keysym.C-M-S-Down: perl:font-size:decglobal
! /*}}}*/
