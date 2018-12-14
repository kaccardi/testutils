#!/bin/bash

DIR="${BASH_SOURCE%/*}"

source "$DIR/ccloudvm.sh"
source "$DIR/semaphoreci.sh"

# create some keys for the test VM
ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa

updateUbuntu
setupCcloudVM
createTestVM
sshcmd=$(getSSH)
echo $sshcmd
$sshcmd "ls -l"
