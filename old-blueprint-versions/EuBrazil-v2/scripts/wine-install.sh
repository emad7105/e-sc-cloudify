#!/bin/bash

set -e

CONTAINER_ID=$1
LIBRARY_NAME=$(ctx node properties lib_name)

#ctx logger info "Installing wine on"

set +e
  wine=$(sudo docker exec -it ${CONTAINER_ID} which wine)
set -e

if [[ -z ${wine} ]]; then      
        
 sudo docker exec -it ${CONTAINER_ID} apt-get update
 sudo docker exec -it ${CONTAINER_ID} apt-get -y install ${LIBRARY_NAME}

fi
