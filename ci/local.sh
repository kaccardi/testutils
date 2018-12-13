#!/bin/bash
#
# create a test environment for local testing
#
DIR="${BASH_SOURCE%/*}"
source "$DIR/ccloudvm.sh"

mkdir -p ~/.ccloudvm/workloads
cp $DIR/../ccloudvm/* ~/.ccloudvm/workloads
createVM "semaphore"
sshcmd=$(getSSH)
echo $sshcmd
$sshcmd "git clone https://github.com/kaccardi/testutils"
$sshcmd "ls -l"
$sshcmd "./testutils/ci/install_dependencies.sh"
