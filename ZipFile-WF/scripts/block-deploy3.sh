#!/bin/bash

set -e
blueprint=$1
block=$(ctx node name)
CONTAINER_ID=$2
BLOCK_NAME=$(ctx node properties block_name)
BLOCK_URL=$3
input=$4

set +e
 Yum=$(sudo docker exec -it ${CONTAINER_ID} which yum)
set -e

ctx logger info "Deploying ${block} on ${CONTAINER_ID}"

        set +e
	  Wget=$(sudo docker exec -it ${CONTAINER_ID} which wget)
        set -e
	if [[ -z ${Wget} ]]; then
         	sudo docker exec -it ${CONTAINER_ID} apt-get update
  	        sudo docker exec -it ${CONTAINER_ID} apt-get -y install wget
        fi

 

sudo docker exec -it ${CONTAINER_ID} [ ! -d tasks ] && sudo docker exec -it ${CONTAINER_ID} mkdir tasks

sudo docker exec -it ${CONTAINER_ID} [ ! -f tasks/${BLOCK_NAME} ] && sudo docker exec -it ${CONTAINER_ID} wget -O tasks/${BLOCK_NAME} ${BLOCK_URL} 


ctx logger info "Execute the block"
sudo docker exec -it ${CONTAINER_ID} java -jar tasks/${BLOCK_NAME} ${blueprint} ${block} ${input}
