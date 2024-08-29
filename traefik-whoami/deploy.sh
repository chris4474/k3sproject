#!/bin/bash
cluster=$(kubectl config current-context)
read -t 5 -p "About to deploy whoami app on cluster $cluster. Are you OK ? Y,N [N] " answer
if [ "$answer" != "Y" ] && [ "$answer" != "y" ]
then
  echo Bye
  exit
fi


kubectl create secret generic --namespace traefik-whoami apps-certificate \
    --from-file=tls.key=$HOME/certs/apps/apps.key \
    --from-file=tls.crt=<(cat $HOME/certs/apps/apps.crt $HOME/certs/apps/intCA.crt)

#
# Deploy the workload
#
kubectl apply -f workload.yaml

#
# Expose it using Traefik
#
kubectl apply -f traefik-style/middlewares.yaml
cluster=$cluster envsubst <traefik-style/route.yaml.tpl >/tmp/route-whoami.yaml
kubectl apply -f /tmp/route-whoami.yaml
