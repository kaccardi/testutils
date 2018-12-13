#!/bin/bash

source ccloudvm.sh
source semaphoreci.sh

updateUbuntu
setupCcloudVM
createTestVM
ccloudvm status
myssh=`ccloudvm status | grep ssh`
mysshcmd=`echo $myssh | cut -d : -f 2 | sed -e 's/^[ \t]*//'`
echo "ssh string is $mysshcmd"
retval=`$mysshcmd "ls /home"`
echo "return value $?"
echo "retval is $retval"
retval=`$mysshcmd "mount"`
echo "return value $?"
echo "retval is $retval"

