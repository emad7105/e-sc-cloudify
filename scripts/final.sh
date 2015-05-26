#!/bin/bash

set -e
blueprint=$1

#ctx logger info "Execute the block"
java -jar ~/jars/finalBlock.jar ${blueprint}

