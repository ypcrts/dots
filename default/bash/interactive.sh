#
# Assumptions: Bash-compatible interactive shell.
# Ergo: Bashisms are authorized.
# https://wiki.bash-hackers.org/scripting/bashchanges
#

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
# source this or error verbosel
. ~/.config/bash/aliases.sh

# os-aliases.bash might not exist
SOURCE_TRY ~/.config/bash/os-aliases.bash

#{{{1 hostwise includes
#-------------------------------------------------------------------------------
SOURCE_TRY ~/.config/bash/hosts/local.private.sh
hostwise_includes () {
  local fqhost domain hostident
  fqhost="$(uname -n)"

  # TODO: impl domain, fqdn label pop til 2 labels, maybe
  # TODO: STOP OVERENGINEERING EVERYTHING
  # domain="${fqhost#*.}"
  # [ -z "$domain" ] && domain="$(echo -n "$fqhost" | sed 's/^[^.]*[.]//')"
  # SOURCE_TRY ~/.config/bash/domains/"${domain}.sh"

  # XXX: tech debt - use full hostname||gtfo
  hostident="${fqhost%%.*}"
  [ -z "$hostident" ] && hostident="$(echo -n "$fqhost" | sed 's/^[.].*//')"
  SOURCE_TRY ~/.config/bash/hosts/"${hostident}.sh"
  SOURCE_TRY ~/.config/bash/hosts/"${hostident}.private.sh"

  # The order matters. Let this be last.
  SOURCE_TRY ~/.config/bash/domains/"${fqhost}.sh"
}
hostwise_includes
unset -f hostwise_includes
