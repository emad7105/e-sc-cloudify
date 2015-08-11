#!/bin/bash

set -e
container=$1


ctx logger info "Deleting ${container}"

sudo docker rm -f ${container}


