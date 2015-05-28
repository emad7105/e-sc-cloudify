#!/bin/bash

set -e

CONTAINER_ID=container2
BLOCK_URL=https://github.com/rawaqasha/eSc-blocks.git
blocks_folder='eSc-blocks'

set +e
  GIT=$(which git)
set -e



if [[ -z ${GIT} ]]; then

  sudo docker exec -it ${CONTAINER_ID} apt-get update
  sudo docker exec -it ${CONTAINER_ID} apt-get -y install git

else
  echo "git already has been installed"
fi


sudo docker exec -it ${CONTAINER_ID} [ ! -d eSc-blocks ] && sudo docker exec -it ${CONTAINER_ID} git clone ${BLOCK_URL}

#ctx logger info "Execute the relation"
#sudo docker exec -it ${CONTAINER_ID} java -jar eSc-blocks/BlockLinkRelation.jar ${sourcefile} ${dest} ${store}

