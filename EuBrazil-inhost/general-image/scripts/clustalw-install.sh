#!/bin/bash

set -e

CONTAINER_NAME=$1
Lib_URL=$2
#LIBRARY_NAME=$(ctx node properties lib_name)

#ctx logger info "Installing ClustalW lib on ${CONTAINER_NAME}"


sudo docker exec -it ${CONTAINER_NAME} wget ${Lib_URL}
sudo docker exec -it ${CONTAINER_NAME} tar -zxvf clustalw-2.1-linux-x86_64-libcppstatic.tar.gz
