#!/bin/bash

DIRNAME=`dirname "$0"`

eval $(docker-machine env manager-1)


docker stack deploy --compose-file=${DIRNAME}/dgraph.yml dgraph

docker stack services dgraph


