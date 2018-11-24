
http://autopilotpattern.io/

https://www.joyent.com/containerpilot

https://github.com/hashicorp/docker-consul/issues/66


Features:
- No seed Consul server
- Self-Healing (depending on how you deployed the infrastructure)
- Consul Servers on all manager nodes
- Consul Agents on all worker nodes


https://github.com/sdelrio/consul


From https://bhavik.io/2017/12/19/consul-with-docker-swarm-mode.html

```
# create overlay
sudo docker network create -d overlay --subnet=192.168.0.0/16 default_net
# deploy
docker stack deploy -c /opt/consul/compose.yaml consul
```

consul ui : http://<manager-ip>:8500/ui
consul api: http://<node-ip>:8500/v1/

Service Registration/Discovery
The normal setup is the application accessing the Consul node which is running on the same machine. However, with containers in the mix, the way to connect differs. If the application is not deployed as a docker service, then you can still register the service in Consul using <node-ip>:8500 or localhost:8500 but health checks will fail.

If the deployed as a service which is most likely scenario when using Docker Swarm Mode. Then you can use the ingress gateway to connect to Consul, which for my configuration was 172.17.0.1:8500. The service must be attached to default_net for health checks to work correctly.
