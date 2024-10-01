param(
	[string]$Part = "")

$outputifle=".\Workflows_parte_$part.log" 
$file=".\Workflows_parte_$part.txt"
$fichero= Get-Content $file
$longFichero = Get-Content $file| Measure-Object -Line | %{$_.Lines} 
$Counter=0
Write-Host "workflow migrator for parte $part is being executed"
echo "workflow migrator for parte $part is being executed" > $outputifle
date  >> $outputifle

	(Get-Content $file) |
    ForEach-Object {
    .\WorkflowMigrator.exe -w $_ 
	$counter=$counter+1	
	Write-Host "Parte $part workflow migrated="$_
	echo "workflow migrated=$_"  >> $outputifle
	$ProgressShow =	($counter / $longFichero).tostring("P")
	$Progress =(($counter / $longFichero)*100)
	$Progresspercent=[Math]::Round($Progress, 0)
	Write-Progress -Activity " Migrationg workflows..." -Status "$ProgressShow% Complete:" -PercentComplete $Progresspercent 
    }
Write-Host "workflow migrator for part $part terminated"
echo "workflow migrator for part $part terminated" >> $outputifle
date >> $outputifle
    

