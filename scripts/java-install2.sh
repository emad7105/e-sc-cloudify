#!/bin/bash

set -e


LIBRARY_NAME=$(ctx node properties lib_name)

ctx logger info "Installing java on"

set +e
  java=$(which java)
set -e

if [[ -z ${java} ]]; then      
        
sudo docker exec -it ${container_name} apt-get update
sudo docker exec -it ${container_name} apt-get -y install ${LIBRARY_NAME}

else
  ctx logger info "Java already has been installed"
fi
