#!/bin/bash

set -e

#scp ~/docker/e-sc-cloudify/scripts/test.sh remote@192.168.56.101:test.sh

#ssh remote@192.168.56.101:test.sh
 
ssh remote@192.168.56.101 'bash -s' < ~/docker/e-sc-cloudify/scripts/test.sh
