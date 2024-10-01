param(
	[string]$file = "",
	[Int]$number_in_batch=10)

[boolean]$first= $true
[int]$NumWorkflow=0;
if ($file)
{
	$outputifle=".\wfmigrator_with_w.log" 
	Start-Transcript $outputifle
	Write-Host "MIG21 - WF - workflow migrator using -w option is being executed"  -NoNewline;date -format "yy-MM-dd hh:mm:ss"
	$command = ".\WorkflowMigrator.exe -p=8 -w ["
	$fichero= Get-Content $file
	$longFichero = Get-Content $file| Measure-Object -Line | %{$_.Lines} 
	$Counter=0

	ForEach ($line in $fichero)
		{
			$counter=$counter+1	
			if (!($first)) {
				$command = $command+","+$line 
			}
			else
			{
				$command = $command+$line
				$first = $false
			}
			$NumWorkflow = $NumWorkflow +1
			if ($NumWorkflow -eq $number_in_batch)
			{
				$NumWorkflow=0;
				$first = $true
				$command = $command+"]"
				$ProgressShow =	($counter / $longFichero).tostring("P")
				$Progress =(($counter / $longFichero)*100)
				$Progresspercent=[Math]::Round($Progress, 0)
				Write-Progress -Activity " Migrationg workflows..." -Status "$ProgressShow% Complete:" -PercentComplete $Progresspercent 
				Invoke-Expression $command
				$command = ".\WorkflowMigrator.exe -p=8 -w ["
			}
		}
	#Execute last commands created
	$command = $command+"]"
	Invoke-Expression $command
	Write-Host "MIG21 - WF - workflow migrator using -w option terminated" -NoNewline;date -format "yy-MM-dd hh:mm:ss"
	Stop-Transcript    
}
else
{
	Write-Host "USAGE: wfmigrator_with_w.ps1 <file whit list of workflows, one by line> [Number of workflows per line (Default:10)]"
}
