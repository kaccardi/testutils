#!/bin/bash

function updateUbuntu {
    sudo apt-get -y update
    sudo apt-get install -y git flex build-essential fakeroot libncurses5-dev libssl-dev ccache libelf-dev bc python3-pip qemu-kvm qemu libburn4 libisoburn1 libisofs6 libjte1 xorriso systemd-services --fix-missing
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
    pushd $(go env GOPATH)/src/github.com/intel
    mv ccloudvm ccloudvm.orig
    echo "getting ccloudvm fork..."
    go get github.com/kaccardi/ccloudvm/...
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
    status=`ccloudvm status | grep VM | cut -d : -f 2`
    echo "status is $status"
    while [[ $status == "VM down" ]]; do
        sleep 5
        status=`ccloudvm status | grep VM | cut -d : -f 2`
        echo "status is $status"
    done
}

updateUbuntu
setupCcloudVM
createTestVM
myssh=`ccloudvm status | grep ssh`
mysshcmd=`echo $myssh | cut -d : -f 2`
$mysshcmd "mount"

