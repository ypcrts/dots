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

  local F begrenzer=' ' benutzer='' promptchar='$'
  local H="\[\e[0;$(__strfarbe__ "$HOSTNAME")m\]"
  if ((EUID == 0)); then
    begrenzer='//'
    promptchar='#'
    farbeint=31
  else
    farbeint="$(__intfarbe__ "$EUID")"
  fi
  F="\[\e[0;${farbeint}m\]"

  if [[ "x$SSH_TTY" != 'x' ]]; then
    begrenzer='▞'
  elif [[ -f /.dockerenv ]] || grep -Eq '(docker|lxc)/' /proc/1/cgroup 2>/dev/null; then
    begrenzer='¢'
  fi

  if [[ "x$begrenzer" != 'x '  ]] || [[ -n "$SAFE_PROMPT" ]]; then
    printf "fu"
    benutzer="${F}\\u${H}@\\h${R}${begrenzer}"
  fi

  local R='\[\e[0m\]'
  local BOLD='\[\033[1m\]'
  local S='\[${statusfarbecode}\]'

  # PS0 doesn't want to be in the prompt [ ] brackets
  PS0='\033[0m'
  PS1="${R}${benutzer}${S}\\w${R}${begrenzer}\$(__git_ps1 \"%s\" 2>/dev/null)${R} \$(___VIRTUALENV_PROMPT__ )${R}\n${S}${promptchar}${R}${BOLD} "
  PS2="${F}\ "
  PS4="${F}• "
}
__strfarbe__ ()  {
# param $1 str to hash
  (($# != 1)) && return 1

  # default colour
  local hexdigest='1' pybin checksumprog

  for checksumprog in md5sum md5 "openssl dgst -md5"; do
    if command -V $checksumprog >/dev/null 2>&1; then
      break
    fi
  done
  # do not quote checksumprog to allow word splitting
  # `openssl dgst` may have prefix like `(stdin)= abec112098`
  hexdigest="$(echo -n "$1" | $checksumprog | sed 's:^.*\([0-9a-f]\{32\}\).*$:\1:' | tr '[:lower:]' '[:upper:]')"

  # 
  if command -V bc >/dev/null 2>&1; then
    echo "ibase=16;((${hexdigest}+2)%5)+20" | bc
  else
    for pybin in python3 python; do
      if command -V $pybin >/dev/null 2>&1; then
        "$pybin" -uEc "print('{:d}'.format(int('${hexdigest}',16)%0x6+0x20))"
        break
      fi
    done
  fi
}
__intfarbe__ ()  {
  # Converts integer to one of four ANSI colour codes
  (($# != 1)) && return 1
  local pybin

  if command -V bc >/dev/null 2>&1; then
    echo "ibase=10;((${1}+1)%5)+32" | bc
  else
    for pybin in python3 python; do
      if command -V $pybin >/dev/null 2>&1; then
        $pybin -uEc "print('{}'.format(${1}%0x5+0x20))"
        break
      fi
    done
  fi
}

bash_prompt_setup
unset bash_prompt_setup __strfarbe__ __intfarbe__

___VIRTUALENV_PROMPT__ () {
  {
    [ -n "$RUHE" ] && return 0
    if [ -n "$VIRTUAL_ENV" ]; then
      echo -en "\033[0;32m${VIRTUAL_ENV##*/}\033[0m"
    fi
    if [ -n "$NVM_BIN" ]; then
      echo -en "\033[0;35m`nvm current | sed -n -e 's/v\([0-9]*\).*/\1/p' 2>/dev/null `\033[0m"
    fi
    # TODO: Add rubygems (g), rvm (r)
  } 2>/dev/null
}

___EXITSTAT () {
  local RET=$?
  if ((RET)); then
    statusfarbecode=$'\e[1;31m'
    printf "\n${statusfarbecode}¿%s?\033[0m " "$RET"
  else
    statusfarbecode=''
  fi
}
PROMPT_COMMAND='___EXITSTAT'
