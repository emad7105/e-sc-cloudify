#!/bin/bash

set -e
container=$1

#ctx logger info "Deleting ${container}"

if [ -z "$container1"]; then

   sudo docker rm -f ${container1}

fi

if [ -z "$container2"]; then

 sudo docker rm -f ${container2}

fi
