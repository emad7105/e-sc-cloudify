#!/bin/bash

set -e

sudo docker run --name temp -it -d rawa/nj:01 bin/bash

#sudo docker exec -it temp apt-get install -y git
