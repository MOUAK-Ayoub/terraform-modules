<powershell>
#Open port 5985 or 5986 for all ipv4
New-NetFirewallRule -DisplayName "Allow winrm 5985 " -Direction Inbound -Action Allow  -Protocol TCP -LocalPort 5985 -RemoteAddress Any

# Allow basic authentication (username+password)
Set-Item -Path WSMan:\localhost\Service\Auth\basic -Value $true

# Allow unencrypted communication (NOT secure !!!)
Set-Item -Path WSMan:\localhost\Service\AllowUnencrypted -Value $true

# Add ansible user
$pwd = ConvertTo-SecureString "${ansible_pwd}" -AsPlainText -Force
$params = @{
    Name        = "${ansible_user}"
    Password    = $pwd
    Description = 'Ansible user'
}
New-LocalUser @params

# Add ansible user to administrator group
Add-LocalGroupMember -Group "Administrators" -Member "${ansible_user}"
</powershell>
