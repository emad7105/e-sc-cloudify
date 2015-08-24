#!/bin/bash

set -e
sourcefile=$1
dest=$2
store=$3
CONTAINER_ID=$4
BLOCK_URL=$5


set +e 
  Wget=$(sudo docker exec -it ${CONTAINER_ID} which wget)
set -e


ctx logger info "Transfering data to ${BLOCk_NAME} on ${CONTAINER_ID}"

if [[ -z ${Wget} ]]; then

  sudo docker exec -it ${CONTAINER_ID} apt-get update
  sudo docker exec -it ${CONTAINER_ID} apt-get -y install wget

else
 ctx logger info "wget already has been installed"
fi

#sudo docker exec -it ${CONTAINER_ID} [ ! -d ${blueprint} ] && sudo docker exec -it ${CONTAINER_ID} mkdir #${blueprint}

sudo docker exec -it ${CONTAINER_ID} [ ! -f BlockLinkRelation.jar ] && sudo docker exec -it ${CONTAINER_ID} wget ${BLOCK_URL}

ctx logger info "Execute the relation"
sudo docker exec -it ${CONTAINER_ID} java -jar BlockLinkRelation.jar ${sourcefile} ${dest} ${store}

