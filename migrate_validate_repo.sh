#!/bin/bash

# GitHub personal access token
GITHUB_TOKEN="your_github_token"
GITHUB_ORG="your_github_org"
GITHUB_API_URL="https://api.github.com"

# Function to check if a repository exists on GitHub
check_github_repo_exists() {
    local repo_name=$1
    local response
    response=$(curl -s -o /dev/null -w "%{http_code}" -H "Authorization: token $GITHUB_TOKEN" \
        "$GITHUB_API_URL/repos/$GITHUB_ORG/$repo_name")

    if [[ "$response" -eq 200 ]]; then
        return 0  # Repository exists
    else
        return 1  # Repository does not exist
    fi
}

# Function to check branch sizes in the repository
check_branch_sizes() { 
    local repo_path=$1
    local branch_size_limit="1G"

    cd "$repo_path" || exit

    for branch in $(git for-each-ref --format='%(refname:short)' refs/heads/); do
        git checkout "$branch" >/dev/null 2>&1
        branch_size=$(du -sh . | awk '{print $1}')
        
        # Check if branch size is within the specified limit
        if [[ "$branch_size" > "$branch_size_limit" ]]; then
            echo "Branch $branch exceeds the size limit ($branch_size)."
            return 1  # Indicate that size limit is not met
        fi
    done

    cd - >/dev/null
    return 0  # All branches meet the size limit
    }

# Function to check the branch count
check_branch_count() { 
    local repo_path=$1
    local branch_count_limit=100

    cd "$repo_path" || exit
    branch_count=$(git for-each-ref --format='%(refname:short)' refs/heads/ | wc -l)
    cd - >/dev/null

    if (( branch_count <= branch_count_limit )); then
        return 0  # Branch count meets the limit
    else
        echo "Branch count exceeds the limit ($branch_count branches)."
        return 1  # Branch count does not meet the limit
    fi
    }

# Function to clone and migrate repository from Bitbucket to GitHub
clone_and_migrate_repo() {
    local bitbucket_repo_url=$1
    local github_repo_name=$(basename "$bitbucket_repo_url" .git)
    
    # Check if GitHub repo already exists
    if check_github_repo_exists "$github_repo_name"; then
        echo "Repository $github_repo_name already exists on GitHub. Skipping migration."
        return
    fi

    # Clone with --mirror
    git clone --mirror "$bitbucket_repo_url"
    cd "$github_repo_name" || exit

    # Run size and branch checks
    if check_branch_sizes "." && check_branch_count "."; then
        # Create GitHub repo
        curl -s -H "Authorization: token $GITHUB_TOKEN" \
            -d "{\"name\": \"$github_repo_name\", \"private\": true}" \
            "$GITHUB_API_URL/orgs/$GITHUB_ORG/repos"

        # Push with --mirror to GitHub
        git remote add github "https://github.com/$GITHUB_ORG/$github_repo_name.git"
        git push --mirror github
        echo "Repository $github_repo_name migrated to GitHub."
    else
        echo "Repository $github_repo_name does not meet the criteria. Skipping migration."
    fi

    cd ..
    rm -rf "$github_repo_name"
}

# Main script
repos_file="repos_list.txt"

while IFS= read -r bitbucket_repo_url; do
    echo "Processing repository: $bitbucket_repo_url"
    clone_and_migrate_repo "$bitbucket_repo_url"
done < "$repos_file"
