#!/bin/bash
#
# create a test environment building on the host
#
DIR="${BASH_SOURCE%/*}"
source "$DIR/ccloudvm.bash"
source "$DIR/host.bash"

# build in a temp directory.
builddir=`mktemp -d`
ENV="PROJECT_DIR=$builddir/linux GOROOT=/usr/local/go PATH=$GOROOT/bin:$PATH GOPATH=$HOME/go"

mkdir -p ~/.ccloudvm/workloads
cp $DIR/../ccloudvm/* ~/.ccloudvm/workloads
updateHostOS
setupCcloudVM

pushd $builddir
git clone https://github.com/kaccardi/testutils
git clone -b for-testing https://github.com/kaccardi/linux
git clone https://github.com/sstephenson/bats.git
sudo bats/install.sh /usr/local
eval "$ENV ./testutils/ci/install_dependencies.sh"
eval "$ENV ./testutils/ci/build_kernel.sh"
eval "$ENV ./testutils/ci/install_kernel.sh"
eval "$ENV bats ./testutils/ci/test.bats"
popd

echo "Test Cycle complete, remember to delete $builddir"

