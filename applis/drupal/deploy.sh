#!/bin/bash
#
# set environment specific variables
#
. env.sh

read -t 10 -p "Deploy DRUPAL in cluster ${cluster^^} namespace ${namespace^^}. Are you OK ? Y,N [N] " answer
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


#
# Generate initial manifests
#
file_namespace=$(mktemp /tmp/namespace.XXXX)
file_tls_secret=$(mktemp /tmp/tls_secret.XXXX)
envsubst <${dirsrc}/namespace.tpl >${file_namespace}
envsubst <${dirsrc}/tls-secret.tpl >${file_tls_secret}

#
# Apply initial manifests
#
kubectl apply -f ${file_namespace}
kubectl apply -f ${file_tls_secret}

#
# Generate values file for use by the helm chart
#
chart_values=$(mktemp /tmp/chart_values.XXXX)
envsubst <${dirsrc}/chart-values.tpl >${chart_values}

#
# Deploy Drupal with helm
#
helm install drupal bitnami/drupal --version 20.0.2 --namespace=${namespace} -f ${chart_values}
[ -f ${chart_values} ] && rm ${chart_values}

#
# Apply additional Manifests
#
[ ! -d $dirdest ] && mkdir $dirdest
for file in ${dirsrc}/*.yaml.tpl
do
   if [ -f $file ]
   then
     outputfile=${dirdest}/$(basename $file ".tpl")
     envsubst <$file  >${outputfile}
     kubectl apply -n ${namespace} -f ${outputfile}
   fi
done

