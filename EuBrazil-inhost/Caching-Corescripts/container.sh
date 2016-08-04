#!/bin/bash

set -e
blueprint=$1
CONTAINER_NAME=$(ctx node properties container_ID)
IMAGE_NAME=$(ctx node properties image_name)
BLOCK_URL=$2

# Start Timestamp
STARTTIME=`date +%s.%N`
 
#-----------------------------------------#
#----------- pull the image --------------#
set +e
Image=''
###### get task ID ######
   
   source $PWD/Core-LifecycleScripts/get-task-ID.sh
   var=$(func $BLOCK_URL)
   task=${var,,}

base=${IMAGE_NAME//['/:']/-}

task_image=$base'_'$task
ctx logger info "image is ${task_image}"
set -e

if [[ "$(docker images -q dtdwd/${task_image} 2> /dev/null)" != "" ]]; then
 ctx logger info "local task image"
 Image=dtdwd/${task_image}
else 
   set +e
   connect=$(ssh -o BatchMode=yes -o ConnectTimeout=1 cache@192.168.56.103 echo ok 2>&1)
   set -e
    ctx logger info "$connect"
   if [[ $connect == "ok" ]]; then
    ssh cache@192.168.56.103 test -f "DTDWD/${task_image}.tar.gz" && flag=1

    if [[  $flag = 1  ]]; then
      ctx logger info "cached task image"
      set +e           
          # Start Timestamp
          STARTTIME=`date +%s.%N`
          scp -P 22 cache@192.168.56.103:DTDWD/${task_image}.tar.gz ${task_image}.tar.gz
          # End timestamp
          ENDTIME=`date +%s.%N`

          # Convert nanoseconds to milliseconds crudely by taking first 3 decimal places
          TIMEDIFF=`echo "$ENDTIME - $STARTTIME" | bc | awk -F"." '{print $1"."substr($2,1,3)}'`
          echo "copy image : $TIMEDIFF" | sed 's/[ \t]/, /g' >> ~/image.csv

          # Start Timestamp
          STARTTIME=`date +%s.%N`
          zcat --fast ${task_image}.tar.gz | docker load
          # End timestamp
          ENDTIME=`date +%s.%N`

          # Convert nanoseconds to milliseconds crudely by taking first 3 decimal places
          TIMEDIFF=`echo "$ENDTIME - $STARTTIME" | bc | awk -F"." '{print $1"."substr($2,1,3)}'`
          echo "unzip image : $TIMEDIFF" | sed 's/[ \t]/, /g' >> ~/image.csv

          rm ${task_image}.tar.gz
      set -e    
      Image=dtdwd/${task_image}
    fi
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
          if [[ "$(docker images -q ${IMAGE_NAME} 2> /dev/null)" != "" ]]; then   #local specified image
             sudo docker pull ${IMAGE_NAME}
             Image=${IMAGE_NAME}
          else
              b=$(basename $IMAGE_NAME)
              if ssh cache@192.168.56.103 stat DTDWD/$b.tar.gz \> /dev/null 2\>\&1    #cached specified image
              then
                set +e
                  scp -P 22 cache@192.168.56.103:DTDWD/$b.tar.gz $b.tar.gz
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
