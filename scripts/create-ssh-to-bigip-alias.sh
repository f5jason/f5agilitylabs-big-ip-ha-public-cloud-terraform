#!/bin/bash

export Bigip1ManagementEipAddress=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=Big-IP1: BIGIP-Across-Az-Cluster-2nic-PAYG" --query "Reservations[*].Instances[*].PublicIpAddress" --output text)
export Bigip2ManagementEipAddress=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=Big-IP2: BIGIP-Across-Az-Cluster-2nic-PAYG" --query "Reservations[*].Instances[*].PublicIpAddress" --output text)
alias bigip1='ssh -i ./MyKeyPair-student@f5lab.dev.pem admin@${Bigip1ManagementEipAddress}'
alias bigip2='ssh -i ./MyKeyPair-student@f5lab.dev.pem admin@${Bigip2ManagementEipAddress}'
if [ $? -eq 0 ]
then
  echo "The script ran ok"
else
  echo "The script failed" >&2
fi

