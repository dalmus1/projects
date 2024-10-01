param(
    [string]$parameter = ""
    )

$GlobalUrl = "lpakid.gcb.dev.corp"
$FalseUrl= "lpanohost.gcb.dev.corp"
$FalseNode= "lpanonode.gcb.dev.corp"


switch ($parameter)
{
      "SwitchV17" {
            #Unset and shutdwon HTTPS V21
            C:\windows\system32\inetsrv\appcmd.exe set SITE /site.name:"Default Web Site HTTPS" /bindings:"https://"$FalseUrl":9999,https://"$FalseNode":9999" 
            C:\windows\system32\inetsrv\appcmd.exe stop site /site.name:"Default Web Site HTTPS"
            #Unset and shutdwon HTTP V21
            C:\windows\system32\inetsrv\appcmd.exe set SITE /site.name:"Default Web Site HTTP" /bindings:"http://"$FalseUrl":7777,http://"$FalseNode":7777"
            C:\windows\system32\inetsrv\appcmd.exe stop site /site.name:"Default Web Site HTTP"
            #Set and start Default Web Site (V17)
            C:\windows\system32\inetsrv\appcmd.exe set SITE /site.name:"Default Web Site" /bindings:http://*:80
            C:\windows\system32\inetsrv\appcmd.exe start site /site.name:"Default Web Site"
            ; Break
      }
      "SwitchV21" {
            #Unset and shutdwon HTTPS V21
            C:\windows\system32\inetsrv\appcmd.exe set SITE /site.name:"Default Web Site HTTPS" /bindings:"https://"$GlobalUrl":443,https://"$Node":443"
            C:\windows\system32\inetsrv\appcmd.exe start site /site.name:"Default Web Site HTTPS"
            #Unset and shutdwon HTTP V21
            C:\windows\system32\inetsrv\appcmd.exe set SITE /site.name:"Default Web Site HTTP" /bindings:"http://"$GlobalUrl":80,http://"$Node":80"
            C:\windows\system32\inetsrv\appcmd.exe start site /site.name:"Default Web Site HTTP"
            #Set and start Default Web Site (V17)
            C:\windows\system32\inetsrv\appcmd.exe set SITE /site.name:"Default Web Site" /bindings:"http://"$FalseNode":7777" 
            C:\windows\system32\inetsrv\appcmd.exe stop site /site.name:"Default Web Site"
            ; Break
      }
      Default {
            Write-Host "usage: .\Rollback.ps1 [installation|SwitchV17|SwitchV21]"
      }
}
