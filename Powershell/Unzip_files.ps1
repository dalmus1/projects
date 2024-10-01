# This is an script to unzip various files finded in one directory
param(
[string]$Pathwithzips = ".",
[String]$Destinationfolder = "unziped"
)
$Foundedzips = Get-ChildItem $Pathwithzips -Filter *.zip 
#Ensure destination foler exists if not exists create it
If(!(test-path -PathType container $Destinationfolder))
{
      New-Item -ItemType Directory -Path $Destinationfolder
}

foreach ($file in $Foundedzips)
{
    Expand-Archive -LiteralPath $Pathwithzips$file -DestinationPath $Destinationfolder -Force
}