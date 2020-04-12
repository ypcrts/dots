Set-Alias v vi
Set-Alias vi vim
Set-Alias vim nvim
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
  $env:GIT_SSH_COMMAND="$(command ssh | select-object -ExpandProperty Source -first 1 | convert-path)"
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
