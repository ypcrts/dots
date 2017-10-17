# vi: ft=sh sts=2 ts=2 sw=2
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

  # param $1 str to hash
  __STRFARBE__ ()  {
    (($# < 1)) && return 1
    local HASH="$(echo \"$1\" | md5sum | sed -r 's/^([0-9a-f]*).*$/\U\1/')"
		if command -V bc >/dev/null 2>&1; then
			echo "ibase=16;(${HASH}%5)+20" | bc
		else
			python -c "import os;os.write(1,'{:d}'.format(int('${HASH}',16)%0x5+0x20))"
		fi
  }

  local VIRTUALENV_TEIL=''
  local NUTZER_TEIL=''
  local FARBE=37
  local HOST_FARBE=37
  local BEGRENZER='✱'
  local NUTZERZEIGEN=0

  if [[ "$SSH_TTY" ]]; then
    BEGRENZER='▞'
    NUTZERZEIGEN=1
  fi

  if ! ((__ZUHAUSE_PROMPT)); then
    if ((EUID == 0)); then
      FARBE=31
      NUTZERZEIGEN=1
    else
      local NUTZER="$(id -un)"
      case "$NUTZER" in
        ypcrts)
          ;;
        *)
          NUTZERZEIGEN=1
          FARBE="$(__STRFARBE__ $NUTZER)"
          ;;
      esac
    fi
  fi

  local F="\[\e[0;${FARBE}m\]"
  local R='\[\e[0m\]'

  if ((NUTZERZEIGEN)); then
    HOST_FARBE="$(__STRFARBE__ `hostname`)"
    NUTZER_TEIL="${F}\\u@\[\033[0;${HOST_FARBE}m\]\\H ${R}\[\033[0;\${RET_FARBE}m\]${BEGRENZER} "
  fi

  PS1="\n${NUTZER_TEIL}${F}\\w \$(___VIRTUALENV_PROMPT__ 2>/dev/null)\[\033[0;34m\]\$(__git_ps1 \"(%s)\" 2>/dev/null)${R}\n\[\033[\${RET_FARBE}m\]\\$ ${R}"
  PS2="${F}\ "
  PS4="${F}• "
}

bash_prompt_setup
unset bash_prompt_setup

___VIRTUALENV_PROMPT__ () {
  [ -n "$RUHE" ] && return 0
  if [ -n "$VIRTUAL_ENV" ]; then
    printf "\033[0;32m${VIRTUAL_ENV##*/}\033[0m "
  fi
  if [ -n "$NVM_BIN" ]; then
    printf "\033[0;35mn`nvm current | sed 's/v\(.\).*/\1/' 2>/dev/null`\033[0m "
  fi
  # TODO: Add rubygems (g), rvm (r)
}

function ___EXITSTAT () {
  local RET=$?
  if ((RET)); then
    RET_FARBE='0;31'
    printf '\n\033[1;31m(%d)\033[0m ' "$RET"
  else
    RET_FARBE='0'
  fi

}
PROMPT_COMMAND='___EXITSTAT'
