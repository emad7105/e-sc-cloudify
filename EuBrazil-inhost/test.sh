#!/bin/bash

for index in 2 3 4 5 6 .. 10
do
   # Start Timestamp
   STARTTIME=`date +%s.%N`
  cfy local execute -w install
 # End timestamp
ENDTIME=`date +%s.%N`

# Convert nanoseconds to milliseconds
# crudely by taking first 3 decimal places
TIMEDIFF=`echo "$ENDTIME - $STARTTIME" | bc | awk -F"." '{print $1"."substr($2,1,3)}'`
echo "full execution time : $TIMEDIFF" | sed 's/[ \t]/, /g' >> ~/list.csv

cp ~/list.csv ~/javacache$index.csv
rm -f ~/list.csv
. ~/Mywork/cleaning.sh
rm -f ~/.TDWF/libs/jdk-7u79-linux-x64.tar.gz
echo "$index round"
done
