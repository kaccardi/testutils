#!/bin/bash

DIR="${BASH_SOURCE%/*}"

source "$DIR/ccloudvm.sh"
source "$DIR/semaphoreci.sh"

updateUbuntu
setupCcloudVM
createTestVM
sshcmd=$(getSSH)
echo $sshcmd
$sshcmd "ls -l"
