 
$ComputerName = Read-Host -Prompt "Enter Computer Name"
Get-EventLog -ComputerName $ComputerName -LogName System | 
    Where-Object { $_.EventId -eq 6009 } | 
    Select-Object -first 1 | 
    ForEach-Object { $_.TimeGenerated; break }