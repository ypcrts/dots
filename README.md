# dots

## What on earth is this mess?

### Goals 
This repo attempts to achieve a few goals. 
- useable across Windows and Linux systems, with macOS as a second-class citizen
- installation using syslinks with using a home-rolled management script which reads a home-rolled manifest file format
- the management script runs on python 2.7 or 3.4-3.8 and has a lot of assertions; requires admin on Windows.
- bash is the shell. zsh is 2-3 orders of magnitude slower, and scripting language is not bash-compatible.
- tmux config everywhere: versions 1.7 and all work roughly the same, using a single config file (black magic!)
  This is a big deal, because the tmux developer is a fan of breaking changes in config files. 
- vim and neovim: share a single set of configuration files.  When you run as
  root, no plugins are loaded. You can also force this by setting the `SAFEVI`
  environment variable.
- vi mode in bash is key to life and turned on:  `set -o vi` is my favourite thing to type in a reverse shell.

### Why did you home-roll a manifest file format?

I've been attacked out of the blue in job interviews for doing this, and it was
suggested that I preemptively defend myself so here it goes. Originally
I wanted to use JSON, but it does not have references. Then I thought I'd use
YAML to take advantage of references, but the I realized that YAML references
didn't support the functionality that I was looking for. I wanted to be able to
delete some files, link files, link files in a directory to target location,
include other sections. I didn't want this done in code. I wanted a file format
that only contained primitives, so that way I could look at an untrusted
manifest file and see what it does.

So I decided to write my own file spec that looks like a Makefile, sort of. 

### Why did you home-roll a management script?

I had used [vcsh](https://github.com/RichiH/vcsh) for a long time after trying
other things, but I didn't like having to carry around functionally-divided
repos, and I found it clunky switching between many repos. I also wanted native
Windows support. I wanted many deployable pieces in one `dots` repo and then to
choose what to pollute the system with. To complicate it further, I wanted to
be able to use the management script with other repos too and with other
destinations.

The result is I have been using this management script on all three major
desktop OSes since 2017 and it makes me happy.. I've been able to take it with
me to friends' servers to deploy little pieces of this repo as needed. The
script even has the capability to `purge` so it can clean up after you've done
what you needed.


### Abandoned Features
This repo used to also provide an up-to-date configuration for bspwm and sxkhd
that I loved dearly. This text blob is in loving memory of the days where
I felt that keeping up to date with the bspwm developer's breaking changes was
worth my time. It's not anymore. I'd rather use Microsoft Windows to host my
terminal emulators (<s>Windows Terminal is pretty good</s> Alacritty is cute)
so I can do things in docker and over ssh.  RIP bspwm & the Linux desktop.

## Management Script: `manifest.py`
```
usage: manifest.py [-h] [-n] [-m MANIFEST] [-f] [-v]
                   [{install,purge,inspect}] [section [section ...]]

creates symlinks described by a manifest

positional arguments:
  {install,purge,inspect}
  section               manifest target

optional arguments:
  -h, --help            show this help message and exit
  -n, --dry-run         nop out all syscalls, verbose
  -m MANIFEST, --manifest MANIFEST
                        path to custom manifest file
  -f, --force           allow clobbering files in target paths
  -v, --verbose
```

## `MANIFEST` file syntax

- `~/bin/destination_link: ./section/source_file`
  - destination-to-source mapping, with the two arguments delimited by a colon

- `$ bin`
  - defines the `bin` section

- `/bin/sh: @delete`
  deletes /bin/sh

- `@include: bin default`
   - includes `bin` and `default`
   - in each run of `manifest.py` includes are resolved recursively so that they are only processed once
