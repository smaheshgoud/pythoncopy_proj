# PowerShell script to clone Bitbucket repositories from a list

# Variables
$repoFile = "C:\path\to\repos.txt"  # Path to the file containing repo names (e.g., repos.txt)
$destinationFolder = "C:\path\to\clone\repos"  # Local directory where repos will be cloned

# Ensure Git is installed
$gitVersion = git --version
if (!$gitVersion) {
    Write-Host "Git is not installed. Please install Git and try again."
    exit 1
}

# Check if the destination folder exists, if not, create it
if (-Not (Test-Path $destinationFolder)) {
    Write-Host "Creating destination folder: $destinationFolder"
    New-Item -ItemType Directory -Path $destinationFolder
}

# Read the repository list from the file
if (-Not (Test-Path $repoFile)) {
    Write-Host "The file $repoFile does not exist. Please provide a valid file."
    exit 1
}

$repos = Get-Content -Path $repoFile

# Clone each repository from the list
foreach ($repo in $repos) {
    # Trim any whitespace
    $repo = $repo.Trim()

    if ($repo -ne "") {
        $repoName = $repo.Split("/")[-1]  # Get the repo name part
        $clonePath = "$destinationFolder\$repoName"

        if (-Not (Test-Path $clonePath)) {
            # Construct the SSH clone URL
            $cloneUrl = "git@bitbucket.org:$repo.git"

            Write-Host "Cloning repository: $repo"
            try {
                git clone $cloneUrl $clonePath
                Write-Host "Repository '$repo' cloned successfully to $clonePath."
            } catch {
                Write-Host "An error occurred while cloning '$repo': $_"
            }
        } else {
            Write-Host "Repository '$repoName' already exists at $clonePath. Skipping..."
        }
    }
}
