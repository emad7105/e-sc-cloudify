#!/bin/bash

set -e

docker exec -it newcontainer apt-get update
docker exec -it newcontainer apt-get -y install default-jdk
