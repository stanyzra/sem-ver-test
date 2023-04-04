#!/bin/bash

commit_msg="feat: a new feature"
feat=${commit_msg%%:*}

current_project_version=$(git tag)
echo "current_project_version: $current_project_version"
MAJOR=$(echo $current_project_version | cut -d. -f1)
MINOR=$(echo $current_project_version | cut -d. -f2)
PATCH=$(echo $current_project_version | cut -d. -f3)

echo "feat: $feat"

if [[ $commit_msg == *"BREAKING CHANGE"* ]]; then
    # Aumentar versão MAJOR
    MAJOR=$((MAJOR+1))
    MINOR=0
    PATCH=0
elif [ $feat = "feat" ]; then 
    # Aumentar versão MINOR
    MINOR=$((MINOR+1))
    PATCH=0
elif [ $feat = "fix" ]; then
    # Aumentar versão PATCH
    PATCH=$((PATCH+1))
else
    exit 1
fi

new_project_version="$MAJOR.$MINOR.$PATCH"
echo "nova versão: $new_project_version"