
#!/bin/sh
# Start Timestamp
STARTTIME=`date +%s.%N`

# Commands here (eg: TCP connect test or something useful)
cfy local execute -w install

# End timestamp
ENDTIME=`date +%s.%N`

# Convert nanoseconds to milliseconds
# crudely by taking first 3 decimal places
TIMEDIFF=`echo "$ENDTIME - $STARTTIME" | bc | awk -F"." '{print $1"."substr($2,1,3)}'`
echo "Time diff is: $TIMEDIFF"
