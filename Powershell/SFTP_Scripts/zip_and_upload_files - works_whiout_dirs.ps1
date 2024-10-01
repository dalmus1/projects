<#  NAME: aip_and_upload_files.ps1
    AUTHOR: manuel.monge@l-p-a.com
	DESCRIPTION: Download files with same name and diferent extension zip in one file
    and upload to sftp site
!!! PREREQUISITES: Powershell module Posh-SSH installed
                   Use this command to install: PS > Install-Module -Name Posh-SSH

    VARIABLES THAT CAN BE CONFIGURED BY COMMAND LINE:
    -------------------------------------------------
    Directorwithfiles=  UNC path to original files wants to zip and upload
	Uploadfolder=".\" - Directory where zipped files will be uplodaded
	SFTP_Server = "" - Sftp Server to upload


    STATIC VARIABLES:
    ----------------
    $SFTP_User= " " - User of Ftp Server
	$SFTP_Pass= " " - Pass of SFTP Server
    $SFTP_Port= " " - Port of SFTP Server
    
#>

param(
[string]$Directorwithfiles = "C:\Util_Scripts\Bankinter\345",
[string]$Uploadfolder = "/upload/clients/Bankinter",
[string]$SFTP_Server = "kaujcbikn5ec4.westeurope.azurecontainer.io"
)

# SFTP SERVER VARIABLES

$SFTP_User ="cdtechuser"
$SFTP_Pass = " cdtech.lpa123"
$SFTP_Port = 22

# INTERNAL VARIABLES
$TempWorkingDir = ".\temp"
$BackupDir = ".\Backup"

If(!(test-path -PathType container $TempWorkingDir)) #Ensure temporal working dir exits
	{
		New-Item -ItemType Directory -Path $TempWorkingDir
	}

If(!(test-path -PathType container $BackupDir)) #Ensure Backup foler exists if not exists create it
    {
        New-Item -ItemType Directory -Path $BackupDir
    }

$Foundedfiles = Get-ChildItem $Directorwithfiles -Recurse -Attributes Archive -Include *.pdf 

foreach ($file in $Foundedfiles)
{
    $CutedFileName = $file.FullName.Split("\")[-1]  
    Write-Output "CutedFileName: $CutedFileName"
    $Nameofzip = $CutedFileName -replace (".pdf", "") 
    Write-Output "Nameofzip: $Nameofzip "
    $Namesoffilestozip = ($Nameofzip -replace ("-compare", "")) + '*'
    Write-Output "Namesoffilestozip: $Namesoffilestozip"
    $FilesToCompress = ($Directorwithfiles + "\"+ $Namesoffilestozip)
    $CompressFile = ($TempWorkingDir + "\"+ $Nameofzip + '.zip')
    Write-Output "Ficheros_a_zippear:  $FilesToCompress  Fichero zip: $CompressFile"
    Compress-Archive -Path $FilesToCompress -DestinationPath $CompressFile -Force
}

# SFTP Connection Operation #
# Ensure Posh-SSH module is installed

<# SFTP_Pass_Plain = ConvertTo-SecureString -String $SFTP_Pass -AsPlainText -Force
SFTP_Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $SFTP_User, $SFTP_Pass_Plain
$SFTPSession = New-SFTPSession -ComputerName $SFTP_Server -Credential $SFTP_Credential -Port $SFTP_Port -AcceptKey

# Operations #

$filestoupload = Get-ChildItem $TempWorkingDir -Attributes Archive -Include *.zip
	if ((Test-SFTPPath -SessionId $SFTPSession.SessionId -Path $Uploadfolder)) #Ensure destination foler exists 
	{
		foreach ($file in $Foundedfiles)
		{
			echo $file.Fullname
			Set-SFTPItem -SessionId $SFTPSession.SessionId -Destination $Uploadfolder -Path $file.Fullname -Force
			Move-Item $file.Fullname $BackupDir -Force
		}
	}
	else
	{
		echo "Upload Folder: $Uploadfolder don't exits"
	}
Remove-SFTPSession -SFTPSession $SFTPSession  #>