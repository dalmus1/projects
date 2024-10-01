#CONFIG HANGFIRE TO FALSE
Write-Host "Start Script"
C:\windows\system32\inetsrv\appcmd.exe stop APPPOOL /apppool.name:"SAN_Hangfire_https"
C:\windows\system32\inetsrv\AppCmd.exe set app /app.name:"Default Web Site HTTPS"/Hangfire /physicalPath:"E:\LPA\Webapps\"
C:\windows\system32\inetsrv\appcmd.exe stop APPPOOL /apppool.name:"SAN_Hangfire_https"
Write-Host "Browse to http://[NombreHost]/Hangfire/hangfire]"
Pause

#ROLLBACK CONFIG TO ORIGINAL
C:\windows\system32\inetsrv\appcmd.exe stop APPPOOL /apppool.name:"SAN_Hangfire_https"
C:\windows\system32\inetsrv\AppCmd.exe set app /app.name:"Default Web Site HTTPS"/Hangfire /physicalPath:"E:\LPA\Webapps\Hangfire"
C:\windows\system32\inetsrv\appcmd.exe stop APPPOOL /apppool.name:"SAN_Hangfire_https"
Write-Host "Browse to http://[NombreHost]/Hangfire/hangfire"
Pause
Write-Host "End Script"
