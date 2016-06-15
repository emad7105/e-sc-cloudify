#!/bin/bash

set -e
create_image=$1
block=$(ctx node name)
CONTAINER_ID=$2
BLOCK_NAME=$(ctx node properties block_name)
BLOCK_URL=$3

###### get task version ######
   path=${BLOCK_URL%/*}   
   ver=$(echo ${path##*/})
###### get task name without extension ######
   var=${BLOCK_NAME%.*}
   image=${var,,}
   task="$image-$ver"

ctx logger info "Dowload ${block} on ${CONTAINER_ID}"

#-----------------------------------------#
#----------- download the task -----------#
ctx logger info "download ${block} block"

[ ! -f ~/.TDWF/$task.jar ] && wget -O ~/.TDWF/$task.jar  ${BLOCK_URL}

sudo docker exec -it ${CONTAINER_ID} [ ! -d tasks ] && sudo docker exec -it ${CONTAINER_ID} mkdir tasks

cat ~/.TDWF/$task.jar | sudo docker exec -i ${CONTAINER_ID} sh -c 'cat > tasks/'$task.jar

#----------- download the task -----------#
#-----------------------------------------#

 

########################### image creation ###########################
if [[ $create_image = "True" ]]; then

  
  ###### get base image of task container ######
   container=$(sudo docker ps -a | grep ${CONTAINER_ID})
   b=$(echo $container | cut -d ' ' -f2)                 #get base image
   base=${b//['/:']/_}


   if echo "$b" | grep -q "$task"; then
      image=${b#*/}
      ctx logger info "Task image already exist dtdwd/$image"
      
   else
      image="$base.$image-$ver"
      ctx logger info "Creating dtdwd/$image"
      sudo docker commit -m "new ${image} image" -a "rawa" ${CONTAINER_ID} dtdwd/$image
   fi
   
       ctx logger info "start local caching"
      ./Caching-Corescripts/caching-policy.sh $image > log.out 2> log.err < /dev/null 2>&1 & 
      ./Caching-Corescripts/caching-public.sh $image > /dev/null 2>&1 &    
     
fi
