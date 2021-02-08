$usernamelist = Get-content "E:\tmp\userfirstlast.txt"
$usernames = @()
foreach ($user in $usernamelist){
    $firstname = $user.split(" ")[0]
    $lastname = $user.split(" ")[1]

    if(Get-ADUser -Filter "displayname -like '$firstname $lastname'"){
    $usernames += Get-ADUser -Filter "displayname -like '$firstname $lastname'" | Format-Table -HideTableHeaders samAccountName | Out-String | ForEach-Object { $_.Trim() }
    }
    else{
        Write-Host "$firstname $lastname not found - searching for all users with the lastname: $lastname"
        $i = 1
        $choices = @()
        foreach ($name in Get-ADUser -Filter "Surname -like '$lastname'" | Select-Object -ExpandProperty Name){
            write-host "($i)" $name
            $choices += $name
            $i++
        }
        $choice = Read-Host "Which User do you want the username for? "
        $choice = $choice -as [int]
        $choice--
        if($choice -ge 0 -And $choice -lt $choices.Count){
            $displayname = $choices[$choice]
            $usernames += Get-ADUser -Filter "displayname -like '$displayname'" | Format-Table -HideTableHeaders samAccountName | Out-String | ForEach-Object { $_.Trim() }
        }
        else{
            Write-Host "INVALID CHOICE"
        }

     }
}
Write-Host "*******RESETING USERS PASSWORDS*******"
$password = ConvertTo-SecureString -String "CHANGEME123" -AsPlainText -Force
foreach ($user in $usernames){
    if($user){
        Set-ADAccountPassword $user -NewPassword $password -Reset
        Set-ADUser $user -ChangePasswordAtLogon $true
        Unlock-ADAccount -Identity $user
        Write-Output "$user's password was reset"
    }
    else{
        Write-Output "user not found"
    }
}