#!/bin/bash

function updateUbuntu {
    sudo apt-get -y update
    sudo apt-get install -y git flex bison build-essential fakeroot libncurses5-dev libssl-dev ccache libelf-dev bc python3-pip qemu-kvm qemu libburn4 libisoburn1 libisofs6 libjte1 xorriso systemd-services --fix-missing
}

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

function createTestVM {
    ccloudvm setup
    ccloudvm create kernel
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

updateUbuntu
setupCcloudVM
createTestVM
ccloudvm status
myssh=`ccloudvm status | grep ssh`
mysshcmd=`echo $myssh | cut -d : -f 2 | sed -e 's/^[ \t]*//'`
echo "ssh string is $mysshcmd"
retval=`$mysshcmd "uname -r"`
echo "return value $?"
echo "retval is $retval"

