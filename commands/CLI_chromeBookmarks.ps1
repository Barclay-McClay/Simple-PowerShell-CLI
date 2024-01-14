function Get-ChromeBookmarkContent {
    param (
        [string]$filePath = "%localappdata%\Google\Chrome\User Data\Default\Bookmarks"
    )
    
    # Convert environment variable to a full path
    $fullPath = [System.Environment]::ExpandEnvironmentVariables($filePath)
    
    # Create a temporary file path
    $tempFile = "$($fullPath)_temp.json"

    try {
        # Copy the file to a temp location
        Copy-Item -Path $fullPath -Destination $tempFile -ErrorAction Stop

        # Get the contents of the file
        $fileContent = Get-Content -Path $tempFile -ErrorAction Stop

        # Convert the JSON content to a PowerShell object
        $jsonContent = $fileContent | ConvertFrom-Json -ErrorAction Stop
        $bookmarks = Convert-ToHashTable -jsonData $jsonContent.roots.bookmark_bar
        return $bookmarks
    } catch {
        Write-Host "Something went wrong" -Foregroundcolor Red
    } finally {
        # Delete the temp file
        if (Test-Path -Path $tempFile) {
            Remove-Item -Path $tempFile -Force -ErrorAction SilentlyContinue
        }
    }
}

function Convert-ToHashTable {
    param (
        [PSObject]$jsonData
    )

    # Initialize an empty hash table
    $result = @{}

    # Process each object in the JSON data
    foreach ($object in $jsonData) {
        if ($object.type -eq 'url') {
            # Add the url to the hash table
            $result[$object.name] = $object.url
        }
        elseif ($object.type -eq 'folder') {
            # If the object is a folder, recurse into its children
            $childResults = Convert-ToHashTable -jsonData $object.children

            # Merge the child results into the main hash table
            $result += $childResults
        }
    }

    return $result
}


####################

# Sort the bookmarks by key (name)
$bookmarkContent = Get-ChromeBookmarkContent
$sortedBookmarks = $bookmarkContent.GetEnumerator() | Sort-Object -Property Key

# Present the bookmarks to the user
$index = 1
$bookmarkList = @{}
foreach ($bookmark in $sortedBookmarks) {
    if($bookmark.Value[0] -ne 'c') { # skip chrome utility pages
        Write-Host "[$($index)] $($bookmark.Key) | ($($bookmark.Value))" -ForegroundColor Blue # write the list of urls
        $bookmarkList[$index.ToString()] = $bookmark.Value
        $index++
    }
}
Write-Host '[Q] Go back' -ForegroundColor DarkGray

# Get the user's selection
do {
    Write-Host 'Enter the number of the bookmark you want to open:' -ForegroundColor Cyan
    $selectedNumber = Read-Host
    Try {
        if(($bookmarkList.count -ge $selectedNumber)-and($selectedNumber -gt 0)){
            Start-Process $bookmarkList[$selectedNumber] # go to the place
        }else{
            Write-Host "Enter a number between 1 and $($bookmarkList.count) (or 'q' to quit)" -ForegroundColor Red
        }
    }Catch{
        if($selectedNumber -ne 'q'){
            Write-Host "Enter a number between 1 and $($bookmarkList.count) (or 'q' to quit)" -ForegroundColor Red
        }
    }
}until($selectedNumber -eq 'q')


#####
