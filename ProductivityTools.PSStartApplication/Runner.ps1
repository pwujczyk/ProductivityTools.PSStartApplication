clear

cd $PSScriptRoot
Import-Module .\ProductivityTools.PSStartApplication.psm1 -Force
#Import-Module D:\GitHub\PSGet-Configuration\Get-Configuration\Get-Configuration.psm1 -force
#Set-StartApplicationConfigurationPath d:\Trash
Start-Application notepad -Verbose
#Start-Application notepad -kill