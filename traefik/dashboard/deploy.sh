#!/bin/bash
cluster=$(kubectl config current-context)
read -t 5 -p "About to expose traefik console on cluster $cluster. Are you OK ? Y,N [N] " answer
if [ "$answer" != "Y" ] && [ "$answer" != "y" ]
then
  echo Bye
  exit
fi


kubectl create secret generic -n kube-system apps-tls-secret \
    --from-file=tls.key=$HOME/certs/apps/apps.key \
    --from-file=tls.crt=<(cat $HOME/certs/apps/apps.crt $HOME/certs/apps/intCA.crt)


#cluster=$cluster envsubst <ingressroute-redirect.yaml.tpl >ingressroute-redirect.yaml
#kubectl apply -f ingressroute-redirect.yaml

kubectl apply -f service.yaml
kubectl apply -f users.yaml
kubectl apply -f middleware-auth.yaml
#kubectl apply -f middleware-redirect.yaml
kubectl apply -f middleware-rewrite.yaml 
cluster=$cluster envsubst < ingressroute-tls.yaml.tpl >ingressroute-tls.yaml
kubectl apply -f ingressroute-tls.yaml
