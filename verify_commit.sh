#!/bin/bash

# Função para obter o hash do último commit
get_last_commit_hash() {
  git log -n 1 --format='%H'
}

# Obter o hash do último commit
last_commit_hash=$(get_last_commit_hash)

# Obter o hash do commit atual
current_commit_hash=$(git rev-parse HEAD)

# Comparar os hashes do último commit e do commit atual
if [ "$last_commit_hash" = "$current_commit_hash" ]; then
  echo "O commit atual é o último commit feito na mesma branch."
else
  echo "O commit atual foi feito em uma nova branch ou em uma branch diferente daquela em que o último commit foi feito."
fi

