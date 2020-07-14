# vi: ft=sh sts=2 ts=2 sw=2
# set -uo pipefail
bash_prompt_setup () {
  # local K='\033[0;30m' # black
  # local R='\033[0;31m' # red
  # local G='\033[0;32m' # green
  # local Y='\033[0;33m' # yellow
  # local B="\033[0;34m" # blue
  # local M='\033[0;35m' # magenta
  # local C='\033[0;36m' # cyan
  # local W='\033[0;37m' # white
  # local RST='\033[0m' # Text reset


  local FARBE BEGRENZER=''

  if ((EUID == 0)); then
    BEGRENZER="//"
    FARBE=31
  else
    FARBE="$(__INTFARBE__ "$EUID")"
    if [[ "x$SSH_TTY" != 'x' ]]; then
      BEGRENZER='▞'
    fi
  fi

  local F="\[\e[0;${FARBE}m\]"
  local R='\[\e[0m\]'
  local BOLD='\[\033[1m\]'

  local HOST_FARBE="$(__STRFARBE__ "$HOSTNAME")"

  if [[ -z "$SAFE_PROMPT" && -z "$TMUX" ]]; then
    local NUTZER_TEIL="${F}\\u\[\e[0;${HOST_FARBE}m\]@\\H${R} ${BEGRENZER} "
  else
    local NUTZER_TEIL=''
  fi

  # PS0 doesn't want to be in the prompt [ ] brackets
  PS0='\033[0m'
  PS1="\n${NUTZER_TEIL}\[\033[\${RET_FARBE}m\]\\w${R} \$(___VIRTUALENV_PROMPT__ 2>/dev/null)\[\033[0;34m\]\$(__git_ps1 \"(%s)\" 2>/dev/null)${R}\n\[\033[\${RET_FARBE}m\]\\$ ${R}${BOLD}"
  PS2="${F}\ "
  PS4="${F}• "
}
__STRFARBE__ ()  {
# param $1 str to hash
  (($# != 1)) && return 1
  local HEXY='1'
  for humbug in md5sum md5 "openssl dgst -md5"; do
    # `openssl dgst` may have prefix like `(stdin)= abec112098`
    if command -V $humbug >/dev/null 2>&1; then
      HEXY="$(echo -n "$1" | "$humbug" | sed 's:^.*\([0-9a-f]\{32\}\).*$:\1:' | tr '[:lower:]' '[:upper:]')"
      break
    fi
  done
  if command -V bc >/dev/null 2>&1; then
    echo "ibase=16;((${HEXY}+2)%5)+20" | bc
  else
    python -uEc "print('{:d}'.format(int('${HEXY}',16)%0x6+0x20))"
  fi
}
__INTFARBE__ ()  {
  (($# != 1)) && return 1
  if command -V bc >/dev/null 2>&1; then
    echo "ibase=10;((${1}+1)%5)+32" | bc
  else
    python -uEc "print('{}'.format(${1}%0x5+0x20))"
  fi
}

bash_prompt_setup
unset bash_prompt_setup __STRFARBE__ __INTFARBE__

___VIRTUALENV_PROMPT__ () {
  [ -n "$RUHE" ] && return 0
  if [ -n "$VIRTUAL_ENV" ]; then
    echo -en "\033[0;32m${VIRTUAL_ENV##*/}\033[0m "
  fi
  if [ -n "$NVM_BIN" ]; then
    echo -en "\033[0;35mn`nvm current | sed 's/v\(.\).*/\1/' 2>/dev/null`\033[0m "
  fi
  # TODO: Add rubygems (g), rvm (r)
}

___EXITSTAT () {
  local RET=$?
  if ((RET)); then
    RET_FARBE='0;31'
    printf "\n\033[1;31m(%s)\033[0m " "$RET"
  else
    RET_FARBE='0'
  fi

}
PROMPT_COMMAND='___EXITSTAT'
