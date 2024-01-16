#!/bin/bash

# Bitbucket credentials
BITBUCKET_USERNAME="your_bitbucket_username"
BITBUCKET_PASSWORD="your_bitbucket_password"

# GitHub credentials
GITHUB_USERNAME="your_github_username"
GITHUB_TOKEN="your_github_token"

# Bitbucket and GitHub organization/user names
BITBUCKET_ORG="bitbucket_organization"
GITHUB_ORG="github_organization"

# Bitbucket repositories list
#REPOSITORIES=("repo1" "repo2" "repo3")

# Read repository names from a text file
REPOSITORIES_FILE="repositories.txt"
REPOSITORIES=($(cat $REPOSITORIES_FILE))

for REPO in "${REPOSITORIES[@]}"
do
    # Clone the Bitbucket repository
    git clone --mirror https://${BITBUCKET_USERNAME}:${BITBUCKET_PASSWORD}@bitbucket.org/${BITBUCKET_ORG}/${REPO}.git

    # Change directory to the cloned repository
    cd ${REPO}.git

    # Create the repository on GitHub (if it doesn't exist)
    curl -X POST -H "Authorization: token ${GITHUB_TOKEN}" -H "Accept: application/vnd.github.v3+json" "https://api.github.com/orgs/${GITHUB_ORG}/repos" -d '{"name":"'$REPO'"}'

    # Change the remote URL to GitHub
    git remote set-url --push origin https://${GITHUB_USERNAME}:${GITHUB_TOKEN}@github.com/${GITHUB_ORG}/${REPO}.git

    # Push to GitHub
    git push --mirror

    # Return to the parent directory
    cd ..

    # Remove the cloned Bitbucket repository
    rm -rf ${REPO}.git
done
