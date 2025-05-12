# Given the PR url, read the project-info.toml file, 
# open it locally with the default editor, and open the PR in the browser.
# Usage: open-pr <pr-url>
function open-pr() {

    local PROJECT_INFO_TOML="$(pwd)/project-info.toml"

    # Check if the project-info.toml file exists
    if [ ! -f "$PROJECT_INFO_TOML" ]; then
        echo "Project info toml file not found for $PROJECT_INFO_TOML"
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
    
    local EDITOR=$(yq -oy ".$project_name.default_ide" "$PROJECT_INFO_TOML")

    local cr_path=$(yq -oy ".$project_name.local_path_for_code_review" "$PROJECT_INFO_TOML")

    branch_name=$(gh pr view $pr_url --json headRefName --jq '.headRefName')
    git -C "$cr_path" checkout "$branch_name"

    # # if there is a scala in tomal file under project_name, then read in "$project_name.scala.java_version"
    # local scala_version=$(yq -oy ".$project_name.scala.java_version" "$PROJECT_INFO_TOML")
    # if [ "$scala_version" != "null" ]; then
    #     java-version "temurin-$scala_version.jdk"
    # fi

    eval "$EDITOR $cr_path"
}
