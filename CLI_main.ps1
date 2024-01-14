Do {
    Write-Host @"
[1] Computer Info
[2] Networking Info
[3] Top RAM Eaters
[4] Chrome Bookmarks
[?] Help / About / Credits
[Q] Quit
"@ -ForeGroundColor Cyan
    $menuChoice = Read-Host
    switch ($menuChoice) {
        '1' {
            & ".\commands\CLI_info.ps1"
        }
        '2' {
            & ".\commands\CLI_networkingInfo.ps1"
        }
        '3' {
            & ".\commands\CLI_showRAMUsage.ps1"
        }
        '4' {
            & ".\commands\CLI_chromeBookmarks.ps1"
        }
        '?' {
            Write-Host "Created by Barclay McClay"
            break
        }
        'q' {
            break
        }
        default {
            Write-Host "- Invalid Input -" -ForegroundColor Red
        }
    }
}Until ($menuChoice -eq 'q')
# If we've made it out of the Do{}Until() loops somehow- then exit gracefully.
Write-Host "Exiting..."
exit