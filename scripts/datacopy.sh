#!/bin/bash

set -e
sourcefile=$1
dest=$2
blueprint=$3
container=$4

#sudo docker cp container1:/FileZip-WF/ImportFile1.jar ~/work

#cp ~/work/ImportFile1.jar .

#tar -cf -  ImportFile1.jar | docker exec -i container2 /bin/tar -C /root -xf –


##############################################################################
############ copy intermediate results through host using command line only###
sourceDir=$(dirname "$sourcefile")
filename=$(basename "$sourcefile")
destDir=$(dirname "$dest")
sudo docker exec -it ${container} [ ! -d /root/${blueprint}/${destDir} ] && sudo docker exec -it ${container} mkdir /root/${blueprint}/${destDir}
sudo chmod -R 777 ~/${blueprint}
sudo chmod 777 ~/${blueprint}/${sourcefile}.ser

cp ~/${blueprint}/${sourcefile}.ser ~/${blueprint}/${dest}.ser
#sudo docker exec -it ${container} [ ! -d /root/${blueprint} ] && sudo docker exec -it ${container} mkdir /root/${blueprint}

#sudo docker exec -it ${container} [ ! -d /root/${blueprint}/${destDir} ] && sudo docker exec -it ${container} mkdir /root/${blueprint}/${destDir}
#echo "$filename"
#cp ~/${blueprint}/${sourcefile}.ser .
#echo /root/${blueprint}/${destDir}/$(basename "$dest").ser
#tar -cf ${filename}.ser | docker exec -i ${container} tar x -C /root/${blueprint}/${destDir}
