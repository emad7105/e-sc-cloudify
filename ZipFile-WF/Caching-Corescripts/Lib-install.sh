#!/bin/bash

set -e

CONTAINER_NAME=$1
Lib_URL=$2
Lib_name=$(ctx node properties lib_name)
Lib_path=$(ctx node properties lib_path)

sudo docker exec -it ${CONTAINER_NAME} test -f $Lib_path/$Lib_name || test -f $Lib_name && exit 0
        set +e
	  Wget=$(sudo docker exec -it ${CONTAINER_NAME} which wget)
        set -e
	if [[ -z ${Wget} ]]; then
         	sudo docker exec -it ${CONTAINER_NAME} apt-get update
  	        sudo docker exec -it ${CONTAINER_NAME} apt-get -y install Wget
        fi

sudo docker exec -it ${CONTAINER_NAME} test -d $Lib_path && sudo docker exec -it ${CONTAINER_NAME} rm -rf $Lib_path

file_name=$(basename "$Lib_URL")
sudo docker exec -it ${CONTAINER_NAME} test ! -f $file_name && sudo docker exec -it ${CONTAINER_NAME} wget ${Lib_URL}

tar="tar.gz"
set +e
sudo docker exec -it ${CONTAINER_NAME} test "${file_name#*$tar}" != "$file_name" && sudo docker exec -it ${CONTAINER_NAME} tar -zxvf $file_name

sudo docker exec -it ${CONTAINER_NAME} chmod -R 777 $Lib_path/$Lib_name
set -e

