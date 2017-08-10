# vi: sts=2 ts=2 sw=2 et fdm=marker

#{{{1 history, dirs, vim, ls
alias h='history'
alias j="jobs -l"
alias p='cd ~/Projects'
alias cdtl='cd "$(git rev-parse --show-toplevel)"'
alias dirs='dirs -v'

if command -V nvim >/dev/null 2>&1; then
  alias nvim="COLORTERM=256 nvim"
  alias nvi='nvim'
  alias vim='nvim'
  alias vi='nvim'
fi

alias tree='tree -C'
alias grep='grep --color=auto'
if ls --group-directories-first 2>/dev/null >&2; then
  alias ls='ls --color=auto -hF --group-directories-first'
else
alias ls='ls -hF'
fi
alias ll='l -lh'
alias l1='l -1'
alias la='l -A'
alias lal='l -lA'
alias lla='lal'

alias rmi='/bin/rm -i'

alias dr='docker'
alias drc='docker-compose'
alias npmx='PATH="$(git rev-parse --show-toplevel || echo ".")/node_modules/.bin:$PATH"'

#{{{1 Language and LC
alias tzu="TZ='utc'"
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
    en|EN) LANG='en_GB.UTF-8' ;;
    de|DE) LANG='de_DE.UTF-8' ;;
    fr|FR) LANG='fr_FR.UTF-8' ;;
    *)     LANG="${1}.UTF-8"  ;;
  esac
}

#{{{1 ssh-agent
reagent () {
  local QUIET=''
  [ "$1" = "-q" ] && QUIET=1

  if [ -n "$SSH_AUTH_SOCK" ] && ssh-add -l >/dev/null 2>&1; then
    [ -z "$QUIET" ] && printf "Keyed agent active\n"
    return 0
  fi
  local agents="$(find /tmp -type s -path '/tmp/ssh-*/agent.*' 2>/dev/null)"
  if [ "$agents" = '' ]; then
    [ -z "$QUIET" ] && printf "No agents found\n"
    return 1
  fi
  for agent in $agents; do
    export SSH_AUTH_SOCK="$agent"

    if ssh-add -l >/dev/null 2>&1; then
      [ -z "$QUIET" ] && printf "Found keyed agent: $agent\n"
      ssh-add -l
      return 0
    fi
    printf "."
  done

  [ -z "$QUIET" ] && printf "No agents are keyed\n"
  return 1
}
rekey () {
  local QUIET=''
  [ "$1" = "-q" ] && QUIET=1

  reagent -q
  printf "Rekeying $agent\n"
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
alias k=keys
alias rek=rekey


#{{{1 TMUX and SSH
tmuxa  () { [ -z "$TMUX" ] && { tmux attach -d || tmux; }                  }
sshux  () { ssh "$@" -t -- 'tmux a -d || tmux';                               }

ssho   () { ssh -t "$@" -- "exec ~/bin/onemux";                            }
mosho  () { local TARGET="$1";shift;mosh "$@" -- "$TARGET" "~/bin/onemux"; }

moshoo () { mosh -- "$1" "~/bin/onemux" "$2";                              }
sshoo  () { ssh -t "$1" -- "~/bin/onemux" "$2";                            }

#{{{1 cypherpunch
alias rot13='tr a-zA-Z n-za-mN-ZA-M <<<'
aes_encypt () {
  openssl enc -aes-256-cbc -e -in $1 -out "$1.aes"
}
aes_decrypt () {
  openssl enc -aes-256-cbc -d -in $1 -out "${1%.*}"
}
diggy () {
	dig +nocmd "$1" any +multiline +noall +answer;
}
#{{{1 cleanout
cleanout() {
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
#{{{1 loadenv


loadenv () {
  local POSTLOAD=''
  case "$1" in
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
      if source_if_exists /usr/share/virtualenvwrapper/virtualenvwrapper.sh || \
        source_if_exists /usr/bin/virtualenvwrapper.sh || \
        source_if_exists /usr/local/bin/virtualenvwrapper.sh; then
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
        source_if_exists "$HOME/.nvm/nvm.sh" || \
        source_if_exists "/usr/local/opt/nvm/nvm.sh"
      ;;
    rvm|ruby)
      source_if_exists "$HOME/.rvm/scripts/rvm"
      ;;
    rubygems|gems)
      #http://guides.rubygems.org/faqs/#user-install
      if command -v ruby 2>&1 >/dev/null && command -v gem 2>&1 >/dev/null; then
        adjunct_path_with "$(ruby -rubygems -e 'puts Gem.user_dir')/bin" false
      fi
      ;;
    *)
      echo "loadenv [py|rvm|nvm|gems]"
      return 1
      ;;
  esac
}
alias e='loadenv'
