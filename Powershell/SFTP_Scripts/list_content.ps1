<#  NAME: upload_sftp.ps1
    AUTHOR: manuel.monge@l-p-a.com
	DESCRIPTION: Show files in a sftp location
!!! PREREQUISITES: Powershell module Posh-SSH installed
                   Use this command to install: PS > Install-Module -Name Posh-SSH

    
#>


# SFTP SERVER VARIABLES
$SFTP_Server = "hsftpint.l-p-a.info"
$SFTP_User ="dekafondsuser01"
$SFTP_Pass = "HXbCFleW},+1"
$SFTP_Port = 22


# SFTP Connection Operation #
# Ensure Posh-SSH module is installed
$SFTP_Pass_Plain = ConvertTo-SecureString -String $SFTP_Pass -AsPlainText -Force
$SFTP_Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $SFTP_User, $SFTP_Pass_Plain
$SFTPSession = New-SFTPSession -ComputerName $SFTP_Server -Credential $SFTP_Credential -Port $SFTP_Port -AcceptKey
Get-SFTPChildItem  -SessionId $SFTPSession.SessionId -Path "." -File

#$Foundedzips = Get-SFTPChildItem  -SessionId $SFTPSession.SessionId -Path $Uploadfolder -File
Remove-SFTPSession -SFTPSession $SFTPSession
