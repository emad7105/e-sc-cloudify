#!/bin/bash

set -e
input=$1
Name=$2
CONTAINER_ID=$3
#BLOCK_NAME=$(ctx node properties block_name)

#for %%F in ("%input%") do Name=%%~nxF


#ctx logger info "Get input file"

cp ${input} $(pwd)/${Name}

sudo docker exec -it ${CONTAINER_ID} mkdir /root/input

tar -cf -  ${Name} | docker exec -i ${CONTAINER_ID} /bin/tar -C /root/input -xf -
