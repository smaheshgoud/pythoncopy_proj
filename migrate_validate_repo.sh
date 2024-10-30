#!/bin/bash

# Function to check the size of each branch in the repository
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

# Function to check the number of branches in the repository
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
    local github_repo_url=$2

    git clone --no-checkout "$bitbucket_repo_url"
    repo_name=$(basename "$bitbucket_repo_url" .git)
    cd "$repo_name" || exit

    if check_branch_sizes "." && check_branch_count "."; then
        # Push to GitHub
        git remote add github "$github_repo_url"
        git push --all github
        git push --tags github
        echo "Repository $repo_name migrated to GitHub."
    else
        echo "Repository $repo_name does not meet the criteria. Skipping migration."
    fi

    cd ..
    rm -rf "$repo_name"
}

# Main script
repos_file="repos_list.txt"
github_base_url="https://github.com/<your_github_org>/"

while IFS= read -r bitbucket_repo_url; do
    # Create GitHub repo URL based on repo name from Bitbucket URL
    repo_name=$(basename "$bitbucket_repo_url" .git)
    github_repo_url="${github_base_url}${repo_name}.git"
    
    echo "Processing repository: $bitbucket_repo_url"
    clone_and_migrate_repo "$bitbucket_repo_url" "$github_repo_url"
done < "$repos_file"
