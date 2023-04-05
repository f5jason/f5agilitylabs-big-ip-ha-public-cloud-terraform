#!/bin/bash

cp ~/f5lab/postman/f5lab_postman_environment.json /mnt/c/Users/user/Desktop/
cp ~/f5lab/postman/f5lab_postman_collection.json /mnt/c/Users/user/Desktop/

if [ $? -eq 0 ]
then
  echo "The script ran ok"
else
  echo "The script failed" >&2
fi
