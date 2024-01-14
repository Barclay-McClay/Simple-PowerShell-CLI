Write-Host "--- Current top 10 RAM users ---" -ForegroundColor Green
$inRAM = Get-Process | Sort-Object WS -Descending
$counter = 0
foreach($process in $inRAM){
    if ($counter -lt 10) {
        Write-Host "$(($process.WS / 1MB).ToString("N0"))MB | $($process.Name)"
        $counter++
    }else{
        break
    }
}
Write-Host "--- --- --- --- --- --- --- ---" -ForegroundColor Green