#!/bin/bash
cluster=$(kubectl config current-context)
read -t 5 -p "About to deploy wordpress on cluster $cluster. Are you OK ? Y,N [N] " answer
if [ "$answer" != "Y" ] && [ "$answer" != "y" ]
then
  echo Bye
  exit
fi

dirsrc=$(dirname $0)
dirdest=$dirsrc/$cluster

kubectl apply -f namespace.yaml

#
# Create the TLS secret with our certificate/key pair
#
kubectl create secret generic -n wordpress apps-certificate \
    --from-file=tls.key=$HOME/certs/apps/apps.key \
    --from-file=tls.crt=<(cat $HOME/certs/apps/apps.crt $HOME/certs/apps/intCA.crt)

#
# Deploy Wordpress with Helm, using customised values
#
chart_values=$(mktemp)
cluster=$cluster envsubst <$dirsrc/chart-values.tpl >${chart_values}
helm install wordpress bitnami/wordpress --version 23.1.10 --namespace=wordpress --create-namespace -f ${chart_values}
# Delete the file containinig the chart's values as this is not a kubernetes manifest
#[ -f ${chart_values} ] && rm ${chart_values} 

#
# Apply additional Manifests
#
[ ! -d $dirdest ] && mkdir $dirdest
[ -f ${dirsrc}/*.yaml.tpl ] && for file in ${dirsrc}/*.yaml.tpl
do
   outputfile=${dirdest}/$(basename $file ".tpl")
   cluster=$cluster envsubst <$file  >$outputfile
   kubectl apply -f $outputfile
done
