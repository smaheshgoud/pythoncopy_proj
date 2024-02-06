#!/bin/bash

# Define your GitHub username and access token (replace with your actual values)
GITHUB_USER="your_username"
GITHUB_TOKEN="your_access_token"

# Read repository names from a list (one repository name per line)
REPO_LIST="repository_names.txt"

# Loop through each repository name
while read -r repo_name; do
    # Check if the repository exists
    if git ls-remote "https://github.com/$GITHUB_USER/$repo_name.git" &>/dev/null; then
        echo "Repository '$repo_name' already exists. Skipping..."
    else
        # Create a new private repository
        curl -u "$GITHUB_USER:$GITHUB_TOKEN" -X POST "https://api.github.com/user/repos" -d "{\"name\":\"$repo_name\", \"private\":true}" &>/dev/null
        echo "Created private repository '$repo_name' on GitHub."

        # Clone the Bitbucket repository
        git clone "https://bitbucket.org/USER/$repo_name.git" &>/dev/null
        cd "$repo_name" || exit 1

        # Set the remote upstream to GitHub
        git remote add upstream "https://github.com/$GITHUB_USER/$repo_name.git"
        git push upstream master
        git push --tags upstream

        echo "Migrated repository '$repo_name' from Bitbucket to GitHub."
        cd .. || exit 1
    fi
done < "$REPO_LIST"
