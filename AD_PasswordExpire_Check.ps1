Write-Host "`n`n`nChecking AD User for password expiration date"
$adUser = Read-Host -Prompt "Enter User ID"
Get-ADUser -Identity $adUser –Properties "DisplayName", "msDS-UserPasswordExpiryTimeComputed" | Select-Object -Property "Displayname",@{Name="ExpiryDate";Expression={[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")}}