#!/bin/bash

set -e

CONTAINER_NAME=$(ctx node properties container_ID)
IMAGE_NAME=$(ctx node properties image_name)

ctx logger info "Creating ${CONTAINER_NAME}"

sudo docker run --name ${CONTAINER_NAME} -it -d ${IMAGE_NAME} bin/bash
