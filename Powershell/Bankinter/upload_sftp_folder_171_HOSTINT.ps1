<#  NAME: upload_117_email.ps1
    AUTHOR: manuel.monge@l-p-a.com
	DESCRIPTION: Upload files from a location to sftp location and send content by email to 
    a list of users
!!! PREREQUISITES: Powershell module Posh-SSH installed
                   Use this command to install: PS > Install-Module -Name Posh-SSH

    VARIABLES THAT CAN BE CONFIGURED BY COMMAND LINE:
    -------------------------------------------------
    Uploadfrom= "" - UNC path to original files wants to upload
	Uploadfolder=".\" - Directory where zipped files will be downloaded adn extracted
	SFTP_Server = "" - Sftp Server to upload

    STATIC VARIABLES:
    ----------------
    $SFTP_User= " " - User of Ftp Server
	$SFTP_Pass= " " - Pass of SFTP Server
    $SFTP_Port= " " - Port of SFTP Server
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

param(
[string]$Uploadfrom = "\\volpifssmb01\customer\BANKINTER\SFTP-Folders\folder171",
[string]$Uploadfolder = "/171/output/Reports/KID",
[string]$SFTP_Server = "sftp.modelity.com"
)

# SFTP SERVER VARIABLES

$SFTP_User ="lpa_inter_uat"
$SFTP_Pass = "Liu!2021"
$SFTP_Port = 22
   
# SFTP Connection Operation #
# Ensure Posh-SSH module is installed
$SFTP_Pass_Plain = ConvertTo-SecureString -String $SFTP_Pass -AsPlainText -Force
$SFTP_Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $SFTP_User, $SFTP_Pass_Plain
$SFTPSession = New-SFTPSession -ComputerName $SFTP_Server -Credential $SFTP_Credential -Port $SFTP_Port -AcceptKey

# Operations #

$DayofYear = Get-Date -Format "yyyy-MM-dd"

If((test-path -PathType container $Uploadfrom)) #Ensure orginal folder exists 
{
	$Foundedfiles =Get-ChildItem $Uploadfrom -Attributes Archive
	if (!(Test-SFTPPath -SessionId $SFTPSession.SessionId -Path $Uploadfolder)) #Ensure sftp destination folder exists 
	{
		echo "Upload Folder: $Uploadfolder don't exits"
	}
	else
	{
		If(!(test-path -PathType container $Uploadfrom\Uploaded\$DayofYear)) #Ensure backup destination folder exists; if not exists create it
		{
			New-Item -ItemType Directory -Path $Uploadfrom\Uploaded\$DayofYear
		}

		foreach ($file in $Foundedfiles)
		{
			if (('{0:yyyy-MM-dd}' -f $file.LastWriteTime) -eq $DayofYear)
			{
				#Write-Host $file.Fullname
				Set-SFTPItem -SessionId $SFTPSession.SessionId -Destination $Uploadfolder -Path $file.Fullname -Force
				Move-Item $file.Fullname $Uploadfrom\Uploaded\$DayofYear -Force
			}
			else
			{
				#Write-Host "FALLADO:" $file.Fullname
				
			}
		}
	}
}
else
{
	echo "UploadFrom: $Uploadfrom folder not found" 
}

Remove-SFTPSession -SFTPSession $SFTPSession 