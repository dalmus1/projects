# Parameters
$connectionString = "Data Source=sengpriips2.ngl.corp\SEPRIIPS;initial catalog=DocGeneratorV21;integrated security=True"
$file=".\listado_workflows_PRO.txt"
$pieces=48 #Number pieces file will be split
# Get the list of workflow Ids
$sqlText = "SELECT [WfBasedataId] FROM [dg].[WfInformationMaxStepView] where workflowcategorycaption in ('ES_3rdPartyKIDs','ES_Campaign','ES_Campaign_Monitored','ES_eDeriv','ES_eDerivatives','ES_eDerivativesTermination','ES_IRContract','ES_OTC_TRADE','ES_PeriodicAssessmentReport','ES_PersonalizedProduct','ES_ProposalAdvice','ES_ProposalAdvicePortal','ES_SimplifiedKIDs_Workflow','ES_Warrants','PL_KIDs_Automatic','PL_KIDs_Manual','ReportService') and statetype not like 'completed' order by isdebugmode asc, stepversion desc, statetimestamp desc"
$connection = new-object System.Data.SqlClient.SQLConnection($connectionString);
$cmd = new-object System.Data.SqlClient.SqlCommand($sqlText, $connection);
$connection.Open();
$reader = $cmd.ExecuteReader()
$workflowsToMigrate = @()

write-host "Start  obtain list of workflows " -NoNewline;date -format "yy-MM-dd hh:mm:ss"
while ($reader.Read())
{
    $row = @{}
    for ($i = 0; $i -lt $reader.FieldCount; $i++)
    {
        $row[$reader.GetName($i)] = $reader.GetValue($i)
    }
    $workflowsToMigrate += (new-object psobject -property $row).WfBasedataId
}
$connection.Close();
write-host "finish obtain list of workflows: " -NoNewline;date -format "yy-MM-dd hh:mm:ss"
#Write-Host $workflowsToMigrate

echo $workflowsToMigrate >> $file

$outputifle="Workflows_part_" 
$counter=0
write-host "Start split file in $pieces pieces: " -NoNewline;date -format "yy-MM-dd hh:mm:ss"
	(Get-Content $file) |
    ForEach-Object {
        $counter=$counter + 1
        if ($counter -eq ($pieces+1)) {
        $counter=1
                }
		Add-Content $outputifle$counter.txt $_ 
    }
write-host "Finish split file in $pieces pieces: " -NoNewline;date -format "yy-MM-dd hh:mm:ss"