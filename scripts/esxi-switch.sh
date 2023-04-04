#!/bin/bash

export HOME=/tmp/
# Some characters such as + will be replaced with spaces by webhook, so choose special characters carefully. Do not use + ? &.

if [ -n "$1" ] && [ -n "$2" ]  && [ -n "$3" ] && [ -n "$4" ]; then
  function=$1
  user=$2
  password=$3
  host=$4

  if [[ $function == "status" ]]
    then
      exit 0
  elif [[ $function == "on" ]]
    then
      exit 0
  elif [[ $function == "off" ]]
    then
      /usr/bin/powershell/pwsh -Command "Import-Module VMware.VimAutomation.Core
      Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -ParticipateInCEIP \$false -Confirm:\$false
      \$esx=Connect-VIServer -Server $host -Protocol https -User $user -Password $password
      Stop-VMHost -VMHost $host -force -Confirm:\$false"
      exit 0
  else
    echo  "$function is an unrecognised argument"  | jq --raw-input 'split("\n") | map_values(select(.) | capture("(?<state>(.+))"))'
    exit 1
  fi

else
  echo "Insufficient parameters supplied."  | jq --raw-input 'split("\n") | map_values(select(.) | capture("(?<state>(.+))"))'
  exit 1
fi




