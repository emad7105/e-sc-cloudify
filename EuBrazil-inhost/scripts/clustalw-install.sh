#!/bin/bash

set -e

CONTAINER_NAME=$1
Lib_URL=$(ctx node properties lib_URL)
blueprint=$2
LIBRARY_NAME=$(ctx node properties lib_name)

# Start Timestamp
STARTTIME=`date +%s.%N`

ctx logger info "Installing ClustalW lib on ${CONTAINER_NAME}"

#----------------------------------------#
#----------- download the lib -----------#
sudo docker exec -it ${CONTAINER_NAME} [ ! -f "clustalw-2.1-linux-x86_64-libcppstatic" ] && flag=0
if [[ $flag =  0 ]]; then
   if [[ ! -f ~/${blueprint}/${LIBRARY_NAME}.tar.gz ]]; then
     wget -O ~/${blueprint}/${LIBRARY_NAME}.tar.gz ${Lib_URL}
     sudo docker exec -it ${CONTAINER_NAME} tar -zxvf /root/${blueprint}/${LIBRARY_NAME}.tar.gz
   fi
fi
#---------- download the lib ------------#
#----------------------------------------#

# End timestamp
ENDTIME=`date +%s.%N`

# Convert nanoseconds to milliseconds crudely by taking first 3 decimal places
TIMEDIFF=`echo "$ENDTIME - $STARTTIME" | bc | awk -F"." '{print $1"."substr($2,1,3)}'`
echo "installing Clustalw in ${CONTAINER_NAME} $TIMEDIFF" | sed 's/[ \t]/, /g' >> ~/list.csv
