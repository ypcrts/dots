Set-Alias vi vim
Function edit-powershell-profile {
  vim $profile
}
Set-PSReadlineOption -EditMode vi
