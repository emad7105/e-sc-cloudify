#!/bin/bash

set -e
sourcefile=$1
dest=$2
store=$3

#ctx logger info "Execute the relation"
java -jar ~/esc-block/eSc-blocks/BlockLinkRelation.jar ${sourcefile} ${dest} ${store}

