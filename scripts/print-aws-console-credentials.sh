#!/bin/bash
printf "AWS Console URL:\n%s\n\n" ${TF_VAR_AWS_CONSOLE_LINK}
printf "AWS Console Username:\n%s\n\n" ${TF_VAR_AWS_USER}
printf "AWS Console Password:\n%s\n\n" ${TF_VAR_AWS_PASSWORD}

if [ $? -eq 0 ]
then
  echo "The script ran ok"
else
  echo "The script failed" >&2
fi

