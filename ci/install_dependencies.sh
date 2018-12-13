#!/bin/bash

source ccloudvm.sh
source semaphoreci.sh

updateUbuntu
setupCcloudVM
createTestVM
sshcmd=$(getSSH)
echo $sshcmd
$sshcmd "ls -l"
