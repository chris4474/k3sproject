apiVersion: traefik.containo.us/v1alpha1
kind: IngressRoute
metadata:
  name: traefik-dashboard-secure
  namespace: kube-system
spec:
  entryPoints:
  - websecure
  routes:
  - kind: Rule
    match: Host("traefik.${cluster}.symphorines.home")
    middlewares:
    - name: dashboard-auth
    - name: dashboard-rewrite
    services:
    - name: traefik-dashboard
      port: 9000
  - kind: Rule
    match: Host("traefik.${cluster}.symphorines.home") && PathPrefix("/api")
    middlewares:
    - name: dashboard-auth
    services:
    - name: traefik-dashboard
      port: 9000
  tls:
    secretName: ${secretname}
