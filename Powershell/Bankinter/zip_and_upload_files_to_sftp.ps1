<#  NAME: zip_and_upload_files_to_sftp.ps1
    AUTHOR: manuel.monge@l-p-a.com
	DESCRIPTION: Download files with same name and diferent extension zip in one file
    and upload to sftp site
!!! PREREQUISITES: Powershell module Posh-SSH installed
                   Use this command to install: PS > Install-Module -Name Posh-SSH

    VARIABLES THAT CAN BE CONFIGURED BY COMMAND LINE:
    -------------------------------------------------
    Directorywithfiles=  UNC path to original files wants to zip and upload
	Uploadfolder=".\" - Directory where zipped files will be uplodaded
	SFTP_Server = "" - Sftp Server to upload


    STATIC VARIABLES:
    ----------------
    $SFTP_User= " " - User of Ftp Server
	$SFTP_Pass= " " - Pass of SFTP Server
    $SFTP_Port= " " - Port of SFTP Server
    
#>

param(
[string]$Directorywithfiles = "\\volpifssmb01\customer\BANKINTER\SFTP-Folders\CMVM\280\",
[string]$Uploadfolder = "/CMVM/280",
[string]$SFTP_Server = "sftp.modelity.com"
)

# SFTP SERVER VARIABLES

$SFTP_User ="lpa_inter_uat"
$SFTP_Pass = "Liu!2021"
$SFTP_Port = 22

# INTERNAL VARIABLES
$TempWorkingDir = "d:\Capmatix Bankinter\Services\UploadScripts\temp"
$DirectoryOfBackups = "\\volpifssmb01\customer\BANKINTER\SFTP-Folders\CMVM\Backup_280\"
$log="d:\Capmatix Bankinter\Services\UploadScripts\temp\log.log"

$DayofYear = Get-Date -Format "yyyy-MM-dd"
echo $DayofYear
If(!(test-path -PathType container $TempWorkingDir)) #Ensure temporal working dir exits
	{
		New-Item -ItemType Directory -Path $TempWorkingDir
	}

$BackupDir=$DirectoryOfBackups + $DayofYear

    If(!(test-path -PathType container $BackupDir)) #Ensure Backup foler exists if not exists create it
    {
        New-Item -ItemType Directory -Path $BackupDir
    }

$Foundedfiles = Get-ChildItem $Directorywithfiles -Recurse -Attributes Archive -Include *.pdf -Exclude @('*compare*', '*Backup*')
Write-Output $Foundedfiles >> $log

foreach ($file in $Foundedfiles)
{
    $CutedFileName = $file.FullName.Split("\")[-1]  # Obtain the name of principal pdf
    $Nameofzip = $CutedFileName -replace (".pdf", "")   # Suppres .pdf of the name Name of future .zip file
    $Route= ($file.FullName -replace ($file.FullName.Split("\")[-1]),"")  # Obtain route to file 
    $FilesToCompress = ($Route + "*" + $Nameofzip +"*")    # String with files that will be compressed
    $CompressFile = ($TempWorkingDir + "\"+ $Nameofzip + '.zip')  # Name of .zip file that will be created
    Write-Output "Files to zip:  $FilesToCompress  ZipFile: $CompressFile" >> $log
    Compress-Archive -Path $FilesToCompress -DestinationPath $CompressFile -Force
    Move-Item $Route $BackupDir -Force

}

# SFTP Connection Operation #
# Ensure Posh-SSH module is installed

$SFTP_Pass_Plain = ConvertTo-SecureString -String $SFTP_Pass -AsPlainText -Force
$SFTP_Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $SFTP_User, $SFTP_Pass_Plain
$SFTPSession = New-SFTPSession -ComputerName $SFTP_Server -Credential $SFTP_Credential -Port $SFTP_Port -AcceptKey

# Operations #

$filestoupload = Get-ChildItem $TempWorkingDir -Recurse -Attributes Archive -Include *.zip
Write-Output $filestoupload $TempWorkingDir >> $log

	if (!(Test-SFTPPath -SessionId $SFTPSession.SessionId -Path $Uploadfolder)) #Ensure destination foler exists 
	{
        echo "Upload Folder: $Uploadfolder don't exits"
	}
	else
	{
        foreach ($file in $filestoupload)
		{
			echo $file.Fullname >> $log
			Set-SFTPItem -SessionId $SFTPSession.SessionId -Destination $Uploadfolder -Path $file.Fullname -Force
			Remove-Item $file.Fullname -Force
		}
	}
Remove-SFTPSession -SFTPSession $SFTPSession 
