#!/bin/bash

set -e
blueprint=$1
block=$(ctx node name)
CONTAINER_ID=$2
BLOCK_NAME=$(ctx node properties block_name)
BLOCK_URL=$3


sudo docker exec -it ${CONTAINER_ID} [ ! -d ${blueprint} ] && sudo docker exec -it ${CONTAINER_ID} mkdir ${blueprint}

sudo docker exec -it ${CONTAINER_ID} [ ! -f ${blueprint}/${BLOCK_NAME} ] && sudo docker exec -it ${CONTAINER_ID} wget -O ${blueprint}/${BLOCK_NAME} ${BLOCK_URL}



ctx logger info "Execute the block"
sudo docker exec -it ${CONTAINER_ID} java -jar ${blueprint}/${BLOCK_NAME} ${blueprint} ${block}


