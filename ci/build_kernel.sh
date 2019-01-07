#!/bin/bash

DIR="${BASH_SOURCE%/*}"
CONFIG_DIR=$DIR/../configs

function copy_config {
    pushd $CONFIG_DIR
    cp test $PROJECT_DIR/.config
    popd
}

function build_kernel {
    pushd $PROJECT_DIR
    make olddefconfig
    make -j `getconf _NPROCESSORS_ONLN` rpm-pkg LOCALVERSION=-test
    popd
}

copy_config
build_kernel

