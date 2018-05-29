! vim:fenc=utf-8:nu:ai:si:et:ts=4:sw=4:ft=xdefaults:

#include "common.h"
#include "color_w0ng.h"

! {{{1 Xautolock
Xautolock.corners:     -+++
Xautolock.cornerdelay: 600
Xautolock.time:        5
Xautolock.notify:      15

! {{{1 SSH askpass
! https://wiki.archlinux.org/index.php/SSH_Keys#Calling_x11-ssh-askpass_with_ssh-add
*askpass*background:                 #000000

! {{{1 Rofi
rofi.color-enabled:   true
!                     bg,        fg,        bgalt,     hlbg,      hlfg
rofi.color-normal:    #00000000, #FFffffff, #00000000, #CC000000, #FFffffff
rofi.color-urgent:    #000000,   #ffffff,   #000000,   #333333,   #ffffff
rofi.color-active:    #000000,   #ffffff,   #000000,   #333333,   #ffffff
rofi.color-window:    #aa000000, #aa222222
rofi.terminal:        urxvt
rofi.location:        0
rofi.padding:         30
rofi.separator-style: solid
rofi.threads:         0
rofi.lines:           10
rofi.fixed-num-lines: true
rofi.eh:              2
rofi.bw:              0
rofi.hide-scrollbar:  true
rofi.font:            Iosevka Term 10
rofi.fullscreen:      false



! {{{1 Urxvt
#define PURPLE_CURSOR #5E468C
URxvt.cursorColor:    PURPLE_CURSOR
! {{{2 composite
! not supported in X11 passthrough
URxvt*depth:               32
URxvt*background:          [90]#000000
