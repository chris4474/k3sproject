#!/bin/bash
cluster=$(kubectl config current-context)
read -t 5 -p "About to deploy k8s dashboard on cluster $cluster. Are you OK ? Y,N [N] " answer
if [ "$answer" != "Y" ] && [ "$answer" != "y" ]
then
  echo Bye
  exit
fi

kubectl apply -f namespace.yaml

kubectl create secret generic --namespace k8s-dashboard apps-certificate \
    --from-file=tls.key=$HOME/certs/apps/apps.key \
    --from-file=tls.crt=<(cat $HOME/certs/apps/apps.crt $HOME/certs/apps/intCA.crt)

cluster=$cluster envsubst <values.yaml.tpl >values.yaml
helm upgrade --install k8s-dashboard kubernetes-dashboard/kubernetes-dashboard \
   --namespace k8s-dashboard \
   -f values.yaml

kubectl apply -f user.yaml
kubectl apply -f cr-binding.yaml
kubectl apply -f servertransport.yaml
kubectl -n k8s-dashboard create token admin-user

