#!/bin/bash

set -e
blueprint=$1
#block=$(ctx node name)
CONTAINER_ID=$2
sourcefile=${HOME}/input/file.jpg
#$(ctx node properties Source)



sudo docker exec -it ${CONTAINER_ID} [ ! -d ${blueprint} ] && sudo docker exec -it ${CONTAINER_ID} mkdir ${blueprint}


#ctx logger info "copy the input"

filename=$(basename "$sourcefile")
#tar -cf -  ${filename} | docker exec -i ${CONTAINER_ID} /bin/tar -C root/${blueprint} -xf –
cat ${sourcefile} | docker exec -i ${CONTAINER_ID} sh -c 'cat > /root/${blueprint}/hhh.jpg'

