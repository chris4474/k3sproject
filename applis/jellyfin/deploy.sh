#!/bin/bash
#
# set environment specific variables
#
. env.sh

if  [ "$cluster" != "rpi" ] && [ "$cluster" != "apps" ]
then
  echo Sorry, for now I can only deploy on clusters \"rpi\" and \"apps\"
  exit
fi

read -t 10 -p "Deploy JELLYFIN in cluster ${cluster^^} namespace ${namespace^^}. Are you OK ? Y,N [N] " answer
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
# the JELLYFIN workload is deployed in the last phase
#

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

