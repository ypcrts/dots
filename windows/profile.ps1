Set-Alias v vi
Set-Alias vi vim
Set-Alias vim nvim
Function edit-powershell-profile {
  vim $profile
}
Set-PSReadlineOption -EditMode vi
