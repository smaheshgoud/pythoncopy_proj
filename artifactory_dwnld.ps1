# Retrieve the username and password from environment variables
$username = $env:ARTIFACTORY_USERNAME
$password = $env:ARTIFACTORY_PASSWORD

# Check if the environment variables are set
if (-not $username -or -not $password) {
    Write-Error "Environment variables ARTIFACTORY_USERNAME and ARTIFACTORY_PASSWORD are required."
    exit 1
}

# Define the other necessary variables
$artifactoryUrl = "https://artifactory.example.com/artifactory"
$repository = "my-repo"
$artifactPath = "path/to/my/image.tar.gz"
$destinationPath = "C:\path\to\save\image.tar.gz"

# Encode the username and password for Basic Authentication
$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("$username:$password"))
$headers = @{
    Authorization = "Basic $base64AuthInfo"
}

# Formulate the full URL to the artifact
$artifactUrl = "$artifactoryUrl/$repository/$artifactPath"

# Download the artifact
$response = Invoke-RestMethod -Uri $artifactUrl -Headers $headers -Method Get -OutFile $destinationPath

# Check if the download was successful
if ($response.StatusCode -eq 200) {
    Write-Output "Artifact downloaded successfully to $destinationPath"
} else {
    Write-Output "Failed to download artifact. Status code: $($response.StatusCode)"
}
