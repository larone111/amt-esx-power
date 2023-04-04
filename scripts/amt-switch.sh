#!/bin/bash

# Some characters such as + will be replaced with spaces by webhook, so choose special characters carefully. Do not use + ? &.

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
  else
    echo  "$function is an unrecognised argument"  | jq --raw-input 'split("\n") | map_values(select(.) | capture("(?<state>(.+))"))'
    exit 1
  fi

else
  echo "Insufficient parameters supplied."  | jq --raw-input 'split("\n") | map_values(select(.) | capture("(?<state>(.+))"))'
  exit 1
fi




