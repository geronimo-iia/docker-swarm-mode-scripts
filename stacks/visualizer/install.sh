#!/bin/bash

eval $(docker-machine env node-1)

docker stack deploy --compose-file=./visualizer.yml visualizer

docker stack services visualizer

echo "To visualize your cluster..."
echo "Open a browser to http://$(docker-machine ip node-1):80/"
echo "Open a browser to http://node-1.local:80/"

