! vim:fenc=utf-8:nu:ai:si:et:ts=4:sw=4:ft=xdefaults:

#define SS_FONT_FAMILY DejaVu Sans
#define FONT_FAMILY    Iosevka Term

#include "common.h"
#include "rofi.h"
#include "color_w0ng.h"

! {{{1 Xautolock
Xautolock.corners:     -+++
Xautolock.cornerdelay: 600
Xautolock.time:        5
Xautolock.notify:      15

! {{{1 SSH askpass
! https://wiki.archlinux.org/index.php/SSH_Keys#Calling_x11-ssh-askpass_with_ssh-add
*askpass*background:                 #000000

! {{{1 Urxvt
#define PURPLE_CURSOR #5E468C
URxvt.cursorColor:    PURPLE_CURSOR
! {{{2 composite
! not supported in X11 passthrough
URxvt*depth:               32
URxvt*background:          [90]#000000
