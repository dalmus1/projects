<#  NAME: upload_sftp.ps1
    AUTHOR: manuel.monge@l-p-a.com
	DESCRIPTION: Upload files from a location to sftp location
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
    
#>

param(
[string]$Uploadfrom = "\\VOLPPFSSMB01\customer\BANKINTER\SFTP-Folders\folder171",
[string]$Uploadfolder = "/171/output/Reports/KID",
[string]$SFTP_Server = "sftp.modelity.com"
)

# SFTP SERVER VARIABLES

$SFTP_Server = "sftp.modelity.com"
$SFTP_User ="lpa_inter_prod"
$SFTP_Port = 22
$KeyFile = "d:\Capmatix Bankinter\Services\UploadScripts\private_key_prod_bkt.key"

# SFTP Connection Operation #
# Ensure Posh-SSH module is installed
$nopasswd = New-Object System.Security.SecureString
$SFTP_Credential = New-Object System.Management.Automation.PSCredential ($SFTP_User, $nopasswd)
$SFTPSession = New-SFTPSession -ComputerName $SFTP_Server -KeyFile $KeyFile -Credential $SFTP_Credential -Port $SFTP_Port -AcceptKey

# Operations #

$DayofYear = Get-Date -Format "yyyy-MM-dd"
#$DayofYear = "2023-01-02" if needed to run the files from other date than today#
$LOG = $Uploadfrom + '\Uploaded\sftp_upload171' + $DayofYear + '.log'
If((test-path -PathType container $Uploadfrom)) #Ensure orginal foler exists 
{
	$Foundedfiles =Get-ChildItem $Uploadfrom -Attributes Archive
	if (!(Test-SFTPPath -SessionId $SFTPSession.SessionId -Path $Uploadfolder)) #Ensure destination foler exists 
	{
		echo "Upload Folder: $Uploadfolder don't exits"
	}
	else
	{
		If(!(test-path -PathType container $Uploadfrom\Uploaded\$DayofYear)) #Ensure destination foler exists if not exists create it
		{
			New-Item -ItemType Directory -Path $Uploadfrom\Uploaded\$DayofYear
		}

		foreach ($file in $Foundedfiles)
		{
			if (('{0:yyyy-MM-dd}' -f $file.LastWriteTime) -eq $DayofYear)
			{
				echo $file.Fullname  >> $LOG
				Set-SFTPItem -SessionId $SFTPSession.SessionId -Destination $Uploadfolder -Path $file.Fullname -Force  >> $LOG
				Move-Item $file.Fullname $Uploadfrom\Uploaded\$DayofYear -Force
			}
			else
			{
				echo "FALLADO:" $file.Fullname  >> $LOG
				
			}
		}		
	}

}
else
{
	echo "UploadFrom: $Uploadfrom folder not found" 
}

Remove-SFTPSession -SFTPSession $SFTPSession