 <# 
 Created by: Brandon Taylor
 Twitter: @bmt626
 #>

 function Get-LastRebootTime
{
<#
.SYNOPSIS
Get the Last reboot time of a Computer

.EXAMPLE
Get-LastRebootTime -ComputerName DESKTOP-62k2lsj

Monday, December 7, 2015 4:19:43 PM
#>
[CmdletBinding()]
    Param(
        [Parameter(Position=1)]
        [string]$ComputerName
    )
Get-EventLog -ComputerName $ComputerName -LogName System | Where-Object { $_.EventId -eq 6009 } | Select-Object -first 1 | ForEach-Object { $_.TimeGenerated; break }
}

function Get-LoggedOnUser
{
<#
.SYNOPSIS
Get the username of users logged onto a remote computer

.EXAMPLE
Get-LoggedOnUser
#>
[CmdletBinding()]
    Param(
        [Parameter(Position=1)]
        [string]$ComputerName
    )
Get-WmiObject win32_computersystem -comp $ComputerName | Select-Object Username, Caption, Manufacturer

}
