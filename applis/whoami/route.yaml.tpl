apiVersion: traefik.containo.us/v1alpha1
kind: Middleware
metadata:
  name: add-whoami
  namespace: ${namespace}
spec:
  addPrefix:
    prefix: /whoami

apiVersion: traefik.containo.us/v1alpha1
kind: IngressRoute
metadata:
  name: whoami
  namespace: ${namespace}
spec:
  entryPoints:
  - websecure
  routes:
  - kind: Rule
    match: Host(`whoami.${cluster}.symphorines.home`)
    middlewares:
      - name: add-whoami
    services:
      - kind: Service
        name: whoami
        port: 80
  tls:
    secretName: apps-certificate
