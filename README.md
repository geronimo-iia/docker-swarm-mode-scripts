# docker-swarm-mode-scripts

These scripts use docker-machine from the [Docker for Mac][1] distribution to
create a docker swarm-mode cluster and clean it up when you're done.
Initial article was wrote by [Manuel Morejón][2].

You could use it on nix plateform by changing DOCKER_MACHINE_DRIVER variable.

Note:
Due to a bug in v18.06.1-ce of boot2docker, you must export this variable in order to be able to create docker-machine:

```sh
export DOCKER_MACHINE_OPTS="--xhyve-boot2docker-url https://github.com/boot2docker/boot2docker/releases/download/v18.06.1-ce/boot2docker.iso"
```
or

```sh
export XHYVE_BOOT2DOCKER_URL="https://github.com/boot2docker/boot2docker/releases/download/v18.06.1-ce/boot2docker.iso"
```


## prerequisites

You will need Docker for Mac 1.12 or 18.x CE (or better) for this to work.

You could use `./bin/install-docker` for Mac.

```sh
    brew install docker docker-compose docker-machine docker-machine-driver-xhyve docker-machine-nfs xhyve
    sudo chown root:wheel $(brew --prefix)/opt/docker-machine-driver-xhyve/bin/docker-machine-driver-xhyve
    sudo chmod u+s $(brew --prefix)/opt/docker-machine-driver-xhyve/bin/docker-machine-driver-xhyve
```

## swarm cluster management

Clone this repository and execute `./bin/swarm`.

```sh
Usage ./bin/swarm:
    --config : show cluster node configuration
    --config-save : save cluster node configuration
    --create : create docker swarm cluster
    --remove : remove docker swarm cluster
    --start : start docker swarm cluster
    --stop : stop docker swarm cluster
    --leader: print hostname of swarm manager leader
    --install_registry: install docker registry
    --help : this help
```

```sh
    ./bin/swarm --create
    ./bin/swarm --start
```

This will build 6 docker machine using xhyve (or virtualbox is you set DOCKER_MACHINE_DRIVER).
Three nodes will be created as managers and an additional three joined as workers.

You could override #nodes by using environment variable:

```sh
    export MANAGER_COUNT=1
    export WORKER_COUNT=3
    export DOCKER_MACHINE_DRIVER="xhyve"
    export XHYVE_BOOT2DOCKER_URL="..."
    export DRIVER_OPTS="..."
```

or better, into a '.swarm' file on your current path.

```sh
    ./bin/swarm  --config-save
    
    cat .swarm
    export MANAGER_COUNT=1
    export WORKER_COUNT=3
    export DOCKER_MACHINE_DRIVER="xhyve"

    ./bin/swarm --config
    
    Swarm Cluster Configuration:
        1 #manager
        3 #worker
        4 #node
    Driver Configuration:
        driver: xhyve
        boot2docker: https://github.com/boot2docker/boot2docker/releases/download/v18.06.1-ce/boot2docker.iso
        engine-opts:
    Leader:
        manager-1
    Manager:
        manager-1
    Worker:
        worker-1 worker-2 worker-3

```

## install-registry

Another useful tool is the docker registry, accessible by the cluster and your
local machine. Keys and certs are generated which are then distributed to the
cluster nodes. The registry is installed on manager-1 and accessible from your
host machine. This is very useful for building images locally and pushing them
into the cluster registry, and then deploying services from those images.

Instructions for connecting from your local machine are provided at the end of
the script. Essentially this includes adding the ca.crt to your system keystore
and making an /etc/hosts entry.

```sh
    ./bin/swarm --install_registry
```

## Stacks

Under `./stacks` you could find several starter stacks:

- consul
- visualizer
- hello-world
- dgraph

In progress:


- monitoring (plain to use prometheus, etc...)
- traefik as load balancer

The wish list:

- redis cluster
- elastic cluster
- faas
- postgresql server
- emqtt broker
- [portaire](https://github.com/portainer/portainer)
- [drone](https://github.com/drone/drone)

### consul

TODO: need to update

The [autopilot pattern][3] automates in code the repetitive and boring operational tasks of an application, including startup, shutdown, scaling, and recovery from anticipated failure conditions for reliability, ease of use, and improved productivity.

[Consul][5] is a greath tool to achieve thoses tasks. You should read [consul with the Autopilot Pattern][4] and
[autopilot Pattern with consul][6].

```sh
# create overlay
docker network create --driver overlay --subnet=10.0.9.0/24 proxy
# deploy consul
docker stack deploy -c stacks/consul/consul.yml consul
docker stack services consul
```

Or simply do `./stacks/consul/install.sh`

consul ui : http://node-1.local:8500/ui
consul api: http://node-1.local:8500/v1/

```sh
dig @$(docker-machine ip node-1) http-ip.service.consul
```

Note on service Registration/Discovery:
The normal setup is the application accessing the Consul node which is running on the same machine. 
However, with containers in the mix, the way to connect differs.
If the application is not deployed as a docker service, then you can still register the service in Consul using <node-ip>:8500 or localhost:8500 but health checks will fail.

If the deployed as a service which is most likely scenario when using Docker Swarm Mode.
Then you can use the ingress gateway to connect to Consul. The service must be attached to proxy for health checks to work correctly.

### visualizer

If you find the [Docker Swarm Visualizer][7] tool useful you can install it by
executing :

```sh
    ./stacks/visualizer/install.sh
```

This installs the visualizer to manager-1 where it can talk to the Docker socket,
learn what is running in the cluster, and dispaly it.

The visualizer runs on the manager-1 ip, instructions for browsing are printed
after execution.

### hello-world

```sh
./stacks/hello-world/install.sh
```

### dgraph

```sh
./stacks/dgraph/install.sh
```



## Links

 - https://awesome-docker.netlify.com
 - https://github.com/docker-flow/docker-flow-swarm-listener
 - https://github.com/rancher/convoy
 - https://github.com/minio/minio
 - https://github.com/jeroenpeeters/docker-ssh
 - https://github.com/atcol/docker-registry-ui
 - https://github.com/instacart/ahab


[1]: https://docs.docker.com/docker-for-mac/
[2]: http://mmorejon.github.io/en/blog/docker-swarm-with-docker-machine-scripts/
[3]: http://autopilotpattern.io/
[4]: https://bhavik.io/2017/12/19/consul-with-docker-swarm-mode.html
[5]: https://hub.docker.com/_/consul/
[6]: https://github.com/sdelrio/consul
[7]: https://github.com/dockersamples/docker-swarm-visualizer
