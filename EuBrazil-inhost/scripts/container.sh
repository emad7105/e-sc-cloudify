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
if [[ "$(docker images -q dtdwd/${task_image} 2> /dev/null)" != "" ]]; then
   echo "task image dtdwd/${task_image}"   
   Image=dtdwd/${task_image}
else
  if [[ "$(docker images -q ${IMAGE_NAME} 2> /dev/null)" = "" && "$(docker images -q docker.illumina.com/${IMAGE_NAME} 2> /dev/null)" = "" ]]; then
      b=$(basename $IMAGE_NAME)
      if ssh remote@192.168.56.102 stat DTDWD/$b.tar.gz \> /dev/null 2\>\&1
            then
                    set +e
                      #echo "from local repo."
                      scp -P 22 remote@192.168.56.102:DTDWD/$b.tar.gz $b.tar.gz
                      zcat --fast nj.tar.gz | docker load
                      Image=${IMAGE_NAME}
                      rm $b.tar.gz
                    set -e
      else
                    set +e
                      echo "a repo. image docker.illumina.com/${IMAGE_NAME}"
                      sudo docker pull docker.illumina.com/${IMAGE_NAME} &>/dev/null
                      Image=docker.illumina.com/${IMAGE_NAME}
                    set -e
                    if [[ "$(docker images -q docker.illumina.com/${IMAGE_NAME} 2> /dev/null)" = "" ]]; then
                       set +e
                          echo "public repo. image"
                          sudo docker pull ${IMAGE_NAME} &>/dev/null
                       set -e
                       Image=${IMAGE_NAME}
                    fi
            
       fi
   else
       if [[ "$(docker images -q ${IMAGE_NAME} 2> /dev/null)" != "" ]]; then
          Image=${IMAGE_NAME}
       else
          Image=docker.illumina.com/${IMAGE_NAME}
       fi  
   fi
   if [[ "$(docker images -q ${IMAGE_NAME} 2> /dev/null)" = "" && ${Image} = ${IMAGE_NAME} ]]; then
      sudo docker pull rawa/nj &>/dev/null
      Image=rawa/nj
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
