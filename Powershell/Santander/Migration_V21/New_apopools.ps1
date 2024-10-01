#POOLS CREATION
C:\windows\system32\inetsrv\appcmd.exe ADD APPPOOL /name:"SAN_AdapterService_http"  
C:\windows\system32\inetsrv\appcmd.exe ADD APPPOOL /name:"SAN_AdapterService_https"  
C:\windows\system32\inetsrv\appcmd.exe ADD APPPOOL /name:"SAN_LPADOCService_https" 
C:\windows\system32\inetsrv\appcmd.exe ADD APPPOOL /name:"SAN_LPADOCService_http"  
               


#CONFIG POOLS
C:\windows\system32\inetsrv\AppCmd.exe set app /app.name:"Default Web Site HTTP"/LPADocService /applicationPool:SAN_LPADOCService_http
C:\windows\system32\inetsrv\AppCmd.exe set app /app.name:"Default Web Site HTTPS"/LPADocService /applicationPool:SAN_LPADOCService_https
C:\windows\system32\inetsrv\AppCmd.exe set app /app.name:"Default Web Site HTTP"/AdapterService /applicationPool:SAN_AdapterService_http
C:\windows\system32\inetsrv\AppCmd.exe set app /app.name:"Default Web Site HTTPS"/AdapterService /applicationPool:SAN_AdapterService_https
C:\windows\system32\inetsrv\AppCmd.exe set apppool /apppool.name:SAN_AdapterService_http /processModel.maxProcesses:2
C:\windows\system32\inetsrv\AppCmd.exe set apppool /apppool.name:SAN_AdapterService_https /processModel.maxProcesses:2
C:\windows\system32\inetsrv\AppCmd.exe set apppool /apppool.name:SAN_LPADOCService_http /processModel.maxProcesses:2
C:\windows\system32\inetsrv\AppCmd.exe set apppool /apppool.name:SAN_LPADOCService_https /processModel.maxProcesses:2