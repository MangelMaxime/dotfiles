#!/bin/bash

workspaces_path=$HOME/Workspaces

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "This script is intended to be sourced, not executed directly."
    echo "Please run 'source bare-clone' or '. bare-clone' instead."
    exit 1
fi

if [ -z "$1" ]; then
  echo "Usage: $0 <repository-url>"
  exit 1
fi

getProvider () {
  case "$1" in
    *git@github.com*)
        echo "Github"
        ;;
    *)
      echo "❌ Unsupported git provider. Only Github is supported."
      exit 1
        ;;
    esac

    return $result
}

# git@github.com:whitetigle/vercel-mg-dalkia.git
getOrg () {
    repo=$(echo "$1" | cut -d':' -f2)
    username=$(echo "$repo" | cut -d'/' -f1)
    echo "$username"
}

getRepoName () {
    repo=$(echo "$1" | cut -d':' -f2)
    repo_name=$(basename "$repo" .git)
    echo "$repo_name"
}

git_provider=$(getProvider "$1")
git_org=$(getOrg "$1")
git_repo_name=$(getRepoName "$1")

destination="$workspaces_path/$git_provider/$git_org/$git_repo_name"

# Check if the repository already exists
if [ -d "$destination" ]; then
  echo "Repository already exists at $destination"
  exit 0
fi

# Ensure the destination directory exists
mkdir -p "$destination"

cd "$destination"
git clone --bare "$1"
cd "$git_repo_name.git"
