#!/bin/bash

set -e
blueprint=$1
CONTAINER_NAME=$(ctx node properties container_ID)
IMAGE_NAME=$(ctx node properties image_name)
BLOCK_Url=$2

# Start Timestamp
STARTTIME=`date +%s.%N`
 
#-----------------------------------------#
#----------- pull the image --------------#
set +e
Image=''
# getting block info
path=${BLOCK_Url%/*}   
ver=$(echo ${path##*/})                                      #get task version
block=$(echo ${BLOCK_Url##*/})                               #get task name
name=$(echo ${block%.*})                                     #get task name without extension

base=${IMAGE_NAME//['/:']/_}

task_image="$base.$name-$ver"
ctx logger info "image is ${task_image}"
set -e

if [[ "$(docker images -q dtdwd/${task_image} 2> /dev/null)" != "" ]]; then
 ctx logger info "local task image"
 Image=dtdwd/${task_image}
else 
   ssh remote@192.168.56.103 test -f "DTDWD/${task_image}.tar.gz" && flag=1
   #ctx logger info "$flag"
   if [[  $flag = 1  ]]; then
      ctx logger info "cached task image"
      set +e           
          scp -P 22 remote@192.168.56.103:DTDWD/${task_image}.tar.gz ${task_image}.tar.gz
          zcat --fast ${task_image}.tar.gz | docker load
          rm ${task_image}.tar.gz
      set -e    
      Image=dtdwd/${task_image}
  else
      dock=$(sudo docker search dtdwd/${task_image})     #task image from public hub
      set +e
        found=`echo $dock | grep -c dtdwd/${task_image}`                   
      set -e
      if [[ $found = 1 ]]; then
         ctx logger info "task image from public hub"
         sudo docker pull dtdwd/${task_image} &>/dev/null
         Image=dtdwd/${task_image}
      else
          if [[ "$(docker images -q ${IMAGE_NAME} 2> /dev/null)" != "" ]]; then
             sudo docker pull ${IMAGE_NAME}
             Image=${IMAGE_NAME}
          else
              b=$(basename $IMAGE_NAME)
              if ssh remote@192.168.56.103 stat DTDWD/$b.tar.gz \> /dev/null 2\>\&1    #cached specified image
              then
                set +e
                  #echo "from local repo."
                  scp -P 22 remote@192.168.56.103:DTDWD/$b.tar.gz $b.tar.gz
                  zcat --fast $b.tar.gz | docker load
                  Image=${IMAGE_NAME}
                  rm $b.tar.gz
                set -e
              else
                set +e
                 found=`echo $dock | grep -c ${IMAGE_NAME}`
                set -e
                if [[ $found = 1 ]]; then
                  ctx logger info "specified image from public hub"
                  sudo docker pull ${IMAGE_NAME} &>/dev/null
                  Image=${IMAGE_NAME} 
                else
                 #default image
                 sudo docker pull ubuntu:14.04 &>/dev/null
                 Image=ubuntu:14.04
                fi
             fi
          fi
      fi
  fi
fi
#----------- pull the image --------------#
#-----------------------------------------#

# End timestamp
ENDTIME=`date +%s.%N`

# Convert nanoseconds to milliseconds crudely by taking first 3 decimal places
TIMEDIFF=`echo "$ENDTIME - $STARTTIME" | bc | awk -F"." '{print $1"."substr($2,1,3)}'`
echo "downloading ${Image} image : $TIMEDIFF" | sed 's/[ \t]/, /g' >> ~/list.csv
#------------------------------------------------------------------------------------------------------#
# Start Timestamp
STARTTIME=`date +%s.%N`

#-----------------------------------------#
#---------- creat the container ----------#

sudo docker run -P --name ${CONTAINER_NAME} -v ~/${blueprint}:/root/${blueprint} -it -d ${Image} bin/bash

#---------- creat the container ----------#
#-----------------------------------------#

# End timestamp
ENDTIME=`date +%s.%N`

# Convert nanoseconds to milliseconds crudely by taking first 3 decimal places
TIMEDIFF=`echo "$ENDTIME - $STARTTIME" | bc | awk -F"." '{print $1"."substr($2,1,3)}'`
echo "Creating container ${CONTAINER_NAME} : $TIMEDIFF" | sed 's/[ \t]/, /g' >> ~/list.csv
