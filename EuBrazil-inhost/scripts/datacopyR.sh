#!/bin/bash

set -e
sourcefile=$1
dest=$2
blueprint=$3
VM=$4
data_Location=$5

sourceDir=$(dirname "$sourcefile")
filename=$(basename "$sourcefile")
destDir=$(dirname "$dest")
if [ ! -d ~/${blueprint}/${destDir} ]; then 
   mkdir ~/${blueprint}/${destDir}; 
fi
ssh ${VM} mkdir ${blueprint}/${destDir}; 
sudo chmod -R 777 ~/${blueprint}
sudo chmod 777 ~/${blueprint}/${sourcefile}.ser

cp ~/${blueprint}/${sourcefile}.ser ~/${blueprint}/${dest}.ser

if [ "$data_Location" = "local_data"]; then
   ssh ${VM} cp ~/${blueprint}/${sourcefile}.ser ~/${blueprint}/${dest}.ser
else
   scp ~/${blueprint}/${blueprint}.yaml ${VM}:${blueprint}/${blueprint}.yaml
   scp ~/${blueprint}/${sourcefile}.ser ${VM}:${blueprint}/${dest}.ser
fi

