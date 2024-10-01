<#
A PowerShell script to filter ISSlog create an output file called "filter_for_mail.log"
.\Filter_IISlogs.ps1 "Minimun value of Milisecond to be filtered"
example call: .\Filter_IISlogs.ps1 25000
#>

param(

    [Int64]$Miliseconds = "10",
    [string]$StringDay = "")

Write-Host "Buscando log $StringDay en VMNGPRIIMDSP02.ngl.corp"

$FoundedFiles = Get-ChildItem C:\inetpub\logs\LogFiles\W3SVC1 -Recurse -Include $StringDay
$outputifle = "filter_for_mail_wbp01.log"
Set-Content $outputifle ""

foreach ($file in $FoundedFiles)
{
    (Get-Content $file.PSPath)|
    ForEach-Object {
        ([int64]$timetaken = ($_ -split '\s+',25)[[convert]::ToInt64(14)])
        ($status = ($_ -split '\s+',25)[[convert]::ToInt64(11)])
        ($program = ($_ -split '\s+',25)[4])
        if (($timetaken -gt [convert]::ToInt64($Miliseconds)) -and ($status -ieq 200))   {
            if (($program -clike "*lpadocservice*") -or ($program -clike "*adapterservice*") -or ($program -clike "*AdapterService*")) {
                Add-Content $outputifle $_
            }
        }
    }
}