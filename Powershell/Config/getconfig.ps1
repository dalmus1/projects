#example call:   .\GetConfigs.ps1 -WebAppsPath '\\vmcddev\c$\PADoc\WebApps' \-ServicePath '\\vmcddev\c$\LPADoc\Services' -ClientPath '\\vmcddev\c$\LPADoc\Client'  \-ResultPath 'C:/Temp/Output'
#this example creates a copy of all *.config and *.json files located in the folder passed in ResultPath. The result path contains 3 subfolder: Services, WebApps and clients. 
# The structure of the subfolders are maintained

param(
	[string]$WebAppsPath = "", 
	[string]$ServicePath = "", 
	[string]$ClientPath = "", 
	[string]$ResultPath = ".")
	


function CopyFiles {
	param (
		[string] $Source,
		[string] $Files,
		[string] $Dest
	)
	Get-ChildItem $Source -Filter $Files -Recurse | ForEach{
		$Path = ($_.DirectoryName + "\") -Replace [Regex]::Escape($Source), $Dest
		If(!(Test-Path $Path)){
			New-Item -ItemType Directory -Path $Path -Force | Out-Null
		}
		Copy-Item $_.FullName -Destination $Path -Force
	}
}

CopyFiles -Source $WebAppsPath -Files '*.json' -Dest "$ResultPath\WebApps"
CopyFiles -Source $WebAppsPath -Files '*.config' -Dest "$ResultPath\WebApps"
CopyFiles -Source $ServicePath -Files '*.json' -Dest "$ResultPath\Services"
CopyFiles -Source $ServicePath -Files '*.config' -Dest "$ResultPath\Services"
# Comment these two lines to skip client servers
CopyFiles -Source $ClientPath -Files '*.json' -Dest "$ResultPath\Client"
CopyFiles -Source $ClientPath -Files '*.config' -Dest "$ResultPath\Client"