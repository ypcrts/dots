# vi: ft=sh sts=2 sw=2 sts=2 et
alias firefoxp='/Applications/Firefox.app/Contents/MacOS/firefox  --no-remote -P'
alias lock='/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend'
alias pbcopy='/usr/local/bin/reattach-to-user-namespace pbcopy'
alias pbpaste='/usr/local/bin/reattach-to-user-namespace pbpaste'
alias pbp='pbpaste'
alias pbc='pbcopy'
pidof () { ps -Acw | grep -iE $@ | awk '{print $1}'; } # this is kind of trash
cdf() { cd "$(osascript -e 'tell app "Finder" to POSIX path of (insertion location as alias)')"; }
finder () {
  osascript 2>/dev/null <<EOL
  tell application "Finder"
    return POSIX path of (target of window 1 as alias)
  end tell
EOL
}

camerausedby() {
  echo "Checking to see who is using the iSight camera… 📷"
  usedby=$(lsof | grep -w "AppleCamera\|USBVDC\|iSight" | awk '{printf $2"\n"}' | xargs ps)
  echo -e "Recent camera uses:\n$usedby"
}

# my eyes just rolled back into my head, rip
export BASH_SILENCE_DEPRECATION_WARNING=1
