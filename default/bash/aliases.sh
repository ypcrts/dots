# vi: sts=2 ts=2 sw=2 et fdm=marker

#{{{1 history, dirs, vim, ls
alias \
  e='loadenv' \
  h='history' \
  j='jobs -l' \
  p='cd ~/Projects' \
  t='cd ~/Projects/tools' \
  o='exec onemux' \
  tmxlb='tmux loadb -' \
  cdtl='cd "$(git rev-parse --show-toplevel)"' \
  rmi='/bin/rm -i' \
  tree='tree -C' \
  grep='grep --color=auto' \
  dr='docker' \
  drc='docker-compose' \
  npmx='PATH="$(git rev-parse --show-toplevel || echo ".")/node_modules/.bin:$PATH"' \
  yka='export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR}/yubikey-agent/yubikey-agent.sock"' \
  k='keys' \
  rot13='tr a-zA-Z n-za-mN-ZA-M' \
  troll='tr a-zA-Z qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM' \
  llort='tr qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM a-zA-Z' \
  tzu="TZ='utc'" \
  jou='journalctl' \
  sjou='sudo journalctl' \
  uctl='systemctl --user' \
  sctl='sudo systemctl' \
  v='$VISUAL' \
  vi='$VISUAL' \
  vim='$VISUAL' \
  safevi='SAFEVI=1 $VISUAL' \
  svi='SAFEVI=1 $VISUAL' \
  startx='2>&1 >~/.local/startx.log startx' \
  makepackagegreatagain='python3 setup.py sdist bdist_wheel && twine upload dist/*' \
  ypcrtsgitconfig='cat ~/.config/git/ypcrts.gitconfig >> .git/config'

if ls --group-directories-first 2>/dev/null >&2; then
  alias ls='ls --color=auto -hF --group-directories-first'
else
  alias ls='ls -hF'
fi


#{{{1 Language and LC
lca_derive () {
  case "$1" in
    c|C)         echo 'C'           ;;
    cu|cutf|utf) echo 'C.UTF-8'     ;;
    en|us|e)     echo 'en_US.UTF-8' ;;
    gb|uk)       echo 'en_GB.UTF-8' ;;
    fr)          echo 'fr_FR.UTF-8' ;;
    de)          echo 'de_DE.UTF-8' ;;
    es)          echo 'es_ES.UTF-8' ;;
    pt)          echo 'pt_BR.UTF-8' ;;
    ru)          echo 'ru_RU.UTF-8' ;;
    he)          echo 'he_IL.UTF-8' ;;
    ar)          echo 'ar_LB.UTF-8' ;;
    *)           echo 'help'        ;;
  esac
}
lca () {
  local name="$(lca_derive "$1")"
  case "$l"  in
    help|-h|--help)
      >&2 echo -e "USAGE:\tlca (c|us|gb|fr|de|ru|es|pt|ar)\n" \
        "\tI select UTF-8 LCs except with 'c'.\n" \
        '\tSee also `type lang`'
      ;;
    *) export LC_ALL="$name"
  esac
}
lang () {
  local name="$(lca_derive "$1")"
  case "$l"  in
    help|-h|--help)
      >&2 echo -e "USAGE:\tlang (c|us|gb|fr|de|ru|es|pt|ar)\n" \
        "\tI select UTF-8 LANGs and LCs except with 'c'.\n" \
        '\tSee also `type lca`'
      ;;
    *) export LC_ALL="$name" LANG="$name"
  esac
}

#{{{1 ssh-agent
checkagent () {
  local QUIET=''
  [[ "$1" = "-q" ]] && QUIET=1

  if [[ -z "$SSH_AUTH_SOCK" ]]; then
    return 6
  fi

  # note: `-q` option missing from older ssh-add
  ssh-add -l >/dev/null 2>&1

  case $? in
    0)
      [[ -z "$QUIET" ]] && echo "Current agent is alive and keyed"
      return 0
      ;;
    1)
      [[ -z "$QUIET" ]] && echo "Current agent is alive and empty"
      return 1
      ;;
    2|*)
      return 2
      ;;
  esac
}
reagent () {
  local QUIET=''
  [[ "$1" = "-q" ]] && QUIET=1

  local agents="$(find /tmp -type s -path '/tmp/ssh-*/agent.*' 2>/dev/null)"
  if [[ -z "$agents" ]]; then
    [ -z "$QUIET" ] && echo "No agents found"
    return 172
  fi
  for agent in $agents; do
    export SSH_AUTH_SOCK="$agent"

    if ssh-add -l >/dev/null 2>&1; then
      # note: `-q` option missing from older ssh-add
      [ -z "$QUIET" ] && echo "Found keyed agent: $agent"
      ssh-add -l
      return 0
    fi
    printf "."
  done

  [ -z "$QUIET" ] && echo "No agents are keyed"
  return 4
}
newagent() {
  echo "Starting new ssh-agent and loading into shell"
  eval `ssh-agent -s -t 15m`
}
keys() {
  checkagent
  case $? in
    0)
      return 0
      ;;
    1)
      ssh-add
      ;;
    2)
      reagent
      ;;
  esac
}


