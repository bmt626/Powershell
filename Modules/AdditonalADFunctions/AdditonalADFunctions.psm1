<#
Powershell AD Module 
Developed by: Brandon Taylor 
Twitter: @bmt626
#>


Function Get-ADLockedOutUsers{
       <# 
    .SYNOPSIS

    Display a list of users who are currently locked out

    .EXAMPLE

    Get-ADLockedOutUsers

Name                SamAccountName
----                --------------
Joseph Dominique    jdominique
Hillel Nthanda      hnthanda
Chana Rainier       crainier

------------------------------------------------------------
Displays a list of currently locked out users

    #>
    Search-ADAccount -LockedOut -UsersOnly | Format-Table Name, SamAccountName
}

Function Search-ADUserLocedOutStatus{
       <# 
    .SYNOPSIS

    Ask user for an account to check the AD Locked Out status of and display the result
    If user is locked out it will ask if you would like to unlock it

    .EXAMPLE

Search-ADUserLocedOutStatus -Identity jdoe
Account is Unlocked

------------------------------------------------------------
Search if account is locked * Example of unlocked account *

.EXAMPLE

Search-ADUserLocedOutStatus -Identity jdoe

Account is Locked Out
Would you like to unlock it? (y / n):
------------------------------------------------------------
Search if account is locked * Example of a locked account *

    #>
    [CmdletBinding()]
        Param(
        [Parameter(Mandatory=$True,Position=1)]
        [string]$Identity
    )
# Stop the script on error message
$ErrorActionPreference = "Stop"
# boolean to determin if account was found in locked out users list
$accountFound = $FALSE
$unlockAccount = "Not Set"
# Search for specified account in locked out users
Search-ADAccount -LockedOut -UsersOnly | ForEach-Object {if($Identity -eq $_.SamAccountName){$accountFound = $TRUE}else{}}
if($accountFound -eq $TRUE){
Write-Host "Account is Locked Out" -ForegroundColor Red}else{
Write-Host "Account is Unlocked" -ForegroundColor Green}
if($accountFound -eq $TRUE){
    $unlockAccount = Read-Host -Prompt "Would you like to unlock it? (y / n)"

    if($unlockAccount -eq "y"){
        Unlock-ADAccount -Identity $Identity
        Write-Host "Account has been unlocked" -ForegroundColor Cyan
    }else{
        Write-Host "No action has been taken" -ForegroundColor Yellow
    }
}
Write-Host "`n"
}

Function Search-ADUsers{
   <# 
    .SYNOPSIS

    Display a list of AD users who match that name

    .EXAMPLE

Search-ADUsers -Name Brandon

Name                   SamAccountName
----                   --------------
Brandon Taylor         btaylor
Brandon Taylor - Admin admbtayor
Brandon Dalisto        bdalisto

------------------------------------------------------------
Displays list of users matching that name

.EXAMPLE

 Search-ADUsers -Name "Brandon Taylor"

Name                   SamAccountName
----                   --------------
Brandon Taylor         btaylor
Brandon Taylor - Admin admbtaylor

------------------------------------------------------------
Displays list of users matching that name

#>
    [CmdletBinding()]
        Param(
        [Parameter(Mandatory=$True,Position=1)]
        [string]$Name
    )
# Stop the script on error message
$ErrorActionPreference = "Stop"
$Name+="*"
Get-ADUser -Filter 'Name -like $Name' | Format-Table Name, SamAccountName
}



Function Get-ADPasswordStatus{
    <# 
    .SYNOPSIS

    Get the date the specified users password was last set and when it will expire

    .EXAMPLE

Get-ADPasswordStatus -Identity btaylor

Name           PasswordLastSet      ExpiryDate
----           ---------------      ----------
Brandon Taylor 1/4/2016 11:03:57 AM 5/3/2016 12:03:57 PM

------------------------------------------------------------
Displays the Password Last Set date and Password Experation Date for the user

    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True,Position=1)]
        [string]$Identity
    )
    Get-ADUser -Identity $Identity –Properties "Name", "msDS-UserPasswordExpiryTimeComputed", passwordlastset | Select-Object -Property "Name",PasswordLastSet,@{Name="ExpiryDate";Expression={[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")}}
    
    
}




