#!/bin/bash

set -e
blueprint=$1

set +e
  Wget=$(which wget)
set -e

if [[ -z ${Wget} ]]; then      
        
   apt-get update
  apt-get install wget

fi

if [ ! -d ~/startNfinish ]; then

   mkdir ~/startNfinish

fi

wget -O ~/startNfinish/finalBlock.jar https://github.com/rawaqasha/eSc-blocks/raw/master/finalBlock.jar
#ctx logger info "Execute the block"
java -jar ~/startNfinish/finalBlock.jar ${blueprint}

