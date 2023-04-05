#!/usr/bin/env sh

commit_msg=$(git log -1 --pretty=%B)
echo $commit_msg
feat=${commit_msg%%:*}

# current_project_version=$(git describe --abbrev=0 --tags)
current_project_version=$1
echo "current_project_version: $current_project_version"
MAJOR=$(echo $current_project_version | cut -d. -f1 | sed 's/v//')
MINOR=$(echo $current_project_version | cut -d. -f2)
PATCH=$(echo $current_project_version | cut -d. -f3)

echo "type: $MAJOR"

if [ "${commit_msg#*BREAKING CHANGE}" != "$commit_msg" ]; then
    # Aumentar versão MAJOR
    MAJOR=$((MAJOR+1))
    MINOR=0
    PATCH=0
    echo "breaking change"
elif [ "$feat" = "feat" ]; then 
    # Aumentar versão MINOR
    MINOR=$((MINOR+1))
    PATCH=0
elif [ "$feat" = "fix" ]; then
    # Aumentar versão PATCH
    PATCH=$((PATCH+1))
else
    exit 1
fi

new_project_version="$MAJOR.$MINOR.$PATCH"
echo "nova versão: $new_project_version"

git tag $new_project_version
git push origin $new_project_version