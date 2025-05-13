function open-pr() {

    local PROJECT_INFO_TOML
    PROJECT_INFO_TOML="$(pwd)/project-info.toml"

    # Check if the project-info.toml file exists
    if [ ! -f "$PROJECT_INFO_TOML" ]; then
        echo "Error: Project info toml file not found at $PROJECT_INFO_TOML"
        return 1
    fi

    # Check if the URL is provided
    if [ -z "$1" ]; then
        echo "Usage: open-pr <pr-url>"
        return 1
    fi

    local pr_url="$1"

    # Extract the project name from the URL
    local project_name
    project_name=$(echo "$pr_url" | sed -n 's#.*/\([^/]*\)/pull.*#\1#p')
    if [ -z "$project_name" ]; then
        echo "Error: Unable to extract project name from PR URL: $pr_url"
        return 1
    fi

    # Extract the default editor from the TOML file
    local EDITOR
    EDITOR=$(yq -oy ".$project_name.default_ide" "$PROJECT_INFO_TOML")
    if [ -z "$EDITOR" ] || [ "$EDITOR" = "null" ]; then
        echo "Error: Default editor not found for project $project_name in $PROJECT_INFO_TOML"
        return 1
    fi

    # Extract the local path for code review from the TOML file
    local cr_path
    cr_path=$(yq -oy ".$project_name.local_path_for_code_review" "$PROJECT_INFO_TOML")
    if [ -z "$cr_path" ] || [ "$cr_path" = "null" ]; then
        echo "Error: Local path for code review not found for project $project_name in $PROJECT_INFO_TOML"
        return 1
    fi

    # Check if the local path exists
    if [ ! -d "$cr_path" ]; then
        echo "Error: Local path for code review does not exist: $cr_path"
        return 1
    fi

    # Extract the branch name from the PR URL
    local branch_name
    branch_name=$(gh pr view "$pr_url" --json headRefName --jq '.headRefName')
    if [ -z "$branch_name" ]; then
        echo "Error: Unable to fetch branch name from PR URL: $pr_url"
        return 1
    fi

    # Checkout the branch
    git -C "$cr_path" checkout "$branch_name" || {
        echo "Error: Failed to checkout branch $branch_name in $cr_path"
        return 1
    }

    # Open the project in the editor
    eval "$EDITOR $cr_path" || {
        echo "Error: Failed to open project in editor $EDITOR"
        return 1
    }
}

# open-pr "https://github.com/elsevier-research/kd-recs-api/pull/208"

# function recs-gdpr() {
    
# }