#example call:   .\compare_configs.ps1 -WebAppsPath '\\vmcddev\c$\inetpub\data\LPADoc\WebApps' -ServicePath '\\vmcddev\c$\Program Files\LPA\LPADoc\Services' -ResultPath 'C:/Temp/Output'
# this example compare two folders with diferen configurations to find diferrences in every file

param(
	[string]$ReferencePath = "C:\Users\MongeM\Work\Santander_Work\V20Config\Webapps", 
	[string]$DifferentPath = "C:\Users\MongeM\Work\Santander_Work\V20Config\Webapps_SAN",
	[string]$TypeFiles = "web.config")

function CompareFiles {
	param (
		[string] $Source,
		[string] $Destiny,
		[string] $Files,
		[string] $OutFile = "Outfile_Diferences_$TypeFiles.txt"
	)
	echo "" > $OutFile
	Get-ChildItem $Source -Filter $Files -Recurse | ForEach{
		$DestinyFile = ($_.FullName) -Replace [Regex]::Escape($Source), $Destiny
		echo "-------------------------------------------------------------" >> $OutFile
		echo "- COMPARING ($_.FullName) with $DestinyFile" >> $OutFile
		echo "-------------------------------------------------------------" >> $OutFile
		Compare-Object -ReferenceObject (Get-Content -Path ($_.FullName)|where {$_ -ne ""}) -DifferenceObject (Get-Content -Path $DestinyFile|where {$_ -ne ""}) -CaseSensitive >> $OutFile
	}
	echo "Result in .\$Outfile"
}

CompareFiles -Source $ReferencePath -Destiny $DifferentPath -Files $TypeFiles 

