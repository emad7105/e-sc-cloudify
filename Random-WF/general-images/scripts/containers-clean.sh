#!/bin/bash

set -e
container1=$1

container2=$2
	
#ctx logger info "Deleting ${container}"

a=${@}

for var in "$@"
do
  sudo docker rm -f "${var}"
done
#if [ -n "${container1}" ]; then
 #  sudo docker rm -f ${container1}
#fi

#if [ -n "${container2}" ]; then
# sudo docker rm -f ${container2}
#fi

