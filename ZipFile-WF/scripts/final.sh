#!/bin/bash

set -e
#blueprint=$1

container=$1


ctx logger info "Deleting ${container}"

sudo docker rm -f ${container}

