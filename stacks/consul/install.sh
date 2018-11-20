#!/bin/bash

eval $(docker-machine env node-1)

# create overlay
docker network create --driver overlay --subnet=10.0.9.0/24 proxy

# deploy consul
docker stack deploy -c ./consul.yml consul

docker stack services consul

