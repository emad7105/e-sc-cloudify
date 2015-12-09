#!/bin/bash

set -e
dest=$2
file=$1
target=$3

sourcefile=${HOME}/input/${file}

scp ${sourcefile} ${target}:${dest}



