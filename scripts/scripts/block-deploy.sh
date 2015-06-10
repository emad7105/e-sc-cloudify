#!/bin/bash

set -e

BLOCK_URL=$(ctx node properties blockURL)
BLOCK_NAME=$(ctx node properties block_name)
CONTAINER_ID=$(ctx node properties container_ID)

set +e
  GIT=$(which git)
set -e

ctx logger info "Deploying ${BLOCk_NAME} on ${CONTAINER_ID}"

if [[ -z ${GIT} ]]; then

  sudo docker exec -it ${CONTAINER_ID} apt-get update
  sudo docker exec -it ${CONTAINER_ID} apt-get -y install git

else
  ctx logger info "git already has been installed"
fi


 sudo docker exec -it ${CONTAINER_ID} git clone ${BLOCK_URL}


ctx logger info "Execute the block"
sudo docker exec -it ${CONTAINER_ID} java -jar eSc-blocks/${BLOCK_NAME}

