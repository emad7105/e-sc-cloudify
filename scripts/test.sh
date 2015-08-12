#!/bin/bash

set -e
#blueprint=$1

container=$(ctx deployment id)


ctx logger info "Deleting ${container}"

#sudo docker rm -f ${container}

