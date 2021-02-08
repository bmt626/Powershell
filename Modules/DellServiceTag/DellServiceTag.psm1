function Get-DellServiceTag
{
Get-CimInstance -ClassName Win32_ComputerSystemProduct | Select-Object -Property Vendor,Name,IdentifyingNumber
}