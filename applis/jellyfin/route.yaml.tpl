apiVersion: traefik.containo.us/v1alpha1
kind: IngressRoute
metadata:
  name: jellyfin
  namespace: jellyfin
spec:
  entryPoints:
  - websecure
  tls:
    secretName: apps-certificate
  routes:
  - kind: Rule
    match: Host(`jellyfin.${cluster}.symphorines.home`)
    services:
      - kind: Service
        name: jellyfin
        port: 8096
