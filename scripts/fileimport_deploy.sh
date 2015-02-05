#!/bin/bash

set -e
# download  esc-block to specific dir 
function info(){ builtin echo [INFO] [$(basename $0)] $@; }
function error(){ builtin echo [ERROR] [$(basename $0)] $@; }


#. ${CLOUDIFY_LOGGING}
#. ${CLOUDIFY_FILE_SERVER}

My_DIR="/home/rawa"
BASE_DIR=${My_DIR}/${CLOUDIFY_EXECUTION_ID}
git_url="https://github.com/rawaqasha/java_block.git"


info "Changing directory to ${BASE_DIR}"
cd ${My_DIR} || exit $?

YUM_CMD=$(which yum)
APT_GET_CMD=$(which apt-get)

info "Downloading application sources to ${BASE_DIR}"
    if [[ ! -z $YUM_CMD ]]; then
        sudo yum -y install git-core || exit $?   
    elif [[ ! -z $APT_GET_CMD ]]; then 
        sudo apt-get -qq install git || exit $?   
     else
        error "error can't install package git"
        exit 1;
     fi

    info "cloning application from git url $git_url" 
    git clone $git_url || exit $?
     
   

info "Finished installing application ${app_name}"


ctx logger info "hi file import"
