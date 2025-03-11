#!/bin/bash
#
# set environment specific variables
#
. env.sh

read -t 10 -p "Deploy WORDPRESS in cluster ${cluster^^} namespace ${namespace^^}. Are you OK ? Y,N [N] " answer
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
file_values=$(mktemp /tmp/chart_values.XXXX)
envsubst <${dirsrc}/chart-values.tpl >${file_values}

#
# Deploy with helm
#
helm install wordpress bitnami/wordpress --version 24.1.14 --namespace=${namespace} --create-namespace -f ${file_values}

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
     kubectl apply -f ${outputfile}
   fi
done


