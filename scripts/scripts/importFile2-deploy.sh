#!/bin/bash

set -e
blueprint=$1
block=$2
CONTAINER_ID=$3
BLOCK_NAME=$(ctx node properties block_name)

ctx logger info "Execute the block"
sudo docker exec -it ${CONTAINER_ID} java -jar eSc-blocks/${BLOCK_NAME} ${blueprint} ${block}

