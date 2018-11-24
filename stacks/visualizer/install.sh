#!/bin/bash

DIRNAME=`dirname "$0"`

eval $(docker-machine env manager-1)

docker stack deploy --compose-file=${DIRNAME}/visualizer.yml visualizer

docker stack services visualizer

echo "To visualize your cluster..."
echo "Open a browser to http://$(docker-machine ip manager-1):80/"
echo "Open a browser to http://manager-1.local:80/"

