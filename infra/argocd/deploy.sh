#!/bin/bash
#
# set environment specific variables
#
. env.sh

read -t 10 -p "Deploy ArgoCD in cluster ${cluster^^} namespace ${namespace^^}. Are you OK ? Y,N [N] " answer
if [ "$answer" != "Y" ] && [ "$answer" != "y" ]
then
  echo Bye
  exit
fi
#
# directories with template/yaml files
#
dirsrc=$(dirname $0)
dirdest=$dirsrc/$cluster

argo_repo=https://argoproj.github.io/argo-helm
if ! helm repo list | grep  -q $argo_repo
then
   echo Adding the argo-cd helm repository
   helm repo add argo $argo_repo
fi
helm repo update argo

#
# deploy assets likes namespace and secret for use by INgress
#
kubectl apply -k $dirsrc/kustomize/overlays/rpi-cluster/

#
# Generate values file for use by the helm chart
#
chart_values=$(mktemp /tmp/chart_values.XXXX)
envsubst <${dirsrc}/chart-values.tpl >${chart_values}


#
# Install argoCD with Helm
#
helm upgrade --install argocd argo/argo-cd --create-namespace --namespace argocd --values ${chart_values}


