#!/bin/bash

set -e
# install JAVA 
function info(){ builtin echo [INFO] [$(basename $0)] $@; }
function error(){ builtin echo [ERROR] [$(basename $0)] $@; }


info "checking JAVA availabilty"


java_CMD=$(java -version)


#info "Downloading application sources to ${BASE_DIR}"
    if [[ ! -z $java_CMD ]]; then
       sudo apt-get install default-jdk   
    else
        info "java already exits"
        exit 1;
     fi

info "Finished installing application java"
