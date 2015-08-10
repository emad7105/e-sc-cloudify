#!/bin/bash

set -e
blueprint=$1
block=$2
CONTAINER_ID=$3
output=out1.csv
#$(ctx node properties FileName)


#ctx logger info "save the output"

if [ ! -d ~/${blueprint} ]; then
   mkdir ~/${blueprint}
fi

sudo docker cp ${CONTAINER_ID}:/root/${blueprint}/${block}/${output} ~/${blueprint}
