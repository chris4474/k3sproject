#!/bin/bash
#
# set environment specific variables
#
. env.sh

read -t 10 -p "Deploy HEADLAMP in cluster ${cluster^^} namespace ${namespace^^}. Are you OK ? Y,N [N] " answer
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
# the workload is deployed with HELM
#
values_file=$(mktemp /tmp/values.XXXX)
envsubst <values.tpl >${values_file}
helm upgrade --install headlamp headlamp/headlamp --version 0.40.0 \
   --namespace ${namespace} \
   -f ${values_file}

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
#
# generate token
#
kubectl -n ${namespace} create token headlamp
