#!/bin/bash
openssl ecparam -out example01a.tmp.key -name prime256v1 -genkey
openssl req -new -days 1 -nodes -x509 \
    -subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=bigip1.f5lab.dev" \
    -key example01a.tmp.key -out example01a.tmp.cert
openssl ecparam -out example01b.tmp.key -name prime256v1 -genkey
openssl req -new -days 1 -nodes -x509 \
    -subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=bigip1.f5lab.dev" \
    -key example01b.tmp.key -out example01b.tmp.cert

sed -e ':a;N;$!ba; s/-\n/-\\n/g; s/\n//g; s/-----E/\\n\-----E/g' example01a.tmp.cert > example01a.f5lab.dev.cert
sed -e ':a;N;$!ba; s/-\n/-\\n/g; s/\n//g; s/-----E/\\n\-----E/g' example01a.tmp.key > example01a.f5lab.dev.key
sed -e ':a;N;$!ba; s/-\n/-\\n/g; s/\n//g; s/-----E/\\n\-----E/g' example01b.tmp.cert > example01b.f5lab.dev.cert
sed -e ':a;N;$!ba; s/-\n/-\\n/g; s/\n//g; s/-----E/\\n\-----E/g' example01b.tmp.key > example01b.f5lab.dev.key

rm example*.tmp*
if [ $? -eq 0 ]
then
  echo "The script ran ok"
else
  echo "The script failed" >&2
fi