#{{{1 screen, tmux, ssh, mosh
sshsc  () { ssh "$@" -t -- 'screen -d -RR';                          }
sshux  () { ssh "$@" -t -- 'tmux a -d || tmux';                      }

ssho   () { ssh -t "$@" -- 'exec ~/bin/onemux';                      }
mosho  () { TARGET="$1";shift;mosh "$@" -- "$TARGET" '~/bin/onemux'; }


cleanout() {
  # credit: originally inspired by Nate in like 2015? github.com/icco
  # TODO: make separate util
  # XXX: five years later this is still using GNU find and on bsd/traditional
  #  find it freaks me out - dear future self, pls fix // 20201104T1349Z
  op="find . -type f -regextype posix-extended -regex '((.*\.(pyc|class|pyo|bak|tmp|toc|aux|log|cp|fn|tp|vr|pg|ky))|(.*\~))'"
  if [ $# -eq 1  ]; then
    case "$1" in
      -f)
        if has parallel; then
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
  local venv_name=''
  case "$1" in
    r*|reset)
      has nvm        && nvm unload
      has deactivate && deactivate
      ;;
    p*|py)
      if (($# >= 2)); then
        case "$2" in
          .|-l|--local)
            >&2 echo '[loadenv] local python virtualenv'
            SOURCE_TRY ./bin/activate
            return $?
            ;;
          *)
            venv_name="$2"
            ;;
        esac
      fi
      if ! has mkvirtualenv || ! has workon; then
        echo -n "Loading virtualenvwrapper... "
        if SOURCE_FIRST \
          /usr/share/virtualenvwrapper/virtualenvwrapper.sh \
          /usr/bin/virtualenvwrapper.sh \
          /usr/local/bin/virtualenvwrapper.sh \
          ~/.local/bin/virtualenvwrapper.sh; then
          echo "OK"
        else
          echo "failed!"
          return 1
        fi
      fi
      if [[ -n "$venv_name" ]]; then
        workon "$venv_name" >/dev/null 2>&1 || mkvirtualenv "$venv_name"
      fi
      ;;
    n*|nvm|npm|node)
      nvm current >/dev/null 2>&1 || \
        SOURCE_FIRST \
          "$HOME/.nvm/nvm.sh" \
          "$HOME/.config/nvm/nvm.sh" \
          '/usr/local/opt/nvm/nvm.sh'
        (( $# <= 1 )) && return
        case "$2" in
          u*|use)
            nvm use
            ;;
          *)
            nvm "$@"
            ;;
        esac
      ;;
    rb|rbenv|ruby)
      if has rbenv; then
        eval "$(rbenv init -)"
      fi
      ;;
    rvm)
      SOURCE_TRY "$HOME/.rvm/scripts/rvm"
      ;;
    rubygems|gems)
      #http://guides.rubygems.org/faqs/#user-install
      if has ruby && has gem; then
        ADJUNCT_PATH "$(ruby -rubygems -e 'puts Gem.user_dir')/bin" false
      fi
      ;;
    *)
      echo "loadenv [py|rbenv|rvm|nvm|gems]"
      return 1
      ;;
  esac
}
checkenv () {
  local opt_delete=0
  (( $# > 0 )) && case $1 in
    -h|--help)
      >&2 printf '%s\n\n\t%s\n' \
        'checkenv: inspect virtualenv and pipenv environment vars' \
        '`checkenv -d`  deletes all found vars'
      return 0
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
    for line in SHLVL $(env | grep -iE '^pip|^virtual_env'); do
      echo "$line"
    done
  fi
}
checkpath () {
    IFS=':'
    for var in $PATH; do
      echo -e "\t$var"
    done
    IFS=' '
}
badssl () {
    set -x
    export OPENSSL_CONF="$HOME/.config/badssl.cnf";
    set +x
}
badssloff () {
    set -x
    unset OPENSSL_CONF
    set +x
}
