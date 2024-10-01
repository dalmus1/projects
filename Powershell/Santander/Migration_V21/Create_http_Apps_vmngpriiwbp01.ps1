#FOLDER CREATION
xcopy /S /X /I E:\LPA\Webapps\adapterservice E:\LPA\Webapps\adapterserviceHttp
xcopy /S /X /I E:\LPA\Webapps\LPADocService E:\LPA\Webapps\LPADocServiceHttp 
xcopy /S /X /I E:\LPA\Webapps\TermsheetAdapterService_SAN E:\LPA\Webapps\TermsheetAdapterService

#COPY HTTP CONFIGS
xcopy /S /X /I E:\LPA_Utils\new_configs\AdapterServicehttpvmngpriiwbp01.web.config E:\LPA\Webapps\adapterserviceHttp\web.config
xcopy /S /X /I E:\LPA_Utils\new_configs\LpaDocServicehttpvmngpriiwbp01.web.config E:\LPA\Webapps\LPADocServiceHttp\web.config

#POOLS CREATION
C:\windows\system32\inetsrv\appcmd.exe ADD APPPOOL /name:"TermsheetAdapterServicehttp"  APPPOOL object "TermsheetAdapterService_http" 

#WEBAPPS CREATION
C:\windows\system32\inetsrv\AppCmd.exe add app /site.name:"Default Web Site HTTP" /path:/adapterservice /physicalPath:"E:\LPA\Webapps\AdapterServiceHttp"
C:\windows\system32\inetsrv\AppCmd.exe add app /site.name:"Default Web Site HTTP" /path:/LPADocService /physicalPath:"E:\LPA\Webapps\LPADocServiceHttp"
C:\windows\system32\inetsrv\AppCmd.exe add app /site.name:"Default Web Site HTTP" /path:/TermsheetAdapterService /physicalPath:"E:\LPA\Webapps\TermsheetAdapterService"

#CONFIG POOLS
C:\windows\system32\inetsrv\AppCmd.exe set app /app.name:"Default Web Site HTTP"/adapterservice /applicationPool:SAN_AdapterService_https
C:\windows\system32\inetsrv\AppCmd.exe set app /app.name:"Default Web Site HTTP"/LPADocService /applicationPool:SAN_ReleaseApps_https
C:\windows\system32\inetsrv\AppCmd.exe set app /app.name:"Default Web Site HTTP"/TermsheetAdapterService /applicationPool:TermsheetAdapterService_http