#!/bin/bash
DIRNAME=`dirname "$0"`

eval $(docker-machine env manager-1)


# create overlay
docker network create --driver overlay --subnet=10.0.9.0/24 proxy

# deploy consul
docker stack deploy -c ${DIRNAME}/consul.yml consul

docker stack services consul

