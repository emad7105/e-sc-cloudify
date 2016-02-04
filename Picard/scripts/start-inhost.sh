#!/bin/bash

set -e

blueprint=$1

#----------------------------------------------------------#
#---------------- initiate blueprint folder ---------------#
if [ ! -d ~/${blueprint} ]; then

   mkdir ~/${blueprint}
   mkdir ~/${blueprint}/tasks

fi

ctx logger info "copy ${blueprint}.yaml to ~/${blueprint}"

cp ${blueprint}.yaml ~/${blueprint}
#---------------- initiate blueprint folder ---------------#
#----------------------------------------------------------#
