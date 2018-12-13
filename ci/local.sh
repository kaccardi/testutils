#!/bin/bash
#
# create a test environment for local testing
#

source ccloudvm.sh

mkdir -p ~/.ccloudvm/workloads
cp ../ccloudvm/* ~/.ccloudvm/workloads
createVM "semaphore"
sshcmd=$(getSSH)
echo $sshcmd
$sshcmd "git clone https://github.com/kaccardi/testutils"
