#!/bin/bash

eval $(docker-machine env node-1)

docker stack deploy --compose-file=./dockercloud-hello-world.yml dc-helloworld

docker stack services dc-helloworld

echo "To see dc-helloworld in your cluster..."
echo "Open a browser to http://swarm.local:81/"

