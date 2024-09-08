#!/bin/bash
#
# set environment specific variables
#
. env.sh

read -t 10 -p "Deploy NFS provisionner in cluster ${cluster^^} namespace ${namespace^^}. Are you OK ? Y,N [N] " answer
if [ "$answer" != "Y" ] && [ "$answer" != "y" ]
then
  echo Bye
  exit
fi

#
# directories with template/yaml files
#
dirsrc=$(dirname $0)
dirdest=$dirsrc/${cluster}


#
# Generate initial manifests
#
file_namespace=$(mktemp /tmp/namespace.XXXX)
envsubst <${dirsrc}/namespace.tpl >${file_namespace}

#
# Apply initial manifests
#
kubectl apply -f ${file_namespace}

#
# Deploy the provisionner with HELM
#
chart_values=$(mktemp /tmp/chart_values.XXXX)
envsubst <${dirsrc}/chart_values.tpl >${chart_values}
helm install nfs-syno -n ${namespace} nfs-subdir-external-provisioner/nfs-subdir-external-provisioner -f ${chart_values}

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

