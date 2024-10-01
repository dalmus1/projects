
<# 
A PowerShell script to search a string and inside all files that acomplish search criteria inside indicated path
.\replace.ps1 "Path_where_to_search" "Search_file_mask" "String_to_search" "Replace_string"
example call: .\search.ps1 . config localhost
#>
param(
    [string]$SearchPath = "", 
    [string]$SearchFile = "", 
    [string]$SearchString = ""
    )
$FoundedFiles = Get-ChildItem $SearchPath -Recurse -Include *.$SearchFile
foreach ($file in $FoundedFiles)
{
    (Select-String -Path $file.PSPath -Pattern $SearchString)
}


