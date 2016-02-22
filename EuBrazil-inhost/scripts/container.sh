#!/bin/bash

set -e
blueprint=$1
CONTAINER_NAME=$(ctx node properties container_ID)
IMAGE_NAME=$(ctx node properties image_name)
BLOCK_NAME=$2

# Start Timestamp
STARTTIME=`date +%s.%N`
 
#-----------------------------------------#
#----------- pull the image --------------#

Image=''
task_image=$(echo ${BLOCK_NAME} | cut -f 1 -d '.')
# Search for task image
if [[ "$(docker images -q ${task_image} 2> /dev/null)" != "" ]]; then
   ctx logger info "task image ${task_image}"   
   Image=${task_image}
else
  # Search in local repo. for an input specified image
  #ctx logger info "private repo. image"
  #set +e
   # docker pull docker.illumina.com/${IMAGE_NAME}
   # Image=docker.illumina.com/${IMAGE_NAME}
  #set -e
  
#fi
# Search in docker.hub repo. for an input specified image
#if [[ "$(docker images -q docker.illumina.com/${IMAGE_NAME} 2> /dev/null)" = "" && ${Image} != ${task_image} ]]; then
   if [[ "$(docker images -q ${IMAGE_NAME} 2> /dev/null)" = "" ]]; then
      b=$(basename $IMAGE_NAME)
      if ssh remote@192.168.56.102 stat DTDWD/$b.tar \> /dev/null 2\>\&1
            then
                    ctx logger info "from local repo."
                    scp -P 22 remote@192.168.56.102:DTDWD/$b.tar $b.tar
                    docker load -i $b.tar
                    rm $b.tar
            else
                    ctx logger info "Public repo. image"
                    docker pull ${IMAGE_NAME}
       fi
   fi
   Image=${IMAGE_NAME}
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
