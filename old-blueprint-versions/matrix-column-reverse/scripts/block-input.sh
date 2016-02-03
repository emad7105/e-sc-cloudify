#!/bin/bash

set -e
input=$1
Name=$2
CONTAINER_ID=$3
blueprint=$4

#for %%F in ("%input%") do Name=%%~nxF
sudo docker exec -it ${CONTAINER_ID} [ ! -d /root/${blueprint} ] && sudo docker exec -it ${CONTAINER_ID} mkdir /root/${blueprint}

sudo docker exec -it ${CONTAINER_ID} [ ! -f /root/${blueprint}/${blueprint}.yaml ] && tar -cf - ${blueprint}.yaml | docker exec -i ${CONTAINER_ID} /bin/tar -C /root/${blueprint} -xf -

#ctx logger info "Get input file"

cp ${input} $(pwd)/${Name}

sudo docker exec -it ${CONTAINER_ID} [ ! -d /root/input ] && sudo docker exec -it ${CONTAINER_ID} mkdir /root/input

tar -cf -  ${Name} | docker exec -i ${CONTAINER_ID} /bin/tar -C /root/input -xf -
