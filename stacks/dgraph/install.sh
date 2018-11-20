#!/bin/bash

eval $(docker-machine env node-1)

docker stack deploy --compose-file=./dgraph.yml dgraph

docker stack services dgraph


