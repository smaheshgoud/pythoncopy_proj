#!/bin/bash

# Replace these variables with your GitHub username, personal access token, organization name, and repository name
USERNAME="YourGitHubUsername"
TOKEN="YourPersonalAccessToken"
ORG_NAME="yourorgname"
REPO_NAME="yourrepositoryname"

# Construct the URL
URL="https://api.github.com/repos/${ORG_NAME}/${REPO_NAME}"

# Make GET request with basic authentication
RESPONSE=$(curl -u "${USERNAME}:${TOKEN}" "${URL}")

# Check if the request was successful (status code 200)
if [ "$(echo "${RESPONSE}" | jq -r '.message')" = "Not Found" ]; then
    echo "Error: Repository not found"
else
    # Print the response content (information about the repository)
    echo "${RESPONSE}"
fi
