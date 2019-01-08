#!/usr/bin/env bats

load "ccloudvm"

sshcmd=$(getSSH)

@test "simple boot test" {
  run restartVM
  [ "$status" -eq 0 ]
}

@test "check running kernel version" {
  pushd $PROJECT_DIR
  version=`make kernelversion`-test
  popd
  version2=$(runCmdInVM "uname -r")
  [ "$version" = "$version2" ]
}
