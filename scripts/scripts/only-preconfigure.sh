#!/bin/bash

set -e
sourcefile=$1
dest=$2
store=$3
CONTAINER_ID=$4

#ctx logger info "Execute the relation"
sudo docker exec -it ${CONTAINER_ID} java -jar ~/esc-block/eSc-blocks/BlockLinkRelation.jar ${sourcefile} ${dest} ${store}

