#!/bin/bash

set -e
CONTAINER_ID=$1
Lib_URL=$(ctx node properties lib_URL)
Lib_Path=$(ctx node properties lib_path)
Lib_name=$(ctx node properties lib_name)

set +e
  Wget=$(sudo docker exec -it ${CONTAINER_ID} which wget)
set e-

	if [[ -n "${Wget}" ]]; then
         	sudo docker exec -it ${CONTAINER_ID} apt-get update
  	        sudo docker exec -it ${CONTAINER_ID} apt-get -y install wget
        fi

sudo docker exec -it ${CONTAINER_ID} [ ! -d ${Lib_Path} ] && sudo docker exec -it ${CONTAINER_ID} mkdir ${Lib_Path}

sudo docker exec -it ${CONTAINER_ID} wget -O ${Lib_Path}/${Lib_name} ${Lib_URL}

sudo docker exec -it ${CONTAINER_ID} chmod -R 777 ${Lib_Path}/${Lib_name}

