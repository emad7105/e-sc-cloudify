#!/bin/bash

size=0
        size2=$(stat --printf=%s ~/.TDWF/libs/jdk-7u79-linux-x64.tar.gz)
        while [[ $size != $size2 || $size2 == ]]
        do
          echo "waiting"
          sleep 1
          size=$size2
          size2=$(stat --printf=%s ~/.TDWF/libs/jdk-7u79-linux-x64.tar.gz)
        done
echo "ok"
