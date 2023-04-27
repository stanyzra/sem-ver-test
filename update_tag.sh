#!/usr/bin/env sh

get_commit_message() {
    local commit_msg=$(git log -1 --pretty=%B $1) # $1 is the commit hash
    echo "$commit_msg"
}

while getopts ":t:b:" opt; do
  case ${opt} in
    t ) current_project_version="$OPTARG"
    ;;
    b ) branch="$OPTARG"
    ;;
    \? ) echo "Opção inválida: -$OPTARG" 1>&2
    ;;
    : ) echo "A opção -$OPTARG requer um argumento." 1>&2
    ;;
  esac
done

current_commit_message="$(get_commit_message HEAD)"
# echo $current_commit_message
current_type=${current_commit_message%%:*}

previous_commit_message="$(get_commit_message HEAD^^)"
# echo $previous_commit_message
previous_type=${previous_commit_message%%:*}

# current_project_version=$(git describe --abbrev=0 --tags)
current_project_version="1.3.0-rc.3"
echo "current_project_version: $current_project_version"
MAJOR=$(echo $current_project_version | cut -d. -f1 | sed 's/v//')
MINOR=$(echo $current_project_version | cut -d. -f2)
PATCH=$(echo $current_project_version | cut -d. -f3)

echo "current_type: $current_commit_message"
echo "previous_type: $previous_commit_message"

if [ "$branch" = "development" ]; then
    echo "mudar a versão e adicionar rc"
    if [ "${current_project_version#*rc}" != "$current_project_version" ] && [ "${current_type}" = "${previous_type}" ]; then
        # Aumentar versão RC
        rc_num=$(echo $current_project_version | cut -d'.' -f4)
        echo "Já é um RC"
        echo "rc_num: $rc_num"
        rc_num=$(expr ${rc_num} + 1)
        new_tag=$(echo ${current_project_version} | sed "s/-rc.$((rc_num - 1))/-rc.${rc_num}/")
    else
        if [ "${current_commit_message#*BREAKING CHANGE}" != "$current_commit_message" ]; then
            # Aumentar versão MAJOR
            MAJOR=$((MAJOR+1))
            MINOR=0
            PATCH=0
            echo "breaking change"
        elif [ "$current_type" = "feat" ]; then 
            # Aumentar versão MINOR
            MINOR=$((MINOR+1))
            PATCH=0
        elif [ "$current_type" = "fix" ]; then
            # Aumentar versão PATCH
            PATCH=$((PATCH+1))
        else
            exit 1
        fi
        new_project_version="${MAJOR}.${MINOR}.${PATCH}"
        new_tag="${new_project_version}-rc.1"
    fi
    
elif [ "$branch" = "main" ]; then
    echo "pegar a tag mais recente e remover o rc"
    if [ "${current_project_version#*rc}" != "$current_project_version" ]; then
        # Remover versão RC
        new_tag=$(echo ${current_project_version} | sed "s/-rc.*//")
    else
        exit 1
    fi
fi

echo "new_tag: $new_tag"
# git tag $new_project_version
# git push origin $new_project_version