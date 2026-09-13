export namespace=external-secrets
export cluster=$(kubectl config current-context)
export apps_tls_certificate_chain="$(cat $HOME/certs/apps/apps.crt $HOME/certs/apps/intCA.crt | base64 | tr -d '\n')"
export apps_tls_private_key="$(cat $HOME/certs/apps/apps.key | base64 | tr -d '\n')"

