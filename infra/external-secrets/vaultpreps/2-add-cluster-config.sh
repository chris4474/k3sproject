#!/bin/bash
#
# set environment specific variables
#
. env.sh

cluster_url=$(kubectl config view --raw --minify --flatten | yq -r '.clusters[0].cluster.server')
cluster_ca=$(mktemp /tmp/cluster_ca.XXXX)
kubectl config view --raw --minify --flatten -o jsonpath='{.clusters[0].cluster.certificate-authority-data}' | base64 --decode > ${cluster_ca}

vault write auth/kub-${cluster}/config \
    kubernetes_host="${cluster_url}" \
    kubernetes_ca_cert=@${cluster_ca} \
    disable_local_ca_jwt=true \
    disable_iss_validation=true

vault read auth/kub-${cluster}/config

[ -e ${cluster_ca} ] && rm ${cluster_ca}
