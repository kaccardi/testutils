#!/bin/bash

DIR="${BASH_SOURCE%/*}"
RPMDIR="$HOME/rpmbuild/RPMS/x86_64/"
source "$DIR/ccloudvm.sh"

sshcmd=$(getSSH)
echo $sshcmd
$sshcmd "ls -l"

pushd $RPMDIR
kernel=`find . -regextype sed -regex ".*/kernel-[0-9].*"`
echo kernel to install is $kernel

hostip=$(getHostIP)
echo $hostip
port=$(getHostPort)
echo port is $port
key=$(getHostKey)
echo key is $key

scp -F /dev/null -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o IdentitiesOnly=yes -i $key -P $port $kernel $hostip:
popd

