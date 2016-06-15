#!/bin/bash

set -e

CONTAINER_ID=$1
create_image=$2

if [[ $create_image = "True" ]]; then
   ###### get base image of workflow container ######
   container=$(sudo docker ps -a | grep ${CONTAINER_ID})
   b=$(echo $container | cut -d ' ' -f2)
   base=${b//['/:']/_}
   
   set +e   
   tag=$(git describe --exact-match --tags $(git log -n1 --pretty='%h'))
   branch=$(git rev-parse --abbrev-ref HEAD)         
   wf=${PWD##*/}    # get WF name
   if [[ -z $tag ]]; then
     image=$wf-$branch
   else 
     image=$wf-$branch:$tag
   fi 
   image=${image,,}

   if echo "$b" | grep -q "$image"; then
      image=${b#*/}
      ctx logger info "Task image already exist dtdwd/$image"
   else
      image=dtdwd/$base-$image
      sudo docker commit -m "new ${image} image" -a "rawa" ${CONTAINER_ID} $image
   fi

   ctx logger info "start local caching"
   ./Caching-Corescripts/caching-policy.sh $image > log.out 2> log.err < /dev/null 2>&1 & 
   ./Caching-Corescripts/caching-public.sh $image > /dev/null 2>&1 &
fi
