param (
    [string]$JsonFilePath,
    [string]$UpdatesJson
)

# Load JSON
$json = Get-Content -Raw -Path $JsonFilePath | ConvertFrom-Json
$updates = $UpdatesJson | ConvertFrom-Json

# Function: Add or Update Key in Object
function Set-Key {
    param ($target, $key, $value)
    if ($target.PSObject.Properties.Name -contains $key) {
        $target.$key = $value
    } else {
        $target | Add-Member -NotePropertyName $key -NotePropertyValue $value
    }
}

foreach ($update in $updates) {
    $parentKey = $update.parent_key
    $listMatchKey = $update.list_match_key
    $listMatchValue = $update.list_match_value
    $updatesList = $update.updates

    if ($listMatchKey -and $listMatchValue) {
        # Update inside a list (e.g., listeners array)
        foreach ($item in $json.$parentKey) {
            if ($item.$listMatchKey -eq $listMatchValue) {
                foreach ($kv in $updatesList) {
                    $typedValue = $kv.new_value
                    # Auto-type detection
                    if ($typedValue -match '^\d+$') {
                        $typedValue = [int]$typedValue
                    } elseif ($typedValue -match '^(true|false)$') {
                        $typedValue = [bool]::Parse($typedValue)
                    }
                    Set-Key -target $item -key $kv.new_key -value $typedValue
                }
            }
        }
    } else {
        # Directly update nested or top-level object
        foreach ($kv in $updatesList) {
            $typedValue = $kv.new_value
            if ($typedValue -match '^\d+$') {
                $typedValue = [int]$typedValue
            } elseif ($typedValue -match '^(true|false)$') {
                $typedValue = [bool]::Parse($typedValue)
            }
            Set-Key -target $json.$parentKey -key $kv.new_key -value $typedValue
        }
    }
}

# Write JSON back
$json | ConvertTo-Json -Depth 20 | Set-Content -Path $JsonFilePath -Encoding UTF8
Write-Output "All updates applied successfully."
