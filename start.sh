#!/bin/bash
export emailid=student@f5lab.dev
export PATH="./scripts:$PATH"
export TERM=xterm-color
chmod +x ./scripts/*
alias bigip1='ssh -i ./MyKeyPair-student@f5lab.dev.pem admin@$(terraform output --raw Bigip1ManagementEipAddress)'
alias bigip2='ssh -i ./MyKeyPair-student@f5lab.dev.pem admin@$(terraform output --raw Bigip2ManagementEipAddress)'
