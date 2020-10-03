#!/bin/bash

set -x

echo "start deploy ${USER}"
GOOS=linux go build -o bin/xsuportal ./cmd/xsuportal
GOOS=linux go build -o bin/benchmark_server ./cmd/benchmark_server

for server in isu02; do
  rsync -vau ../sql/ $server:/home/isucon/webapp/sql/
  ssh -t $server "mysql xsuportal < /home/isucon/webapp/sql/schema.sql"
done

for server in isu01 isu02 isu03; do
  ssh -t $server "sudo systemctl stop xsuportal-web-golang.service"
  ssh -t $server "sudo systemctl stop xsuportal-api-golang.service"
  scp bin/xsuportal $server:/home/isucon/webapp/golang/bin/
  scp bin/benchmark_server $server:/home/isucon/webapp/golang/bin/
  ssh -t $server "sudo systemctl start xsuportal-web-golang.service"
  ssh -t $server "sudo systemctl start xsuportal-api-golang.service"
done

echo "finish deploy ${USER}"
