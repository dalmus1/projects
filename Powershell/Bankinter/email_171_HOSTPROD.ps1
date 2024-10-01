<#  NAME: upload_117_email.ps1
    AUTHOR: manuel.monge@l-p-a.com
	DESCRIPTION: Sen by email uploaded files insend content by email to a list of users

    STATIC VARIABLES:
    ----------------
    Uploadfrom= "" - UNC path to original files wants to upload

    # MAIL VARIABLES
    $Sender = Sender of emial
    $To_list = Comma separated list with emails
    $MailSubject = Subject of mail will be send
    $SMTPDeliverer=  Smtp Server used to send email
    $SMTPPort =  Smtp port of Smtp server (25 mis default)
    $BodyMessage = Body of message
    $AttachFilePath = Local folder to temporary files
    $AttachFile = Base of names for attached file
    $AttachFileExtension = Extension of names for attached file      
#>

$Uploadfrom = "\\VOLPPFSSMB01\customer\BANKINTER\SFTP-Folders\folder171"
# MAIL VARIABLES

$Sender="noreply@L-P-A.com"
$To_list= ("manuel.monge@l-p-a.com","ignacio.alvarez@l-p-a.com","luis.veras@l-pa-com")
$MailSubject= "Ficheros de Seguros de Cambio diario "
$SMTPDeliverer= "mx.lpa.adns.de"
$SMTPPort= "25"
$BodyMessage ="El software de Seguros de Cambio ha ejecutado los ficheros del listado adjunto el dia "
$AttachFilePath = "D:\Capmatix Bankinter\Services\UploadScripts\temp\"
$AttachFile = "Seguros_de_cambio_"
$AttachFileExtension = "txt"
 

# Operations #

$DayofYear = Get-Date -Format "yyyy-MM-dd"
$UploadedFiles = $Uploadfrom + '\Uploaded\sftp_upload171\' + $DayofYear
Get-ChildItem $UploadedFiles -Attributes Archive|out-file $AttachFilePath$AttachFile.$AttachFileExtension
foreach ($destination in $To_list)
{
 Send-MailMessage -From  $Sender -Subject $MailSubject$DayofYear -To $destination -Attachments $AttachFilePath$AttachFile.$AttachFileExtension -Body $BodyMessage$DayofYear -SmtpServer $SMTPDeliverer -Port $SMTPPort
}
Remove-item $AttachFilePath$AttachFile.$AttachFileExtension
