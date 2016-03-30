#!/bin/bash

set -e

CONTAINER_NAME=$1
Lib_URL=$2
blueprint=$3
#LIBRARY_NAME=$(ctx node properties lib_name)

# Start Timestamp
STARTTIME=`date +%s.%N`

#ctx logger info "Installing MegaCC lib on ${CONTAINER_NAME}"
#-------------------------------------------------#
#---------------- download the lib ---------------#
sudo docker exec -it ${CONTAINER_NAME} [ ! -d "work" ] && flag=0
if [[ $flag =  0 ]]; then
	#echo "not exist"
        set +e
	  git=$(which git)
        set -e
	if [[ -z ${git} ]]; then
         	sudo apt-get update
  	        sudo apt-get -y install git
        fi

        if [[ ! -d ~/${blueprint}/work ]]; then
           git clone ${Lib_URL} ~/${blueprint}/work
        fi
        sudo docker exec -it ${CONTAINER_NAME} cp -r /root/${blueprint}/work work
fi
#---------------- download the lib ---------------#
#-------------------------------------------------#


# End timestamp
ENDTIME=`date +%s.%N`

# Convert nanoseconds to milliseconds crudely by taking first 3 decimal places
TIMEDIFF=`echo "$ENDTIME - $STARTTIME" | bc | awk -F"." '{print $1"."substr($2,1,3)}'`
echo "Install Mega-cc in ${CONTAINER_NAME} $TIMEDIFF" | sed 's/[ \t]/, /g' >> ~/list.csv
