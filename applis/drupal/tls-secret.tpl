apiVersion: v1
data:
  tls.crt: ${apps_tls_certificate_chain}
  tls.key: ${apps_tls_private_key}
kind: Secret
metadata:
  name:  apps-certificate
  namespace: ${namespace}
type: Opaque
