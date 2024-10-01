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
#[string]$Downloadfolder = "\\volpifssmb01\customer\DEKA\DekaFonds\FinRP\Release",
[string]$Downloadfolder = "\\vmlpdkisvc01a\d$\Capmatix DekaFonds\Services\GetFilesFromSFTP",
[string]$SFTP_FileExtension = "zip"
)

# SFTP SERVER VARIABLES
$SFTP_Server = "hsftpint.l-p-a.info "
$SFTP_User ="dekafondsuser01"
$SFTP_Pass = "HXbCFleW},+1"
$SFTP_Path = "/upload/INT/FinRP/Release"
$SFTP_Port = 22


# SFTP Download Operation #
# Ensure Posh-SSH module is installed
$SFTP_Pass_Plain = ConvertTo-SecureString -String $SFTP_Pass -AsPlainText -Force
$SFTP_Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $SFTP_User, $SFTP_Pass_Plain
$SFTPSession = New-SFTPSession -ComputerName $SFTP_Server -Credential $SFTP_Credential -KeyFile $keyFile -Port $SFTP_Port -AcceptKey
$Foundedzips = Get-SFTPChildItem  -SessionId $SFTPSession.SessionId -Path $SFTP_Path -File

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
}
Remove-SFTPSession -SFTPSession $SFTPSession