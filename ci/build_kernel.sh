#!/bin/bash

function build_kernel {
    cd $SEMAPHORE_PROJECT_DIR
    make olddefconfig
    make -j `getconf _NPROCESSORS_ONLN` bzImage LOCALVERSION=-test
    make -j `getconf _NPROCESSORS_ONLN` modules LOCALVERSION=-test
}

build_kernel

