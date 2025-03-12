#!/bin/bash
#
# set environment specific variables
#
. env.sh

read -t 10 -p "Deploy NFS CSI driver in cluster ${cluster^^} namespace kube-system }. Are you OK ? Y,N [N] " answer
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
# Deploy the NFS CSI driver with HELM
#
helm repo add csi-driver-nfs  https://raw.githubusercontent.com/kubernetes-csi/csi-driver-nfs/master/charts
helm install csi-driver-nfs -n kube-system csi-driver-nfs/csi-driver-nfs

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

