apiVersion: traefik.containo.us/v1alpha1
kind: IngressRoute
metadata:
  name: traefik-dashboard-http
  namespace: kube-system
spec:
  entryPoints:
  - web
  routes:
  - kind: Rule
    match: Host("traefik.${cluster}.symphorines.home")
    services:
    - name: api@internal
      kind: TraefikService
    middlewares:
    - name: redirect-permanent
