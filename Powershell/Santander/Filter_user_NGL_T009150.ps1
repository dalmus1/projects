$Dia= Read-Host -Prompt "Nombre fecha del log en formato AAMMDD (p.e 221228)"
[string]$Buscarlog= "u_ex$Dia.log"
write-host $Buscarlog
.\Filter_IISlogs_mdsp01.ps1 1000 $Buscarlog|Out-Null
.\Filter_IISlogs_mdsp02.ps1 1000 $Buscarlog|Out-Null
.\Filter_IISlogs_wbp02.ps1 1000 $Buscarlog|Out-Null
.\Filter_IISlogs_wbp01.ps1 1000 $Buscarlog|Out-Null
$nombre_fichero = $Dia + "-Santander_logs.zip"

zip $nombre_fichero *.log