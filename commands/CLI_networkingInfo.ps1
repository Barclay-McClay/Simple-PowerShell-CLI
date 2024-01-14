# Local IP Information
Write-Host "Local IP Information:" -ForegroundColor Green
Get-NetIPAddress -AddressFamily IPv4 | Format-Table
# Public IP Information
Write-Host "`nPublic IP Information:" -ForegroundColor Green
Invoke-RestMethod -Uri 'http://ipinfo.io/json'
# Firewall
Write-Host "Windows Firewall Status:" -ForegroundColor Green
Get-NetFirewallProfile | Format-Table Name,Enabled