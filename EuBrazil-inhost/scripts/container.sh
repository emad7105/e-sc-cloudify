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

image=$(echo ${BLOCK_NAME} | cut -f 1 -d '.')
if [[ "$(docker images -q ${image} 2> /dev/null)" != "" ]]; then
 ctx logger info "using previous block image"
 IMAGE_NAME=${image}
else
 ctx logger info "using new image"
 sudo docker pull ${IMAGE_NAME}
fi
#----------- pull the image --------------#
#-----------------------------------------#

# End timestamp
ENDTIME=`date +%s.%N`

# Convert nanoseconds to milliseconds
# crudely by taking first 3 decimal places
TIMEDIFF=`echo "$ENDTIME - $STARTTIME" | bc | awk -F"." '{print $1"."substr($2,1,3)}'`
echo "downloading ${IMAGE_NAME} image : $TIMEDIFF" * | sed 's/[ \t]/, /g' >> ~/list.csv 

# Start Timestamp
STARTTIME=`date +%s.%N`

#-----------------------------------------#
#---------- creat the container ----------#

sudo docker run -P --name ${CONTAINER_NAME} -v ~/${blueprint}:/root/${blueprint} -it -d ${IMAGE_NAME} bin/bash

#---------- creat the container ----------#
#-----------------------------------------#

# End timestamp
ENDTIME=`date +%s.%N`

# Convert nanoseconds to milliseconds
# crudely by taking first 3 decimal places
TIMEDIFF=`echo "$ENDTIME - $STARTTIME" | bc | awk -F"." '{print $1"."substr($2,1,3)}'`
echo "creating the container $CONTAINER_NAME: $TIMEDIFF" * | sed 's/[ \t]/, /g' >> ~/list.csv 
