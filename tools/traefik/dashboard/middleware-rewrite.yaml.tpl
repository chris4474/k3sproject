apiVersion: traefik.containo.us/v1alpha1
kind: Middleware
metadata:
  name: dashboard-rewrite
  namespace: kube-system
spec:
  addPrefix:
    prefix: /dashboard
