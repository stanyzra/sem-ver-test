#!/bin/bash

branch_name="$(git rev-parse --abbrev-ref HEAD)"
previous_commit_branch="$(git rev-parse --abbrev-ref HEAD^)"
# current_commit_message="$(git log -1 --pretty=%B)"
current_commit_message="feat: testing new feat"
type=$(echo $branch_name | cut -d '/' -f 1)
jira_task=$(echo $branch_name | cut -d '/' -f 2)
last_tag=$(git describe --tags --abbrev=0)
MAJOR=$(echo $last_tag | cut -d. -f1 | sed 's/v//')
MINOR=$(echo $last_tag | cut -d. -f2)
PATCH=$(echo $last_tag | cut -d. -f3 | cut -d'-' -f1)
echo $current_commit_message
echo $branch_name
echo $previous_commit_branch 
echo $type
echo $jira_task
echo $last_tag
echo $MAJOR
echo $MINOR
echo $PATCH

if [[ $last_tag == *"rc"* ]]; then
    echo "A string contém a substring 'rc'"
    release_candidate=$(echo $last_tag | cut -d'.' -f4)
    release_candidate=$(expr ${release_candidate} + 1)
    new_project_version="${MAJOR}.${MINOR}.${PATCH}-rc.${release_candidate}"
else
    echo "A string não contém a substring 'rc'"
    
    if [ "${current_commit_message#*BREAKING CHANGE}" != "$current_commit_message" ]; then
        # Aumentar versão MAJOR
        MAJOR=$((MAJOR+1))
        MINOR=0
        PATCH=0
        echo "breaking change"
    elif [ "$type" = "feat" ]; then 
        # Aumentar versão MINOR
        MINOR=$((MINOR+1))
        PATCH=0
    elif [ "$type" = "fix" ]; then
        # Aumentar versão PATCH
        PATCH=$((PATCH+1))
    else
        echo "Não é um commit válido, abortando..."
        exit 1
    fi

    new_project_version="${MAJOR}.${MINOR}.${PATCH}-rc.1"
fi 

echo "new_project_version: $new_project_version"
