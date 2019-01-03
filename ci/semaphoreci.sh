#!/bin/bash
#
# scripts related to the semaphoreci test structure.
#

function updateUbuntu {
    sudo apt-get -y update
    sudo apt-get install -y git flex bison build-essential fakeroot libncurses5-dev libssl-dev ccache libelf-dev bc python3-pip qemu-kvm qemu libburn4 libisoburn1 libisofs6 libjte1 xorriso systemd-services rpm --fix-missing
    sudo apt-get autoremove -y
    sudo apt-get clean -y
}
