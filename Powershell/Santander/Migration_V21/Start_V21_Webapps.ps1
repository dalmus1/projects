#Start AppPools
C:\windows\system32\inetsrv\appcmd.exe start APPPOOL /apppool.name:"SAN_AdapterService_http"
C:\windows\system32\inetsrv\appcmd.exe start APPPOOL /apppool.name:"SAN_AdapterService_https"
C:\windows\system32\inetsrv\appcmd.exe start APPPOOL /apppool.name:"SAN_CapmatixAPI_https"
C:\windows\system32\inetsrv\appcmd.exe start APPPOOL /apppool.name:"SAN_DebugApps_https"
C:\windows\system32\inetsrv\appcmd.exe start APPPOOL /apppool.name:"SAN_DebugDocworkflowservice_https"
C:\windows\system32\inetsrv\appcmd.exe start APPPOOL /apppool.name:"SAN_DebugDocGen_https"
C:\windows\system32\inetsrv\appcmd.exe start APPPOOL /apppool.name:"SAN_DebugHangfire_https"
C:\windows\system32\inetsrv\appcmd.exe start APPPOOL /apppool.name:"SAN_Docworkflowservice_https"
C:\windows\system32\inetsrv\appcmd.exe start APPPOOL /apppool.name:"SAN_Hangfire_https"
C:\windows\system32\inetsrv\appcmd.exe start APPPOOL /apppool.name:"SAN_IDServer_https"
C:\windows\system32\inetsrv\appcmd.exe start APPPOOL /apppool.name:"SAN_LPADOCService_https" 
C:\windows\system32\inetsrv\appcmd.exe start APPPOOL /apppool.name:"SAN_LPADOCService_http" 
C:\windows\system32\inetsrv\appcmd.exe start APPPOOL /apppool.name:"SAN_MarketDataServer"
C:\windows\system32\inetsrv\appcmd.exe start APPPOOL /apppool.name:"SAN_MarketDataServer_https"
C:\windows\system32\inetsrv\appcmd.exe start APPPOOL /apppool.name:"SAN_NoDotNetApps_https"
C:\windows\system32\inetsrv\appcmd.exe start APPPOOL /apppool.name:"SAN_ReleaseApps_http"
C:\windows\system32\inetsrv\appcmd.exe start APPPOOL /apppool.name:"SAN_ReleaseApps_https"
C:\windows\system32\inetsrv\appcmd.exe start APPPOOL /apppool.name:"SAN_ReleaseDocGen_https"
C:\windows\system32\inetsrv\appcmd.exe start APPPOOL /apppool.name:"SAN_WorkflowService_https"
C:\windows\system32\inetsrv\appcmd.exe start APPPOOL /apppool.name:"ThermsheetAdapterService_http"


#Config site "Default Web Service" and start Site
C:\windows\system32\inetsrv\appcmd.exe set SITE /site.name:"Default Web Site HTTP" /bindings:"http://*:80" 
C:\windows\system32\inetsrv\appcmd.exe start site /site.name:"Default Web Site"

C:\windows\system32\inetsrv\appcmd.exe set SITE /site.name:"Default Web Site HTTP" /bindings:"http://*:443" 
C:\windows\system32\inetsrv\appcmd.exe start site /site.name:"Default Web Site HTTPS"

