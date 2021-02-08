$usernames = Get-Content "E:\tmp\usernames.txt"
$password = ConvertTo-SecureString -String "CHANGEME123" -AsPlainText -Force
foreach ($user in $usernames){
    if($user){
        Set-ADAccountPassword $user -NewPassword $password -Reset
        Write-Output "$user's password was reset"
    }
    else{
        Write-Output "user not found"
    }
}