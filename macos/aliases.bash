# vi: ft=sh sts=2 sw=2 sts=2 et
alias lock='/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend'
alias sniff="sudo ngrep -d 'en1' -t '^(GET|POST) ' 'tcp and port 80'"
pidof () { ps -Acw | egrep -i $@ | awk '{print $1}'; }
cdf() { cd "`osascript -e 'tell app "Finder" to POSIX path of (insertion location as alias)'`"; }
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


