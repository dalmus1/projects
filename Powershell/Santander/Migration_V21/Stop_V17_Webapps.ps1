$FalseNode= "lpanonode.gcb.dev.corp"

#Stop AppPools
C:\windows\system32\inetsrv\appcmd.exe stop APPPOOL /apppool.name:"AdapterService"
C:\windows\system32\inetsrv\appcmd.exe stop APPPOOL /apppool.name:"APIService"
C:\windows\system32\inetsrv\appcmd.exe stop APPPOOL /apppool.name:"DebugDocGenerator"
C:\windows\system32\inetsrv\appcmd.exe stop APPPOOL /apppool.name:"DebugDocWorkflowService"
C:\windows\system32\inetsrv\appcmd.exe stop APPPOOL /apppool.name:"DebugDownloadDocumentService"
C:\windows\system32\inetsrv\appcmd.exe stop APPPOOL /apppool.name:"DebugHangfire"
C:\windows\system32\inetsrv\appcmd.exe stop APPPOOL /apppool.name:"DebugLPADocService"
C:\windows\system32\inetsrv\appcmd.exe stop APPPOOL /apppool.name:"DocDesignerWebApi"
C:\windows\system32\inetsrv\appcmd.exe stop APPPOOL /apppool.name:"DocGenerator"
C:\windows\system32\inetsrv\appcmd.exe stop APPPOOL /apppool.name:"DocGenExcelAddInService"
C:\windows\system32\inetsrv\appcmd.exe stop APPPOOL /apppool.name:"DocWorkflowService"
C:\windows\system32\inetsrv\appcmd.exe stop APPPOOL /apppool.name:"DownloadDocumentService"
C:\windows\system32\inetsrv\appcmd.exe stop APPPOOL /apppool.name:"Hangfire"
C:\windows\system32\inetsrv\appcmd.exe stop APPPOOL /apppool.name:"LPADocService"
C:\windows\system32\inetsrv\appcmd.exe stop APPPOOL /apppool.name:"MarketDataServer"
C:\windows\system32\inetsrv\appcmd.exe stop APPPOOL /apppool.name:"ProdDesigner"
C:\windows\system32\inetsrv\appcmd.exe stop APPPOOL /apppool.name:"TermsheetsAdapterService"
C:\windows\system32\inetsrv\appcmd.exe stop APPPOOL /apppool.name:"TranslationTool"
C:\windows\system32\inetsrv\appcmd.exe stop APPPOOL /apppool.name:"WorkflowService"

#Unconfig site "Default Web Service" and stop Site
C:\windows\system32\inetsrv\appcmd.exe set SITE /site.name:"Default Web Site" /bindings:"http://"$FalseNode":7777" 
C:\windows\system32\inetsrv\appcmd.exe stop site /site.name:"Default Web Site"
