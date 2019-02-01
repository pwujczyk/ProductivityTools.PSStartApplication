function GetApplicationName()
{
	return "Start-Application"
}


function GetScriptPath()
{
	$path=$PSScriptRoot
	return $path
}

function GetConfigurationFileName()
{
	return "StartApplication.xml"
}

function CreateFile([string]$configPath)
{
	$configFile='<?xml version="1.0" encoding="utf-8"?>
<Applications>
  <Application>
    <Key>Notepad</Key>
    <Description>Windows Notepad</Description>
    <ProcessName>notepad</ProcessName>
    <ApplicationPath>C:\Windows\System32\notepad.exe</ApplicationPath>
    <AutoStart>0</AutoStart>
  </Application>
</Applications>'
	$configFile |Out-File $configPath
}

function GetConfigurationFile()
{
	$configurationKey=Get-StartApplicationConfigurationKey
	$configFile=Get-MasterConfiguration $configurationKey -Application $(GetApplicationName)
	if ($configFile -eq "" -or $configFile -eq $null)
	{
		$scriptPath=$(GetScriptPath) 
		$configFile=Join-Path $scriptPath $(GetConfigurationFileName)
		Set-StartApplicationConfigurationPath $scriptPath
	}
	
	if ( $(Test-Path $configFile) -eq $false)
	{
		CreateFile $configFile
	}
	
	return $configFile
}

function WriteConfigurationPath()
{
	$configPath=Get-StartApplicationConfigurationPath
	Write-Verbose "Configuration path: [$configPath]"
	Write-Verbose "If you want to change configuration path please setup it using Set-MasterConfiguration -Key '$(Get-StartApplicationConfigurationKey)' -Application '$(GetApplicationName)' -Value value"
}

function WriteApplication($application)
{
	$consoleColor=$HOST.UI.RawUI.ForegroundColor 	
	Write-Host $application.Key -ForegroundColor Red -NoNewline; 
	Write-Host " - " -ForegroundColor White -NoNewline; 
	Write-Host $application.Description -ForegroundColor Green
}

function GetApplicationList()
{
	$file = GetConfigurationFile
	[xml]$ConfigurationFile=[xml](Get-Content $file)
	$applicationList = $ConfigurationFile.Applications.Application
	return $applicationList
}

function DisplayApplicationList()
{
	WriteConfigurationPath
	$applicationList=GetApplicationList
	foreach($application in $applicationList)
	{
		WriteApplication $application
	}
}

function PerformOperation($Key,$action)
{
	$applicationList=GetApplicationList
	foreach($application in $applicationList)
	{
		if ($application.Key -eq $Key)
		{
			$action.Invoke($application)
		}
	}
}

function StartApplication($application)
{
	$path=$application.ApplicationPath
	Write-Host "Running application [$($application.Description)] from location [$($application.ApplicationPath)] "
	[System.Diagnostics.Process]::Start("$path")
}

function RunApplication()
{
	[cmdletbinding()]
	param ([string]$Key)
	[Action[object]]$action = {
							param($application) 
							StartApplication $application
						}
	PerformOperation $Key $action
}

function KillApplication()
{
	[cmdletbinding()]
	param ([string]$Key)
	[Action[object]]$action = {
							param($application) 
							$processName=$application.ProcessName
							Write-Host "Killing application [$($application.Description)] with the process name: [$($processName)] "
							Stop-Process -Name $processName
						}
	PerformOperation $Key $action
}

function RunAutostartApplication()
{
	$applicationList=GetApplicationList
	foreach($application in $applicationList)
	{
		if ($application.AutoStart -eq $true)
		{
			StartApplication $application
		}
	}
}

function Start-Application {
	[cmdletbinding()]
	param ([string]$Key,[switch]$Kill,[switch]$Autostart)

	DisplayApplicationList
	if ($Autostart.IsPresent)
	{
		RunAutostartApplication
	}
	else
	{
		if ($Kill.IsPresent)
		{	
			KillApplication $Key
		}
		else
		{
			RunApplication $Key
		}
	}
}

function Get-StartApplicationConfigurationKey
{
	return "StartAppplicationDirectory"
}


function Set-StartApplicationConfigurationPath
{
	[cmdletbinding()]
	param ([string]$Path)
	
	$configurationKey=Get-StartApplicationConfigurationKey
	$configFile=Join-Path $Path $(GetConfigurationFileName)
	Set-MasterConfiguration -Key $configurationKey -Value $configFile -Application $(GetApplicationName)
}

function Get-StartApplicationConfigurationPath
{
	$configurationKey=Get-StartApplicationConfigurationKey
	$r = MasterConfiguration $configurationKey
	return $r
}

Export-ModuleMember Set-StartApplicationConfigurationPath
Export-ModuleMember Start-Application
Export-ModuleMember Get-StartApplicationConfigurationPath