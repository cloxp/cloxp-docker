#!/bin/bash

port=${1-10080}
container_name="cloxp/cloxp"

echo -e "Starting cloxp container on port $port"

docker run \
    -p $port:10080 \
    -t $container_name \
    /bin/bash -c "forever bin/lk-server.js -p 10080 --host 0.0.0.0 --db-config '{\"enableRewriting\":false}'"
