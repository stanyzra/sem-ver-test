#!/bin/bash

# Get increment number from parameter
increment=$1

# Get tag from parameter
tag=$2

# Remove previous RC increment (tag format: 1.0.0-RC.1)
tag=$(echo $tag | cut -d'-' -f1)

# Sum incrememnt + 1
increment=$(expr ${increment} + 1)

# Concatenate tag with new increment
new_tag="${tag}-RC.${increment}"

# Return new tag
echo $new_tag