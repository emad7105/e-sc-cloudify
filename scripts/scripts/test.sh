#!/bin/bash

set -e

CONTAINER_ID=test


set +e
  GIT=$(sudo docker exec -it ${CONTAINER_ID} which git)
set -e


echo ${GIT}

if [[ -z ${GIT} ]]; then

  sudo docker exec -it ${CONTAINER_ID} apt-get update
  sudo docker exec -it ${CONTAINER_ID} apt-get -y install git

else
  echo "git already has been installed"
fi

if [ $CONTAINER_ID = "test" ]; then
   echo "ok"
fi

