# Set the folder path
$folderPath = "D:/sqlfiles"

# Get today's date and tomorrow's date in 'yyyy-MM-dd' format
$today = Get-Date -Format 'yyyy-MM-dd'
$tomorrow = (Get-Date).AddDays(1).ToString('yyyy-MM-dd')

# Check if a folder with today's date exists
$todayFolder = Join-Path -Path $folderPath -ChildPath $today
$tomorrowFolder = Join-Path -Path $folderPath -ChildPath $tomorrow

if (Test-Path -Path $todayFolder) {
    Write-Output "Folder with today's date ($today) already exists."
} elseif (Test-Path -Path $tomorrowFolder) {
    # Rename tomorrow's date folder to today's date
    Rename-Item -Path $tomorrowFolder -NewName $today
    Write-Output "Renamed folder from $tomorrow to $today."
} else {
    Write-Output "No folder with today's date ($today) or tomorrow's date ($tomorrow) found."
}
