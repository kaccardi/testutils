#!/bin/bash
#
# functions that help setup ccloudvm environment for testing.
#

# needed on the host environment.
function setupGoLang {
    pushd /tmp
    wget https://dl.google.com/go/go1.11.linux-amd64.tar.gz
    sudo tar -xvf go1.11.linux-amd64.tar.gz
    sudo mv go /usr/local/
    popd
    export GOROOT=/usr/local/go
    export PATH=/usr/local/go/bin:$PATH:/bin:/usr/bin
    export PATH=$PATH:$(go env GOPATH)/bin
    export GOPATH=$HOME
}

# setup within the host environment to create the VM under test.
function setupCcloudVM {
    setupGoLang
    echo "copying workloads..."
    mkdir -p ~/.ccloudvm/workloads
    cp testutils/ccloudvm/kernel.yaml ~/.ccloudvm/workloads
    echo "getting ccloudvm source..."
    go get github.com/intel/ccloudvm/...
    go get github.com/kaccardi/ccloudvm/...
    pushd $(go env GOPATH)/src/github.com/intel
    mv ccloudvm ccloudvm.orig
    ln -s ../kaccardi/ccloudvm ccloudvm
    ls -l
    cd ccloudvm
    pwd
    git checkout origin/disable-kvm
    go install ./...
    popd
}

# wait for ccloudvm to return VM up status
function waitForVM {
    ccloudvm status
    status=`ccloudvm status | grep VM | cut -d : -f 2 | sed -e 's/^[ \t]*//'`
    echo "status is $status"
    while [ "$status" = "VM down" ]; do
        sleep 5
        status=`ccloudvm status | grep VM | cut -d : -f 2 | sed -e 's/^[ \t]*//'`
        ccloudvm status
        echo "status is $status"
    done
    ccloudvm status
    echo "status is $status"
}

# assumes you've already run setup.
function createVM {
    ccloudvm create $1
    waitForVM
}

# call from within your host environment.
function createTestVM {
    ccloudvm setup
    createVM "kernel"
}
