#!/bin/bash

DIR="${BASH_SOURCE%/*}"
RPMDIR="$HOME/rpmbuild/RPMS/x86_64/"
SRPMDIR="$HOME/rpmbuild/SRPMS/"
source "$DIR/ccloudvm.bash"

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
pushd $SRPMDIR
kernelsrc=`find . -regextype sed -regex ".*/kernel-[0-9].*"`
scp -F /dev/null -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o IdentitiesOnly=yes -i $key -P $port $kernelsrc $hostip:
popd
runCmdInVM "sudo rpm -i $kernel --force"
runCmdInVM "sudo grub2-set-default 0"
runCmdInVM "sudo rpm -i $kernelsrc --force"
restartVM
