apiVersion: traefik.containo.us/v1alpha1
kind: Middleware
metadata:
  name: add-whoami
  namespace: traefik-whoami
spec:
  addPrefix:
    prefix: /whoami

apiVersion: traefik.containo.us/v1alpha1
kind: IngressRoute
metadata:
  name: ingressroute
  namespace: traefik-whoami
spec:
  entryPoints:
  - web
  routes:
  - kind: Rule
    match: Host(`whoami.${cluster}.symphorines.home`)
    middlewares:
      - name: add-whoami
    services:
      - kind: Service
        name: whoami
        port: 80
  
