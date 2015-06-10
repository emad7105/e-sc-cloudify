#!/bin/bash

set -e

CONTAINER_NAME=$(ctx node properties container_ID)
LIBRARY_NAME=$(ctx node properties lib_name)

ctx logger info "Installing java on ${CONTAINER_NAME}"

set +e
  java=$(sudo docker exec -it ${CONTAINER_NAME} which java)
set -e

if [[ -z ${java} ]]; then      
        
sudo docker exec -it ${CONTAINER_NAME} apt-get update
sudo docker exec -it ${CONTAINER_NAME} apt-get -y install ${LIBRARY_NAME}

else
  ctx logger info "Java already has been installed"
fi
