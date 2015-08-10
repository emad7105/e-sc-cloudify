#!/bin/bash

set -e
sourcefile=$1
dest=$2
blueprint=$3
container=$4

sudo chmod -R 0777 ~/${blueprint}
set -e
Wget=$(which wget)
set -e

ctx logger info "Transfering data"

if [[ -z ${Wget} ]]; then

  sudo apt-get update
  sudo apt-get -y install wget

else
 ctx logger info "wget already has been installed"
fi

if [ ! -f "~/${blueprint}/BlockLinkRelation1.jar" ]; then

wget https://github.com/rawaqasha/eScBlocks-host/raw/master/BlockLinkRelation1.jar -P ~/${blueprint}

fi

ctx logger info "Execute the relation"
java -jar ~/${blueprint}/BlockLinkRelation1.jar ${sourcefile} ${dest}

