
#!/bin/bash
#
# set environment specific variables
#
. env.sh

#
# Load the wildcard TLS certificate and key for *.{app,alp,rpi}.symphorines.home
#
#vault kv put secret-${cluster}/apps/tls  tls.crt=@/home/chris/certs/apps/cert-plus-intca.pem     tls.key=@/home/chris/certs/apps/apps.key

#
# Load my creds with gitea
#
token=$(cat ~/.git-credentials | cut -d':' -f3 | cut -d'@' -f1)
#vault kv put secret-${cluster}/gitea/chris token=$token

#
#
#
registry_specs=$(mktemp /tmp/token.XXXX)
cat <<EOF >${registry_specs}
{
  "name": "k3sproject",
  "password": "28884b3761e6eb4b02ec8a037af93fa73f1e11d9",
  "project": "default",
  "type": "git",
  "url": "https://gitea.symphorines.home/chris/k3sproject",
  "username": "chris"
}
EOF
vault kv put secret-${cluster}/k3sproject @${registry_specs}
