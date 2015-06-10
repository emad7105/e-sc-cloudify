#!/bin/bash

set -e
# download  esc-block to specific dir 
function info(){ builtin echo [INFO] [$(basename $0)] $@; }

My_DIR='/home/rawa/rpq'
BASE_DIR=${My_DIR}
git_url="https://github.com/rawaqasha/java_block.git"


info "Making directory ${BASE_DIR}"
 
#|| exit $?
if [ ! -d ${MY_DIR} ]; then
	mkdir -p ${BASE_DIR}
else
	info "Dir already exists"
fi
#info "Changing directory ${BASE_DIR}"
cd ${My_DIR}

git_CMD=$(git --version)

    if [[ ! -z $git_CMD ]]; then
        sudo apt-get -qq install git || exit $?   
    fi

    info "cloning application from git url $git_url" 
    git clone $git_url || exit $?
     
 

info "Finished cloning application ${app_name}"


#ctx logger info "hi file import"
