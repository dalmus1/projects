$PasswordProfile = New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile
$PasswordProfile.Password = "P@ssw0rd8!"
$PasswordProfile.EnforceChangePasswordPolicy = $true
New-AzureADUser -DisplayName "Monge" -PasswordProfile $PasswordProfile -UserPrincipalName "manuelmh@gmail.com" -AccountEnabled $true