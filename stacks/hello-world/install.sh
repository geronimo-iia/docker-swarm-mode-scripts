#!/bin/bash
DIRNAME=`dirname "$0"`

eval $(docker-machine env manager-1)

docker stack deploy --compose-file=${DIRNAME}/hello-world.yml helloworld

docker stack services helloworld

echo "To see dc-helloworld in your cluster..."
echo "Open a browser to http://swarm.local:81/"

