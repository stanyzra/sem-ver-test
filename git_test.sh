#!/usr/bin/env sh

get_commit_message() {
    local commit_msg=$(git log -1 --pretty=%B $1) # $1 is the commit hash
    echo "$commit_msg"
}

current_commit_message="$(get_commit_message HEAD)"
# echo $current_commit_message
current_type=${current_commit_message%%:*}

previous_commit_message="$(get_commit_message HEAD^)"
# echo $previous_commit_message
previous_type=${previous_commit_message%%:*}

echo "current_type: $current_type"
echo "previous_type: $previous_type"

if [ "$current_type" = "feat" ] && [ "$previous_type" = "feat" ]; then
    current_tag=$(git describe --tags --abbrev=0)
    echo "current_tag: $current_tag"
    current_tag="2.3.1-rc.1"
    if [ "${current_tag#*rc}" != "$current_tag" ]; then
        rc_num=$(echo $current_tag | cut -d'.' -f4)
        echo "Já é um RC"
        echo "rc_num: $rc_num"
        rc_num=$(expr ${rc_num} + 1)
        new_tag=$(echo ${current_tag} | sed "s/-rc.$((rc_num - 1))/-rc.${rc_num}/")
        echo "new_tag: $new_tag"
    else
        echo "Não é um RC"
        new_tag="${current_tag}-rc.1"
        echo "new_tag: $new_tag"
    fi
fi

echo "${new_tag}"