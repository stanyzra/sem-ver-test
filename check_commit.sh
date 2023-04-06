#!/bin/bash

# Obtém a tag da versão mais recente
latest_tag=$(git describe --tags --abbrev=0)

# Obtém a tag da versão anterior
previous_tag=$(git describe --tags --abbrev=0 ${latest_tag}^)

# Verifica se há um commit com o prefixo "feat" na mensagem
echo $(git log ${previous_tag}..${latest_tag} --grep='^feat')
if git log ${previous_tag}..${latest_tag} --grep='^feat' >/dev/null; then
    # Incrementa o número do RC
    rc_number=$(echo ${latest_tag} | cut -d'-' -f2)
    rc_number=$(expr ${rc_number} + 1)

    # Cria uma nova tag de versão
    new_tag=$(echo ${latest_tag} | sed "s/-rc${rc_number-1}/-rc${rc_number}/")
    git tag ${new_tag}

    echo "Nova tag criada: ${new_tag}"
else
    echo "Não há novas funcionalidades adicionadas desde a última tag de versão."
fi