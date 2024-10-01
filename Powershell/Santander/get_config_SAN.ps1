#example call:   .\GetConfigs.ps1 -WebAppsPath '\\vmcddev\c$\PADoc\WebApps' \-ServicePath '\\vmcddev\c$\LPADoc\Services' -ClientPath '\\vmcddev\c$\LPADoc\Client'  \-ResultPath 'C:/Temp/Output'
#this example creates a copy of all *.config and *.json files located in the folder passed in ResultPath. The result path contains 3 subfolder: Services, WebApps and clients. 
# The structure of the subfolders are maintained

param(
	[string]$GlobalWebAppsPath = "E$\LPA\Webapps\", 
	[string]$GlobalServicePath = "E$\LPA\Service\", 
	[string]$GlobalClientPath = "", 
	[string]$GlobalResultPath = "E$\Temp\",
    [string]$Nodes = ('vmngpriiwbd01.ngl.corp','vmngpriiwbd02.ngl.corp','vmngpriimdsd01.ngl.corp', 'vmngpriimdsd02.ngl.corp')
    )
	

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


function CopyNode {
	param (
        [string] $NodeUNC,	
        [string] $WebAppsPath,
		[string] $ServicePath,
        [string] $ClientPath,
        [string] $ResultPath
	)
    $DayofYear = Get-Date -Format "yyyy-MM-dd"
    $ResultPath_DayofYear = $ResultPath+"Backup_Configs_"+$Node +$DayofYear
    CopyFiles -Source \\$NodeUNC\$WebAppsPath -Files '*.json' -Dest "\\$NodeUNC\$ResultPath_DayofYear\WebApps"
    CopyFiles -Source \\$NodeUNC\$WebAppsPath -Files '*.config' -Dest "\\$NodeUNC\$ResultPath_DayofYear\WebApps"
    CopyFiles -Source \\$NodeUNC\$ServicePath -Files '*.json' -Dest "\\$NodeUNC\$ResultPath_DayofYear\Services"
    CopyFiles -Source \\$NodeUNC\$ServicePath -Files '*.config' -Dest "\\$NodeUNC\$ResultPath_DayofYear\Services"
    CopyFiles -Source \\$NodeUNC\$ClientPath -Files '*.json' -Dest "\\$NodeUNC\$ResultPath\Client"
    CopyFiles -Source \\$NodeUNC\$ClientPath -Files '*.config' -Dest "\\$NodeUNC\$ResultPath\Client"
    Compress-Archive -Path \\$NodeUNC\$ResultPath_DayofYear -DestinationPath (\\$NodeUNC\$ResultPath+"backup_configs_SAN_"+$DayofYear.zip)
}
foreach ($Node in $Nodes)
{
    CopyNode -Node $Node -WebAppsPath $GlobalWebAppsPath -ServicePath $GlobalServicePath -ClientPath $GlobalClientPath -ResultPath $GlobalResultPath
    copy-Item -Path (\\$Node\$GlobalResultPath+"backup_configs_SAN_"+$DayofYear.zip) -Destination "."
}
