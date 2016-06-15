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
# searching based on specified image

Image=''
task_image=$(echo ${BLOCK_NAME} | cut -f 1 -d '.')
#ctx logger info "image is $IMAGE_NAME"

if [[ "$(docker images -q dtdwd/${task_image} 2> /dev/null)" != "" ]]; then
 ctx logger info "local task image"
 Image=dtdwd/${task_image}
else 
   if [[ "$(docker images -q ${IMAGE_NAME} 2> /dev/null)" != "" ]]; then
      ctx logger info "local specified image"
      Image=${IMAGE_NAME}
   else
      Image_file=$(basename ${IMAGE_NAME})
      ssh remote@192.168.56.102 test -f "DTDWD/${Image_file}.tar.gz" && flag=1
      if [[  $flag = 1  ]]; then
           ctx logger info "cached specified image"
           set +e           
             scp -P 22 remote@192.168.56.102:DTDWD/${Image_file}.tar.gz ${Image_file}.tar.gz
             zcat --fast ${Image_file}.tar.gz | docker load
             rm ${Image_file}.tar.gz
	   set +e
           Image=${IMAGE_NAME}
      else           
           dock=$(sudo docker search ${IMAGE_NAME})
           set +e
           found=`echo $dock | grep -c ${IMAGE_NAME}`
           set -e
           if [[ $found = 1 ]]; then
              ctx logger info "specified image from public hub"
              sudo docker pull ${IMAGE_NAME} &>/dev/null
              Image=${IMAGE_NAME}
           else #looking for task image in cache and public hub
             ssh remote@192.168.56.102 test -f "DTDWD/${task_image}.tar.gz" && flag=1
             if [[  $flag = 1  ]]; then
                ctx logger info "cached task image"
                set +e           
                  scp -P 22 remote@192.168.56.102:DTDWD/${task_image}.tar.gz ${task_image}.tar.gz
                  zcat --fast ${task_image}.tar.gz | docker load
                  rm ${task_image}.tar.gz
                set -e    
                Image=dtdwd/${task_image}
             else                     
                dock=$(sudo docker search dtdwd/${task_image})
                set +e
                   found=`echo $dock | grep -c dtdwd/${task_image}`                   
                set -e
                if [[ $found = 1 ]]; then
                   ctx logger info "task image from public hub"
                   sudo docker pull dtdwd/${task_image} &>/dev/null
                   Image=dtdwd/${task_image}
                else
                   ctx logger info "default image dtdwd/nj"
                   sudo docker pull dtdwd/nj &>/dev/null 
                   Image=dtdwd/nj
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
