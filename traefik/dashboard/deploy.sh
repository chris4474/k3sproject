#!/bin/bash
cluster=$(kubectl config current-context)
read -t 5 -p "About to expose traefik console on cluster $cluster. Are you OK ? Y,N [N] " answer
if [ "$answer" != "Y" ] && [ "$answer" != "y" ]
then
  echo Bye
  exit
fi

dirsrc=$(dirname $0)
dirdest=$dirsrc/$cluster
secretname=apps-tls-secret

echo generating manifests in folder $dirdest
[ ! -d $dirdest ] && mkdir $dirdest
for file in ${dirsrc}/*.yaml.tpl
do
   outputfile=${dirdest}/$(basename $file ".tpl")
   cluster=$cluster secretname=${secretname} envsubst <$file  >$outputfile
   kubectl apply -f $outputfile
done

kubectl create secret generic -n kube-system ${secretname} \
    --from-file=tls.key=$HOME/certs/apps/apps.key \
    --from-file=tls.crt=<(cat $HOME/certs/apps/apps.crt $HOME/certs/apps/intCA.crt)

