#{{{1 functions
#-------------------------------------------------------------------------------
SOURCE_TRY () { [[ -f "$1" ]] && . "$1"; }

SOURCE_FIRST () {
  while (( $# > 0 )); do
    SOURCE_TRY "$1" && return 0
    shift
  done
  return 1
}

#{{{1 source base
#-------------------------------------------------------------------------------
. ~/.config/bash/aliases.sh
# XXX: TODO: change os-aliases to posix sh
SOURCE_TRY ~/.config/bash/os-aliases.bash

#{{{1 includes hostwise
#-------------------------------------------------------------------------------
[[ -z "$HOSTNAME" ]] && HOSTNAME="$(hostname)"
HOSTIDENT="$(echo -n "$HOSTNAME" | sed 's/\..*//')"
SOURCE_TRY ~/.config/bash/hosts/"${HOSTIDENT}.sh"
SOURCE_TRY ~/.config/bash/hosts/"${HOSTIDENT}.private.sh"
SOURCE_TRY ~/.config/bash/hosts/local.private.sh
unset HOSTIDENT
