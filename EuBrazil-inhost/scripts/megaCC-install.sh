#!/bin/bash

set -e

CONTAINER_NAME=$1
Lib_URL=$2
#LIBRARY_NAME=$(ctx node properties lib_name)

#ctx logger info "Installing MegaCC lib on ${CONTAINER_NAME}"

set +e
  Git=$(sudo docker exec -it ${CONTAINER_NAME} which git)
set -e

if [[ -z ${Git} ]]; then      
        
  sudo docker exec -it ${CONTAINER_NAME} apt-get update
  sudo docker exec -it ${CONTAINER_NAME} apt-get -y install git

fi

sudo docker exec -it ${CONTAINER_NAME} git clone ${Lib_URL}

