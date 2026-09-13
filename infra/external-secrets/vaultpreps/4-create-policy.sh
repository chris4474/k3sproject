#!/bin/bash
#
# set environment specific variables
#
. env.sh

policy_file=$(mktemp /tmp/eso-policy.XXXX)
cat <<EOF > ${policy_file}
# Autorise la lecture des données réelles (obligatoire pour KV v2)
path "secret-${cluster}/data/apps/*" {
  capabilities = ["read"]
}

# Autorise l'affichage des dossiers (utile pour l'opérateur)
path "secret-${cluster}/metadata/apps/*" {
  capabilities = ["list", "read"]
}
EOF

vault policy write eso-policy-${cluster} ${policy_file}
