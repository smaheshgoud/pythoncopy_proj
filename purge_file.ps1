param(
    [string]$BackupFolder = "C:\Liquit-Backup",
    [int]$KeepLatest = 5
)

$files = Get-ChildItem -Path $BackupFolder -Filter "server-*.json" | Sort-Object LastWriteTime -Descending

if ($files.Count -gt $KeepLatest) {
    $filesToDelete = $files[$KeepLatest..($files.Count - 1)]
    foreach ($file in $filesToDelete) {
        Remove-Item $file.FullName -Force
        Write-Output "Deleted: $($file.FullName)"
    }
} else {
    Write-Output "Nothing to purge. Found only $($files.Count) files."
}
