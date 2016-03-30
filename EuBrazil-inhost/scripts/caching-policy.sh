#!/bin/bash
task=$1
set -e


#sudo nohup ./Mywork/image_upload.sh dtdwd/$task &
#disown

if ! ssh remote@192.168.56.102 stat DTDWD/$task.tar.gz \> /dev/null 2\>\&1   #check if it isn't exist in cache
            then
             if [[ ! -f $task.tar.gz ]]; then
                 sudo docker save dtdwd/$task | gzip > $task.tar.gz         #compress the image
              fi
	      Image_size=$(stat -c %s $task.tar.gz)                #get tar file size
              echo "Size of new image is $Image_size"

              size=$(ssh remote@192.168.56.102 du -s DTDWD)         #get cache folder size (image repo.)
	      array=( $size )
              cache=$(echo $size | awk -F' ' '{print $1}')
      	      echo "Cache Size is $cache"

              let total=$cache+$Image_size/1000                     #sum of cache and image size
              echo "total is $total"

	      while [ $total -ge 3000000 ]; do                      #check if the sum exceed max cache size

		   #Get the least used Image from cache
		   Least_used=$(ssh remote@192.168.56.192 find DTDWD -type f -printf "%T@ %p\n" | sort -n -r | cut -d' ' -f 2 | tail -n 1)
                   image=$(basename ${Least_used} .tar.gz)        #extract image tag
		   
		   
                   dock=$(sudo docker search dtdwd/$image)        #search for the selected image in remote rep.
                   found=`echo $dock | grep -c dtdwd/$image`
                   echo "found is $found"
                   if [[ $found = 0 ]]; then
                       #untar the image file and push it to remote repo
                       ssh remote@192.168.56.102 zcat --fast DTDWD/$Least_used | ssh remote@192.168.56.102 sudo docker load                                           
                       ssh remote@192.168.56.102 sudo docker push dtdwd/$image    
                       ssh remote@192.168.56.102 sudo docker rmi dtdwd/$image
                   fi
                   ssh remote@192.168.56.102 rm -f DTDWD/$Least_used    #delete the largest image
		   size=$(ssh remote@192.168.56.102 du -s DTDWD)
		   array=($size)
		   cache=$(echo $size | awk -F' ' '{print $1}')
		   echo "Cache Size is $cache"
                   let total=$cache+$Image_size/1000
		done
       scp  $task.tar.gz remote@192.168.56.102:DTDWD/$task.tar.gz       #copy the new image to cache  
               rm -f $task.tar.gz
fi


