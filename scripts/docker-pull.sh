#!/bin/bash

set -e

CONTAINER_NAME=$(ctx node properties container_name)
IMAGE_NAME=$(ctx node properties image_name)

sudo docker run --name ${CONTAINER_NAME} -it -d ${IMAGE_NAME} bin/bash
