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
    cp testutils/ccloudvm/* ~/.ccloudvm/workloads
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
    ccloudvm setup
}

# wait for ccloudvm to return VM up status
function waitForVM {
    status=`ccloudvm status | grep VM | cut -d : -f 2 | sed -e 's/^[ \t]*//'`
    while [ "$status" = "VM down" ]; do
        sleep 5
        status=`ccloudvm status | grep VM | cut -d : -f 2 | sed -e 's/^[ \t]*//'`
        ccloudvm status
    done
    ccloudvm status
}

# assumes you've already run setup.
function createVM {
    ccloudvm create $1
    waitForVM
}

# call from within your host environment.
function createTestVM {
    createVM "kernel"
}

function getSSH {
    local sshcmd=`ccloudvm status | grep ssh | cut -d : -f 2 | sed -e 's/^[ \t]*//'`
    echo "$sshcmd"
}


function getHostIP {
    local hostip=`ccloudvm status | grep HostIP | cut -d : -f 2 | sed -e 's/^[ \t]*//'`
    echo "$hostip"
}

function getHostPort {
    local sshcmd=$(getSSH)
    local port=${sshcmd##*-p }
    echo "$port"
}

function getHostKey {
    sshcmd=$(getSSH)
    local key=`echo $sshcmd | grep -Po "(?<=(-i )).*(?= ${hostip})"`
    echo $key
}

function restartVM {
    ccloudvm stop
    ccloudvm start
    waitForVM
    return 0
}

function runCmdInVM {
    sshcmd=$(getSSH)
    $sshcmd $1
}
