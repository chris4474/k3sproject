#!/bin/bash
#
# set environment specific variables
#
. env.sh

if  [ "$cluster" != "alp" ] && [ "$cluster" != "rpi" ]
then
  echo Sorry, for now I can only deploy on cluster \"alp\"
  exit
fi

read -t 10 -p "Deploy HOME ASSISTANT in cluster ${cluster^^} namespace ${namespace^^}. Are you OK ? Y,N [N] " answer
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
# the HOME ASSISTANT workload is deployed with HELM
#   from http://pajikos.github.io/home-assistant-helm-chart
#
chart_values=$(mktemp /tmp/chart-values.XXXX)
envsubst <${dirsrc}/chart-values.tpl >${chart_values}
helm install ha -n ${namespace} helm-hass/home-assistant -f ${chart_values} --version 0.2.78

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

