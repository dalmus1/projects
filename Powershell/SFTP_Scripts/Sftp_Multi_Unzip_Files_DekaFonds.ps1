<#  NAME: collect_files.ps1
    AUTHOR: manuel.monge@l-p-a.com
    DESCRIPTION: Download zip files from a sftp location and extract locally
!!! PREREQUISITES: Powershell module Posh-SSH installed
                   Use this command to install: PS > Install-Module -Name Posh-SSH

    VARIABLES THAT CAN BE CONFIGURED BY COMMAND LINE:
    -------------------------------------------------
        Downloadfolder=".\" - Directory where zipped files will be downloaded adn extracted
        SFTP_Fileextension= "zip" Extension of the zipped files

    STATIC VARIABLES:
    ----------------
    $SFTP_Server=" "
    $SFTP_Pass= " "
    $SFTP_IdentFile=""
    $SFTP_Path= "" path inside sftp root directory, can not include wildcards
    
#>

param(
[string]$Downloadfolder = "C:\Util_Scripts\test_sftp",
[string]$SFTP_FileExtension = "png"
)

# SFTP SERVER VARIABLES
$SFTP_Server = "hsftpint.l-p-a.info"
$SFTP_User ="dekafondsuser01"
$SFTP_Pass = "HXbCFleW},+1"
$SFTP_Path = "pub/example/"
$SFTP_Port = 22
$Destination_Unzipped_Files = "\\int.l-p-a.com\dfs\sftp02\dekafondsuser01\Release"

# SFTP Download Operation #
# Ensure Posh-SSH module is installed
$SFTP_Pass_Plain = ConvertTo-SecureString -String $SFTP_Pass -AsPlainText -Force
$SFTP_Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $SFTP_User, $SFTP_Pass_Plain
$SFTPSession = New-SFTPSession -ComputerName $SFTP_Server -Credential $SFTP_Credential -KeyFile $keyFile -Port $SFTP_Port -AcceptKey
$Foundedzips = Get-SFTPChildItem  -SessionId $SFTPSession.SessionId -Path $SFTP_Path -File

#$Foundedzips = (Get-SFTPChildItem  -SessionId $SFTPSession.SessionId -Path $SFTP_Path)

#Get-SFTPChildItem [-SessionId] <Int32[]> [[-Path] <String>] [-Recurse] [-Directory] [-File]
#Get-SFTPItem -SessionId $SFTPSession.SessionId -Path $SFTP_Path -Destination $Downloadfolder 
# Extraction Operations #

If(!(test-path -PathType container $Downloadfolder)) #Ensure destination foler exists if not exists create it
{
      New-Item -ItemType Directory -Path $Downloadfolder
}

foreach ($file in $Foundedzips.FullName)
{
    if ($file -match $SFTP_FileExtension) 
    {
    Get-SFTPItem -SessionId $SFTPSession.SessionId -Path $File -Destination $Downloadfolder
    $CutedFileName = $file -replace [Regex]::Escape("/$SFTP_Path"), "\" 
    Expand-Archive -LiteralPath $Downloadfolder$CutedFileName -DestinationPath $Downloadfolder -Force
    Remove-Item -LiteralPath $Downloadfolder$CutedFileName -Force
    }
    Move-Item -Path $Downloadfolder\* -Destination $Destination_Unzipped_Files -Force
}
Remove-SFTPSession -SFTPSession $SFTPSession

