# vi: ft=sh sts=2 ts=2 sw=2 et

if [[ -f /etc/bashrc ]]; then
. /etc/bashrc
fi

set -o vi

set -o noclobber

if [ "${BASH_VERSINFO}" -ge 4 ]; then
  # shopt -s autocd
  shopt -s checkjobs
  shopt -s dirspell
  shopt -u globstar
fi

shopt -s cdable_vars
shopt -s cdspell

shopt -s nocaseglob
shopt -s extglob
shopt -s dotglob

shopt -s cmdhist            # save multi-line commands in history as single line
shopt -s histappend         # do not overwrite history

shopt -s expand_aliases
shopt -s progcomp

shopt -s gnu_errfmt
shopt -s checkwinsize       # update the value of LINES and COLUMNS after each command if altered

. ~/.config/bash/git.bash
. ~/.config/bash/prompt.bash
