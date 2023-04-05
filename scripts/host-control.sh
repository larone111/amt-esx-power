#!/bin/bash
# Some characters such as + will be replaced with spaces by webhook, so choose special characters carefully. Do not use + ? &.

# PowerCLI will not work if no hoe directory has been exported
export HOME=/home/pi/

if [ -n "$1" ] && [ -n "$2" ]  && [ -n "$3" ] && [ -n "$4" ]; then
  function=$1
  user=$2
  password=$3
  host=$4

  if [[ $function == "status" ]]
    then
      /etc/webhook/scripts/meshcmd AmtPower --host $host --user $user --pass  $password --tls | jq --raw-input 'split("\n") | map_values(select(.) | capture("(?<state>(?<=:\\s).+|.+(?=\\.))")) '
      exit 0
  elif [[ $function == "on" ]]
    then
      /etc/webhook/scripts/meshcmd AmtPower --poweron --host $host --user $user --pass  $password --tls | jq --raw-input 'split("\n") | map_values(select(.) | capture("(?<state>(.+))"))'
      exit 0
  elif [[ $function == "reset" ]]
    then
      /etc/webhook/scripts/meshcmd AmtPower --reset --host $host --user $user --pass  $password --tls | jq --raw-input 'split("\n") | map_values(select(.) | capture("(?<state>(.+))"))'
      exit 0
  elif [[ $function == "off" ]]
    then
      /etc/webhook/scripts/meshcmd AmtPower --poweroff --host $host --user $user --pass  $password --tls | jq --raw-input 'split("\n") | map_values(select(.) | capture("(?<state>(.+))"))'
      exit 0
  elif [[ $function == "cycle" ]]
    then
      /etc/webhook/scripts/meshcmd AmtPower --powercycle --host $host --user $user --pass  $password --tls | jq --raw-input 'split("\n") | map_values(select(.) | capture("(?<state>(.+))"))'
      exit 0
  elif [[ $function == "vm-host-off" ]]
    then
      # Powershell variables need to be escaped
      /usr/bin/powershell/pwsh -Command "Import-Module VMware.VimAutomation.Core
      Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -ParticipateInCEIP \$false -Confirm:\$false
      \$esx=Connect-VIServer -Server $host -Protocol https -User $user -Password $password
      Stop-VMHost -VMHost $host -RunAsync -force -Confirm:\$false -WhatIf"
      exit 0
  else
    echo  "$function is an unrecognised argument"  | jq --raw-input 'split("\n") | map_values(select(.) | capture("(?<state>(.+))"))'
    exit 1
  fi

else
  echo "Insufficient parameters supplied."  | jq --raw-input 'split("\n") | map_values(select(.) | capture("(?<state>(.+))"))'
  exit 1
fi




