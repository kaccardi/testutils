#!/bin/bash

DIR="${BASH_SOURCE%/*}"

source "$DIR/ccloudvm.bash"
source "$DIR/host.bash"

updateHostOS
setupCcloudVM
createTestVM
