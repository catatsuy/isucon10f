#!/bin/bash

set -x

echo "start deploy ${USER}"
GOOS=linux go build -o bin/xsuportal ./cmd/xsuportal
GOOS=linux go build -o bin/benchmark_server ./cmd/benchmark_server
GOOS=linux go build -o bin/send_web_push ./cmd/send_web_push
for server in isu01 isu02 isu03; do
  ssh -t $server "sudo systemctl stop xsuportal-web-golang.service"
  ssh -t $server "sudo systemctl stop xsuportal-api-golang.service"
  scp bin/xsuportal $server:/home/isucon/webapp/golang/bin/
  scp bin/benchmark_server $server:/home/isucon/webapp/golang/bin/
  scp bin/send_web_push $server:/home/isucon/webapp/golang/bin/
  # rsync -vau ../sql/ $server:/home/isucon/isucari/webapp/sql/
  ssh -t $server "sudo systemctl start xsuportal-web-golang.service"
  ssh -t $server "sudo systemctl start xsuportal-api-golang.service"
done

echo "finish deploy ${USER}"
