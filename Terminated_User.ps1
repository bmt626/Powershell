$user = Read-Host "Enter username: "
Write-Host "Setting Phone number to NOSYNC"
Set-ADUser -Identity $user -OfficePhone 'NOSYNC'
Write-Host "Clearing Manager"
Set-ADUser -Identity $user -Manager $null
Write-Host "Removing Groups"
foreach ($group in Get-ADPrincipalGroupMembership $user |Select-Object -ExpandProperty name){
    if ($group -ne "Domain Users"){
        Remove-ADGroupMember -Identity $group -Members $user -Confirm:$false
        }
}
Write-Host "Disabling Account"
Disable-ADAccount -Identity $user
