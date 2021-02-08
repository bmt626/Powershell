$ErrorActionPreference = "Stop"
$accountFound = FALSE
Clear-Host
Write-Host "`n`n"
$searchAccount = Read-Host -Prompt "Username to check"
$accountFound = $FALSE
$unlockAccount = "Not Set"
Search-ADAccount -LockedOut -UsersOnly | ForEach-Object {if($searchAccount -eq $_.SamAccountName){$accountFound = $TRUE}else{}}
if($accountFound -eq $TRUE){
Write-Host "Account is Locked Out" -ForegroundColor Red}else{
Write-Host "Account is Unlocked" -ForegroundColor Green}
Write-Host "`n`n"
if($accountFound -eq $TRUE){
    $unlockAccount = Read-Host -Prompt "Would you like to unlock it? (y / n)"

    if($unlockAccount -eq "y"){
        Unlock-ADAccount -Identity $searchAccount
        Write-Host "Account has been unlocked" -ForegroundColor Cyan
    }else{
        Write-Host "No action has been taken" -ForegroundColor Yellow
    }
}
Write-Host "`n`n"