apiVersion: traefik.io/v1alpha1
kind: IngressRoute
metadata:
  name: traefik-dashboard-secure
  namespace: kube-system
spec:
  entryPoints:
  - websecure
  routes:
  - kind: Rule
    match: Host("traefik.${cluster}.symphorines.home") && (PathPrefix(`/api`) || PathPrefix(`/dashboard`))
    middlewares:
    - name: dashboard-auth
    services:
    - name: api@internal
      kind: TraefikService
  tls:
    secretName: ${secretname} 
