#!/bin/bash

set -e

source ~/cloudify32/bin/activate
cd ~/docker/e-sc-cloudify/nested-wf
cfy local init --install-plugins -p FileZip-1host.yaml

cfy local execute -w install
