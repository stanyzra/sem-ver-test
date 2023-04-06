#!/usr/bin/env sh

get_commit_message() {
    local commit_msg=$(git log -1 --pretty=%B $1) # $1 is the commit hash
    echo "$commit_msg"
}

current_commit_message="$(get_commit_message HEAD)"
echo $current_commit_message
current_feat=${current_commit_message%%:*}

previous_commit_message="$(get_commit_message HEAD^)"
echo $previous_commit_message
previous_feat=${previous_commit_message%%:*}

echo "current_feat: $current_feat"
echo "previous_feat: $previous_feat"

