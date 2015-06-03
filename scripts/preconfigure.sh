#!/bin/bash

set -e
sourcefile=$1
dest=$2
store=$3
CONTAINER_ID=$4
BLOCK_URL=$5
blocks_folder='eSc-blocks'

set +e
  GIT=$(sudo docker exec -it ${CONTAINER_ID} which git)
set -e

ctx logger info "Deploying ${BLOCk_NAME} on ${CONTAINER_ID}"

if [[ -z ${GIT} ]]; then

  sudo docker exec -it ${CONTAINER_ID} apt-get update
  sudo docker exec -it ${CONTAINER_ID} apt-get -y install git

else
  ctx logger info "git already has been installed"
fi


sudo docker exec -it ${CONTAINER_ID} [ ! -d eSc-blocks ] && sudo docker exec -it ${CONTAINER_ID} git clone ${BLOCK_URL}


#ctx logger info "Execute the relation"
sudo docker exec -it ${CONTAINER_ID} java -jar eSc-blocks/BlockLinkRelation.jar ${sourcefile} ${dest} ${store}

