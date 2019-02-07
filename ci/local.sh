#!/bin/bash
#
# create a test environment for local testing
#
DIR="${BASH_SOURCE%/*}"
source "$DIR/ccloudvm.bash"
ENV="PROJECT_DIR=$HOME/linux GOROOT=/usr/local/go PATH=$PATH:$GOROOT/bin GOPATH=$HOME"

mkdir -p ~/.ccloudvm/workloads
cp $DIR/../ccloudvm/* ~/.ccloudvm/workloads
createVM "local"
sshcmd=$(getSSH)
echo $sshcmd
$sshcmd "git clone https://github.com/kaccardi/testutils"
$sshcmd "git clone -b for-testing https://github.com/kaccardi/linux"
$sshcmd "git clone https://github.com/sstephenson/bats.git"
$sshcmd "sudo bats/install.sh /usr/local"
$sshcmd "ls -l"
$sshcmd "mkdir -p ~/.ccloudvm/workloads"
$sshcmd "cp testutils/ccloudvm/* ~/.ccloudvm/workloads"
$sshcmd "$ENV ./testutils/ci/install_dependencies.sh"
$sshcmd "$ENV ./testutils/ci/build_kernel.sh"
$sshcmd "$ENV ./testutils/ci/install_kernel.sh"
$sshcmd "$ENV bats ./testutils/ci/test.bats"
