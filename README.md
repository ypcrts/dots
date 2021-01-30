# dots

Here be dragons. These are my dots.

These dots are deployed with [symfest](https://github.com/ypcrts/symfest), my bespoke
symlink manager that uses a bespoke file spec. Yes, I rolled my own.

## Design Choices
Multi-platform support for POSIX-compliant systems, Debian GNU/Linux, Windows,
macOS and BSDs in that order of priority.


`bash` is the interactive shell, targeting v4, with support for v5. Support for the slower
  `zsh` is 2-3 orders of magnitude slower, and scripting language is not
  bash-compatible.

Shell scripts target `/bin/sh` assuming it implements POSIX.1-2017 Shell
    Command Language, and the five additional features specified under [Debian
    Policy](https://www.debian.org/doc/debian-policy/ch-files.html#s-scripts).

tmux config everywhere: versions 1.7 and all work roughly the same, using
  a single config file (black magic!) This is a big deal, because the tmux
  developer is a fan of breaking changes in config files.

vim and neovim: share a single set of configuration files.  When you run as
  root, no plugins are loaded. You can also force this by setting the `SAFEVI`
  environment variable.

vi-keys in bash and powershell is key to my happiness.  `set -o vi` is my favourite
    thing to type in a reverse shell, even before `python -c 'import
    pty;pty.spawn("/bin/bash")'`.

### ~Abandoned~ Features
<s>This repo used to also provide an up-to-date configuration for bspwm and sxkhd
that I loved dearly. This text blob is in loving memory of the days where
I felt that keeping up to date with the bspwm developer's breaking changes was
worth my time. It's not anymore. I'd rather use Microsoft Windows to host my
terminal emulators (<s>Windows Terminal is pretty good</s> Alacritty is cute)
so I can do things in docker and over ssh.  RIP bspwm & the Linux desktop.<s>

The above text blob is a reminder of the time I quit bspwm for a year.

This text blob commemorates the time that I killed moving my config from bspwm
0.9.2 to 0.9.9.

This text blob is a reminder to never give up on your favourite window manager.
Even if the X11 threat model is unconscionable in 2021, bspwm is worth it.
