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
REPOSITORIES=("repo1" "repo2" "repo3")

for REPO in "${REPOSITORIES[@]}"
do
    # Clone the Bitbucket repository
    git clone --mirror https://${BITBUCKET_USERNAME}:${BITBUCKET_PASSWORD}@bitbucket.org/${BITBUCKET_ORG}/${REPO}.git

    # Change directory to the cloned repository
    cd ${REPO}.git

    # Change the remote URL to GitHub
    git remote set-url --push origin https://${GITHUB_USERNAME}:${GITHUB_TOKEN}@github.com/${GITHUB_ORG}/${REPO}.git

    # Push to GitHub
    git push --mirror

    # Return to the parent directory
    cd ..

    # Remove the cloned Bitbucket repository
    rm -rf ${REPO}.git
done
