#!/bin/bash

set -e
blueprint=$1
block=$(ctx node name)
CONTAINER_ID=$2
BLOCK_NAME=$(ctx node properties block_name)
BLOCK_URL=$3


###### get task version ######
   path=${BLOCK_URL%/*}   
   ver=$(echo ${path##*/})
###### get task name without extension ######
   var=${BLOCK_NAME%.*}
   image=${var,,}
   task="$image-$ver"

ctx logger info "Dowload ${block} on ${CONTAINER_ID}"

#-----------------------------------------#
#----------- download the task -----------#
ctx logger info "download ${block} block"

[ ! -f ~/.TDWF/$task.jar ] && wget -O ~/.TDWF/$task.jar  ${BLOCK_URL}

sudo docker exec -it ${CONTAINER_ID} [ ! -d tasks ] && sudo docker exec -it ${CONTAINER_ID} mkdir tasks

cat ~/.TDWF/$task.jar | sudo docker exec -i ${CONTAINER_ID} sh -c 'cat > tasks/'$task.jar

#----------- download the task -----------#
#-----------------------------------------#

ctx logger info "after download"



