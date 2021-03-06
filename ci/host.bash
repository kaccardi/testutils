#!/bin/bash
#
# scripts related to the host build/test system.
#

function updateUbuntu {
    sudo apt-get -y update
    sudo apt-get install -y git flex bison build-essential fakeroot libncurses5-dev libssl-dev ccache libelf-dev bc python3-pip qemu-kvm qemu libburn4 libisoburn1 libisofs6 libjte1 xorriso systemd-services rpm --fix-missing
    sudo apt-get autoremove -y
    sudo apt-get clean -y
}

function getDistro {
    local distro=`lsb_release -a | grep Distributor | cut -d : -f 2 | sed -e 's/^[ \t]*//'`
    echo $distro
}

function updateHostOS {
    distro=$(getDistro)
    if [ "$distro" = "Ubuntu" ]; then
        updateUbuntu
    fi
}
