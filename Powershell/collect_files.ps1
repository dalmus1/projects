<#  NAME: collect_files.ps1
    AUTHOR: manuel.monge@l-p-a.com
    DESCRIPTION: Collect a concrete files (only the newest) from a path and prepare a script to copy
                 to a concrete destination,

    STEPS:
    ------
    1. Obtain a list with content of a concrete PATH file with directory contensts
    2. Take the list of items to be collect and create output folder to put files
    3. Search inside the file obtained in point 1 and generate a file with copy files

    VARIABLES:
    ----------
    SEARCH_PATH=""      - Path where search items to be
    SEARCH_PATH_BASE="" - Path with the same path minus string with wildcards
    FILTER_FILES= ""    -  A mask to filter files
    INVENTORY_FILE=""   -  Name of inventory file generated with contents of search path
    ------
    DIRECTORY_WITH_COLLECTED="" Directory where files will be obtained
    ITEMS_TO_COLLECT="" File with items to be collected
    COPY_SCRIPT_GENERATED="" generated scritp with copy commands
#>

# VARIABLES TO OBTAIN LIST OF FILES
$SEARCH_PATH="\\prod.l-p-a.com\dfs\Customers\LPADoc\BayLB\2022\03"
$SEARCH_PATH_BASE="\\prod.l-p-a.com\dfs\Customers\LPADoc\BayLB\2022\03\"
$FILTER_FILES= "*XMLFile*.xml"
$INVENTORY_FILE=".\inventory_march.txt"

# VARIABLES TO COLLECT ITEMS
$DIRECTORY_WITH_COLLECTED="D:\IS\Kunden\BayernLB\collect_files"
$ITEMS_TO_COLLECT="items_to_be_collect.txt"
$COPY_SCRIPT_GENERATED="copy_files2.ps1"

# STEP 1
#Get-Childitem -Path $SEARCH_PATH  -Name -Include $FILTER_FILES -Recurse  -ErrorAction SilentlyContinue | Out-File -FilePath $INVENTORY_FILE
#Get-Childitem -Path .  -Name -Include "*XMLFile*.xml" -Recurse  -ErrorAction SilentlyContinue | Out-File -FilePath inventory_march.txt
# STEP 2

#New-Item $DIRECTORY_WITH_COLLECTED -itemType Directory -Force
$patterns_file = Get-Content $ITEMS_TO_COLLECT
Set-Content $COPY_SCRIPT_GENERATED ""
#STEP 3 and 4
foreach ($pattern in $patterns_file)
{
   $filetocopy = Get-Content -path $INVENTORY_FILE |Select-String -pattern $pattern| select-object -First 1
   #$relative_path = "\" + ($filetocopy -split '_',5)[0]
#   echo $filetocopy
#   echo $relative_path
#   $command = "copy " + $SEARCH_PATH_BASE + $relative_path + $filetocopy + " " + $DIRECTORY_WITH_COLLECTED
   $command = "copy " + $SEARCH_PATH_BASE + $filetocopy + " " + $DIRECTORY_WITH_COLLECTED
   Add-Content $COPY_SCRIPT_GENERATED $command
}

