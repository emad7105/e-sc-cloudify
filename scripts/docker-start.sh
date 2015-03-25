#!/bin/bash

set -e

CONTAINER_ID=$(ctx node properties container_ID)
IMAGE_NAME=$(ctx node properties image_name)
BLOCK_NAME=$(ctx node properties block_name)

ctx logger info "Creating ${CONTAINER_ID}"

sudo docker run --name ${CONTAINER_ID} -it -d ${IMAGE_NAME} java -jar eSc-blocks/${BLOCK_NAME}

