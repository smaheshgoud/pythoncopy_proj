param (
    [string]$JsonFilePath,
    [string]$ParentKey = "",
    [string]$NewKey,
    [string]$NewValue,
    [string]$ListMatchKey = "",
    [string]$ListMatchValue = ""
)

# Load JSON
$json = Get-Content -Raw -Path $JsonFilePath | ConvertFrom-Json

# Convert value type (auto-detect number/bool)
if ($NewValue -match '^\d+$') {
    $typedValue = [int]$NewValue
} elseif ($NewValue -match '^(true|false)$') {
    $typedValue = [bool]::Parse($NewValue)
} else {
    $typedValue = $NewValue
}

# Function: Add or Update Key in Object
function Set-Key {
    param ($target, $key, $value)
    if ($target.PSObject.Properties.Name -contains $key) {
        $target.$key = $value
    } else {
        $target | Add-Member -NotePropertyName $key -NotePropertyValue $value
    }
}

if ($ListMatchKey -and $ListMatchValue) {
    # Pattern 3: Inside list of dictionaries (e.g., listeners)
    $found = $false
    foreach ($item in $json.$ParentKey) {
        if ($item.$ListMatchKey -eq $ListMatchValue) {
            Set-Key -target $item -key $NewKey -value $typedValue
            $found = $true
            break
        }
    }
    if (-not $found) {
        Write-Output "No matching dictionary found in array for key=$ListMatchKey and value=$ListMatchValue"
    }

} elseif ($ParentKey) {
    # Pattern 1 & 2: Nested structure
    Set-Key -target $json.$ParentKey -key $NewKey -value $typedValue
} else {
    # Top-level key
    Set-Key -target $json -key $NewKey -value $typedValue
}

# Write JSON back
$json | ConvertTo-Json -Depth 20 | Set-Content -Path $JsonFilePath -Encoding UTF8
Write-Output "Updated $NewKey successfully."
