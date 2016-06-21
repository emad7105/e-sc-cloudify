#!/bin/bash

set -e
blueprint=$1
block=$(ctx node name)
CONTAINER_ID=$2
BLOCK_URL=$(ctx node properties block_Url)
BLOCK_NAME=$(ctx node properties block_name)
input=$3

###### get task version ######
   path=${BLOCK_URL%/*}   
   ver=$(echo ${path##*/})
###### get task name without extension ######
   var=${BLOCK_NAME%.*}
   image=${var,,}
   task="$image-$ver"

ctx logger info "Execute the block ${task}.jar"
sudo docker exec -it ${CONTAINER_ID} java -jar tasks/${task}.jar ${blueprint} ${block} ${input}
