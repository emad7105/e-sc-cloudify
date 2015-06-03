#!/bin/bash

set -e

blueprint=$1

if [ ! -d ~/startNfinish ]; then

   git clone https://github.com/rawaqasha/eSc-blocks.git ~/startNfinish

fi

#ctx logger info "Execute the block"
java -jar ~/startNfinish/starterBlock.jar ${blueprint}

