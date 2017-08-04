#!/bin/bash
needle_in_haystack () {
  2>/dev/null echo "$2" | >/dev/null 2>/dev/null fgrep -c "$1"
  return
}
goto_fail () {
  local INTERFACES="$(ifconfig -a | /usr/bin/awk '/^[^[:space:]]/ {print $1}' | sed -e 's/://g')"
  local TARGET=""
  local SCRAM="$(openssl rand -hex 6 | sed 's%\(..\)%\1:%g; s%.$%%')"

  if [ $# -ge 1 ]; then
    TARGET="$1"
  else
    echo "Consider specifiying the interface name as argv[1]"
    if needle_in_haystack "wlan0" "$INTERFACES"; then
      TARGET="wlan0"
    elif needle_in_haystack "en0" "$INTERFACES"; then
      TARGET="en0"
    else
      printf "fatal:\t$0 no target interface identified, specify manually\n"
      exit 1
    fi
  fi

  sudo ifconfig "$TARGET" ether "$SCRAM"
}

goto_fail "$@"
