# Join a worker node

On the worker node
```
$ export K3S_URL="https://<IP of master>:6443"
$ export K3S_TOKEN="<content of /var/lib/rancher/k3s/server/node-token on master> "

$ curl -sfL https://get.k3s.io | sh -
```
