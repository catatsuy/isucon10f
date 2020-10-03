#!/bin/bash

set -x

echo "start deploy ${USER}"
GOOS=linux go build -o bin/xsuportal ./cmd/xsuportal
for server in isu01 isu02 isu03; do
  ssh -t $server "sudo systemctl stop xsuportal-web-golang.service"
  scp bin/xsuportal $server:/home/isucon/webapp/golang/bin/
  # rsync -vau ../sql/ $server:/home/isucon/isucari/webapp/sql/
  ssh -t $server "sudo systemctl start xsuportal-web-golang.service"
done

echo "finish deploy ${USER}"
