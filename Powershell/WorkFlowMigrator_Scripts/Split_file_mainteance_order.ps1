$outputifle="Workflows_parte_" 
$file="C:\Users\MongeM\Work\Santander\WorkFlow Migrator\Migracion V21\listado_workflows_PRO.txt"
$counter=0
$pieces=5 #Number pieces file will be split
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
