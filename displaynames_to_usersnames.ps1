<#
    In the file of names you should format the names as FistName*LastName*
    EX - John*Doe* 
    This will ensure you find the user if they have their middle inital in the name like John A. Doe
    also the * at end will help for people who hyphenate their name
    EX - Sally*Jane* would return Sally Jane-Doe
#>

$usernamelist = Get-content "E:\tmp\userfirstlast.txt"
foreach ($user in $usernamelist){
    if($user){
    Get-ADUser -Filter "displayname -like '$user'" | Format-Table -HideTableHeaders samAccountName | Out-String | ForEach-Object { $_.Trim() }  | Out-File "E:\tmp\usernames.txt" -Append
    }
    else{
    Write-Output "User not found"
    }
}
