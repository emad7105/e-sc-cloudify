#!/bin/bash

set -e
blueprint=$1
Dir=~/myDir #$(ctx node properties SourceFolder)

sourceDir=${HOME}/${blueprint}/$(basename "$Dir")


#ctx logger info "copy the Dir"


cp -r ${Dir} ${sourceDir}

