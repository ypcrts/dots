# vi: sts=2 ts=2 sw=2 et fdm=marker

#{{{1 history, dirs, vim, ls
alias \
  e='loadenv' \
  h='history' \
  j='jobs -l' \
  p='cd ~/Projects' \
  cdtl='cd "$(git rev-parse --show-toplevel)"' \
  rmi='/bin/rm -i' \
  ll='ls -lh' \
  l1='ls -1' \
  la='ls -A' \
  lal='ls -lA' \
  lla='lal' \
  tree='tree -C' \
  grep='grep --color=auto' \
  dr='docker' \
  drc='docker-compose' \
  npmx='PATH="$(git rev-parse --show-toplevel || echo ".")/node_modules/.bin:$PATH"' \
  k='keys' \
  rek='rekey' \
  rot13='tr a-zA-Z n-za-mN-ZA-M' \
  troll='tr a-zA-Z qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM' \
  llort='tr qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM a-zA-Z' \
  tzu="TZ='utc'"


if command -V nvim >/dev/null 2>&1; then
  alias \
    nvi='nvim' \
    vim='nvim' \
    vi='nvim'
fi

if ls --group-directories-first 2>/dev/null >&2; then
  alias ls='ls --color=auto -hF --group-directories-first'
else
alias ls='ls -hF'
fi


#{{{1 Language and LC
lca () {
  myusage () {
      printf "USAGE:\tlca (c|us|gb|fr|de)\n\tI select UTF-8 LCs except with 'c'.\n\tUse me with export. My brother is lang."
      return
  }
  if [ $# -ne 1 ]; then
    myusage
    return
  fi
  export LC_ALL
  case "$1" in
    c|C)         LC_ALL='C'           ;;
    cu|cutf|utf) LC_ALL='C.UTF-8'     ;;
    en|us|e)     LC_ALL='en_US.UTF-8' ;;
    gb|uk)       LC_ALL='en_GB.UTF-8' ;;
    fr)          LC_ALL='fr_FR.UTF-8' ;;
    de)          LC_ALL='de_DE.UTF-8' ;;
    *)           myusage              ;;
  esac
  unset -f myusage
}
lang () {
  if [ $# -ne 1 ]; then
    printf "USAGE:\tlang (en|de|fr|*)\n\tI select utf languages only.\n\tUse me with export. My sister is lca."
    return
  fi
  export LANG
  case "$1" in
    de|DE) LANG='de_DE.UTF-8' ;;
    en|EN) LANG='en_GB.UTF-8' ;;
    es|ES) LANG='es_ES.UTF-8' ;;
    fr|FR) LANG='fr_FR.UTF-8' ;;
    *)     LANG="${1}.UTF-8"  ;;
  esac
}

#{{{1 ssh-agent
reagent () {
  local QUIET=''
  [ "$1" = "-q" ] && QUIET=1

  if [ -n "$SSH_AUTH_SOCK" ] && ssh-add -l >/dev/null 2>&1; then
    [ -z "$QUIET" ] && echo "Keyed agent active"
    return 0
  fi
  local agents="$(find /tmp -type s -path '/tmp/ssh-*/agent.*' 2>/dev/null)"
  if [ "$agents" = '' ]; then
    [ -z "$QUIET" ] && echo "No agents found"
    return 1
  fi
  for agent in $agents; do
    export SSH_AUTH_SOCK="$agent"

    if ssh-add -l >/dev/null 2>&1; then
      [ -z "$QUIET" ] && echo "Found keyed agent: $agent"
      ssh-add -l
      return 0
    fi
    printf "."
  done

  [ -z "$QUIET" ] && echo "No agents are keyed"
  return 1
}
rekey () {
  local QUIET=''
  [ "$1" = "-q" ] && QUIET=1

  reagent -q
  echo "Rekeying $agent"
  if ssh-add; then
    return 0
  fi
  return 1
}
newagent() {
  eval `ssh-agent -s -t 15m`
  ssh-add
  ssh-add -l
}
keys() {
  reagent && return 0
  rekey && return 0
  newagent
}


#{{{1 tmux, ssh, mosh
sshux  () { ssh "$@" -t -- 'tmux a -d || tmux';                            }

ssho   () { ssh -t "$@" -- "exec ~/bin/onemux";                            }
mosho  () { TARGET="$1";shift;mosh "$@" -- "$TARGET" "~/bin/onemux"; }

moshoo () { mosh -- "$1" "~/bin/onemux" "$2";                              }
sshoo  () { ssh -t "$1" -- "~/bin/onemux" "$2";                            }


cleanout() {
  # TODO: make separate util
  op="find . -type f -regextype posix-extended -regex '((.*\.(pyc|class|pyo|bak|tmp|toc|aux|log|cp|fn|tp|vr|pg|ky))|(.*\~))'"
  if [ $# -eq 1  ]; then
    case "$1" in
      -f)
        if command -V parallel >/dev/null 2>&1; then
          term="| parallel -L100 -m \"rm -vf {}\""
        else
          term=" -exec rm {} +"
        fi
        eval "$op $term"
        ;;
      -i)
        eval "$op -exec rm -i {} \;"
        ;;
    esac
  else
    eval $op | column | $PAGER
  fi
}
#{{{1 loadenv magic
loadenv () {
  local POSTLOAD=''
  case "$1" in
    r*|reset)
      if command -V nvm >/dev/null 2>&1; then
        nvm unload
      fi
      if command -V deactivate >/dev/null 2>&1; then
        deactivate
      fi
      ;;
    p*|py)
      if (($# >= 2)); then
        case "$2" in
          .|-l|--local)
            source_if_exists "./bin/activate"
            return $?
            ;;
          *)
            POSTLOAD="workon $2 || mkvirtualenv $2"
            ;;
        esac
      fi
      printf "Loading virtualenvwrapper... "
      if source_any \
        /usr/share/virtualenvwrapper/virtualenvwrapper.sh \
        /usr/bin/virtualenvwrapper.sh \
        /usr/local/bin/virtualenvwrapper.sh; then
        printf "OK\n"
        [ -n "$POSTLOAD" ] && eval "$POSTLOAD"
        return 0
      else
        printf "failed!\n"
        return 1
      fi
      ;;
    n*|nvm|npm|node)
      nvm current >/dev/null 2>&1 || \
        source_any \
          "$HOME/.nvm/nvm.sh" \
          "/usr/local/opt/nvm/nvm.sh"
      ;;
    rvm|ruby)
      source_if_exists "$HOME/.rvm/scripts/rvm"
      ;;
    rubygems|gems)
      #http://guides.rubygems.org/faqs/#user-install
      if has ruby && has gem; then
        adjunct_path_with "$(ruby -rubygems -e 'puts Gem.user_dir')/bin" false
      fi
      ;;
    *)
      echo "loadenv [py|rvm|nvm|gems]"
      return 1
      ;;
  esac
}
checkenv () {
  local opt_delete=0
  [[ $# -gt 0 ]] && case $1 in
    -h|--help)
      echo 'checkenv: inspects virtualenv and pipenv environment vars' \
           '-d    deletes all found vars'
      ;;
    -d|-f|--delete)
      opt_delete=1
      ;;
  esac
  if ((opt_delete)); then
    for var in $(env | grep -iE '^pip|^virtual\_env' | sed 's:=.*$::'); do
      unset "$var"
    done
  else
    for var in SHLVL $(env | grep -iE '^pip|^virtual_env'); do
      echo "${var}=${!var}"
    done
  fi
}
checkpath () {
    IFS=':'
    echo "PATH="
    for var in $PATH; do
      echo -e "\t$var"
    done
    IFS=' '
}
