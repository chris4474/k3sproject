#!/bin/bash
#
# set environment specific variables
#
. env.sh

read -t 10 -p "Deploy External Secrets Operator in cluster ${cluster^^} namespace external-secrets. Are you OK ? Y,N [N] " answer
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
#file_namespace=$(mktemp /tmp/namespace.XXXX)
#file_tls_secret=$(mktemp /tmp/tls_secret.XXXX)
#envsubst <${dirsrc}/namespace.tpl >${file_namespace}
#envsubst <${dirsrc}/tls-secret.tpl >${file_tls_secret}

#
# Apply initial manifests
#
#kubectl apply -f ${file_namespace}
#kubectl apply -f ${file_tls_secret}

eso_repo=https://charts.external-secrets.io
if ! helm repo list | grep  -q $eso_repo
then
   echo Adding the External Secret Operator helm repository
   helm repo add external-secrets $eso_repo
fi
helm repo update external-secrets

#
# Generate values file for use by the helm chart
#
#chart_values=$(mktemp /tmp/chart_values.XXXX)
#envsubst <${dirsrc}/chart-values.tpl >${chart_values}


#
# Install argoCD with Helm
#
helm upgrade --install external-secrets external-secrets/external-secrets --create-namespace --namespace external-secrets 


#
# Apply additional Manifests
#
cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: eso-vault-auth-delegator
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: system:auth-delegator
subjects:
- kind: ServiceAccount
  name: external-secrets
  namespace: external-secrets
EOF

kubectl create secret generic vault-ca-cert --from-file=ca.crt=/home/chris/certs/ca.crt -n external-secrets --save-config=true

#
# Create the ClusterSecretStore
#
cat <<EOF | kubectl apply -f -
apiVersion: external-secrets.io/v1
kind: ClusterSecretStore
metadata:
  name: vault-backend
spec:
  provider:
    vault:
      server: "https://vault.symphorines.home:8200"
      caProvider:
        type: Secret
        name: vault-ca-cert
        key: ca.crt
        namespace: external-secrets
      path: "secret-${cluster}"
      version: "v2"
      auth:
        kubernetes:
          mountPath: kub-${cluster}
          role: "eso-role"
          serviceAccountRef:
            name: "external-secrets"
            namespace: "external-secrets"
EOF

