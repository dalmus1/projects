<#  NAME: collect_files.ps1
    AUTHOR: manuel.monge@l-p-a.com
    DESCRIPTION: Download zip files from a sftp location and extract locally
!!! PREREQUISITES: Powershell module Posh-SSH installed
                   Use this command to install: PS > Install-Module -Name Posh-SSH

    VARIABLES THAT CAN BE CONFIGURED BY COMMAND LINE:
    -------------------------------------------------
    Destinationfolder="unziped"  - Path where zip files will be extracted
    Downloadfolder=".\" - Directory where zipped files will be downloaded

    STATIC VARIABLES:
    ----------------
    $SFTP_Server=" "
    $SFTP_Pass= " "
    $SFTP_IdentFile=""
    $SFTP_Path= "" path inside sftp root directory, can be include wildcards "upload/*.zip"
#>

param(
[string]$Downloadfolder = ".\",
[String]$Destinationfolder = "unziped"
)

# SFTP SERVER VARIABLES
#$SFTP_Server = "rdo4yygryv2ao.westeurope.azurecontainer.io"
#$SFTP_User ="kutxa_temp"
#$SFTP_Pass = "9,CBc?z!C2"
#$SFTP_Path= "upload/IN1551864.zip"

$SFTP_Server = "test.rebex.net"
$SFTP_User ="demo"
$SFTP_Pass = "password"
$SFTP_Path= "pub/example/readme.txt"


# SFTP Download Operation #
# Ensure Posh-SSH module is installed
$SFTP_Pass_Plain = ConvertTo-SecureString -String $SFTP_Pass -AsPlainText -Force
$SFTP_Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $SFTP_User, $SFTP_Pass_Plain
$SFTPSession = New-SFTPSession -ComputerName $SFTP_Server -Credential $SFTP_Credential
Get-SFTPItem -SessionId $SFTPSession.SessionId -Path $SFTP_Path -Destination $Downloadfolder 
Remove-SFTPSession -SFTPSession $SFTPSession

# Extraction Operations #
$Foundedzips = Get-ChildItem $Downloadfolder -Filter *.zip 

If(!(test-path -PathType container $Destinationfolder)) #Ensure destination foler exists if not exists create it
{
      New-Item -ItemType Directory -Path $Destinationfolder
}

foreach ($file in $Foundedzips)
{
    Expand-Archive -LiteralPath $Downloadfolder$file -DestinationPath $Destinationfolder -Force
    Remove-Item -LiteralPath $Downloadfolder$file -Force
}