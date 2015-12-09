#!/bin/bash

set -e
fold=$1
blueprint=$2
VM=$3

ssh ${VM} sudo chmod -R 777 ${blueprint}
ssh ${VM} sudo chmod 777 ${blueprint}

scp ${VM}:${blueprint}/${fold}.ser ~/${blueprint}/${fold}

