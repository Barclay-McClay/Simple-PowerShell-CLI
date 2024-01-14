Write-Host " ---- Computer info: ---- " -ForegroundColor Green
$operatingSystem = Get-CimInstance Win32_OperatingSystem
$computerSystem = Get-CimInstance Win32_ComputerSystem
$cpuInfo = Get-CimInstance Win32_Processor
$storageInfo = Get-CimInstance Win32_LogicalDisk
$diskInfo = Get-CimInstance Win32_DiskDrive
$gpuInfo = Get-CimInstance Win32_DisplayConfiguration
$timeInfo = Get-CimInstance -ClassName Win32_LocalTime

$infoObject = [PSCustomObject]@{
    'Name' = $computerSystem.Name
    'Local Time' = "$($timeInfo.Day)/$($timeInfo.Month)/$($timeInfo.Year) $($timeInfo.Hour):$($timeInfo.Minute)" # DD/MM/YYY hh:mm
    'Domain' = $computerSystem.Domain
    'Serial Number' = $operatingSystem.SerialNumber
    'Motherboard' = "$($computerSystem.Model) | $($computerSystem.Manufacturer)"
    'Processor' = $cpuInfo.Name
    'GPU' = $gpuInfo.DeviceName
    'Operating System' = "$($operatingSystem.Caption), $($operatingSystem.OSArchitecture), Build $($operatingSystem.BuildNumber)"
    'Total RAM' = "$($computerSystem.TotalPhysicalMemory /1GB) GB"
    'Storage' = foreach ($drive in $storageInfo) {
            if ($drive.DriveType -eq 3) {
                "$($drive.DeviceID) $(($drive.FreeSpace/1GB).ToString("N2"))GB Free of $(($drive.Size/1GB).ToString("N2"))GB"
            }
        }
    'Disk' = foreach ($disk in $diskInfo) {
            "$($disk.DeviceID) $(($disk.Size /1GB).ToString("N2"))GB"
        }
}
$infoObject
