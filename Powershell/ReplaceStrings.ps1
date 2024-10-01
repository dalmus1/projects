<# 
A PowerShell script to search a string and replace inside all files that acomplish search criteria inside indicated path
.\replace.ps1 "Path_where_to_search" "Search_file_mask" "String_to_search" "Replace_string"
example call: .\replace.ps1 . config https://apitoken.mdgms.com https://testing_chain_replace
NOTE: Be carefull with Espacial chars  (,);\$%|)`<<==\\=! etc... and check after use script
you must skip it using ` character inside the string
..\replace.ps1 . config 9`$t2crQCuIxbs 1234
#>
param(
    [string]$SearchPath = "", 
    [string]$SearchFile = "", 
    [string]$SearchString = "",
    [string]$ReplaceString = "")

$FoundedFiles = Get-ChildItem $SearchPath -Recurse -Include *.$SearchFile
foreach ($file in $FoundedFiles)
{
    (Get-Content $file.PSPath) |
    Foreach-Object { $_ -replace [Regex]::Escape($SearchString), $ReplaceString } |
    Set-Content $file.PSPath
}
#Foreach-Object { $_ -replace [Regex]::Escape($SearchString), $ReplaceString } |
#Foreach-Object { $_ -replace $SearchString, $ReplaceString } |