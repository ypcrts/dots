Set-Alias v vi
Set-Alias vi vim
Set-Alias vim nvim

Function mksshconfig {
  & docker run -it -v "~:/root" debian:stable bash /root/Documents/dots/ssh/bin/mksshconfig
}
Function dockerbash {
  & docker run -it -v "~:/root" debian:stable bash
}

#Function edit-powershell-profile {
#  vim $profile
#}
Set-PSReadlineOption -EditMode vi

Function bg() {
  # Cause I keep forgetting this.
  Start-process @args
}
Function firefoxp {
  Start-process firefox -ArgumentList @("-P", "-no-remote")
}
Function k {
  start-service ssh-agent
  ssh-add -l
  if (!$?) {
    ssh-add
    ssh-add -l
  }
  # XXX: this should work, but it doesn't because bugs
  # $env:GIT_SSH_COMMAND=[Management.Automation.WildcardPattern]::Escape("$(command ssh | select-object -ExpandProperty Source -first 1 | convert-path)")
  git config --global core.sshCommand "'C:\Windows\System32\OpenSSH\ssh.exe'"
}
Function p {
  cd $env:USERPROFILE/Documents
}
Function ssho {
  Param(
    [string[]]$Pass
  )
 & ssh -t @Pass -- exec bin/onemux
}
