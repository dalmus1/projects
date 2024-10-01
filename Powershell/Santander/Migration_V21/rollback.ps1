<#  NAME: rollback.ps1
    AUTHOR: manuel.monge@l-p-a.com
    DESCRIPTION: Perform a Roolback of services
    STATE: Incomplete
    
#>

param(
[string]$Reverse = "no"
)

#$webapp = ('AdapterService','AdapterServiceHttp','APIService','CapmatixAPI','Certificates','DebugDocGenerator','DebugDocWorkflowService','DebugDownloadDocumentService','DebugHangfire',
#'DebugLPADocService','DocDesignerNotificationService','DocDesignerWebApi','DocDesignerWebDAVServer','DocGenerator','DocGenExcelAddInService','DocumentGenerationService','DocumentService','DocWorkflowService',
#'DownloadDocumentService','Hangfire','IDServer','LPADocService','LPADocServiceHttp','MarketDataServer','ProdDesigner','ReportService','TermsheetsAdapterService','WebDocDesigner','WopiHost','WorkflowService')

$webapp = ('AdapterServicehttp','LPADocHttp')
$webapphttps = ('AdapterService','APIService','LPADocService')
$Site_http = "Default Web Site"
$Site_https = "Default Web Site Https"
$Folder = "C:\LPA\Webapps\"
$Suffix ="_SAN"


function Manage-Pools ([string]$action, [string]$Filter)
{
    
    #Obtain apppols
    $FILE=".\result.txt";
    C:\windows\system32\inetsrv\appcmd.exe list APPPOOL > $FILE
    $FoundedPools = Get-content $FILE
    Remove-Item $FILE
    Write-Host $action"ing App Pools......."
    foreach ($line in $FoundedPools)
    {
        $Filtrado= ($line.Split("")[1])
        C:\windows\system32\inetsrv\appcmd.exe $action APPPOOL $filtrado;
        write-host "App Pool" $Filtrado $action"ed"
    }
    Write-Host "App Pools"$action"ed."
 }

Function ChangePath-Apps($Site,  $group, $App_Folder, $App_Suffix)
{
    Write-Host "Changing" $Site_http "Apps target folder to" $App_Folder "with Suffix" $App_Suffix
     foreach ($App in $group)
     {
        $item="""IIS:\Sites\$site\$App"""
        write-host "Item" $item
        $path="""$App_Folder$App$App_Suffix"""
        write-host "PATH" $path
        Import-Module WebAdministration -Global
        Set-ItemProperty -LiteralPath $item -name physicalPath -value $path
       } 
    Write-Host "Apps in" $Site_http "Changed"
}

Manage-Pools -action "stop" 
Stop-IISSite $Site_http -Confirm
Stop-IISSite $Site_https -Confirm
#ChangePath-Apps -Site $Site_http -group $webapp -App_Folder $Folder -App_Suffix $Suffix
#ChangePath-Apps -Site $Site_https -group $webapphttps -App_Folder $Folder -App_Suffix $Suffix
Start-IISSite $Site_http
Start-IISSite $Site_https
Manage-Pools -action "start" 




