apiVersion: traefik.io/v1alpha1
kind: Middleware
metadata:
  name: dashboard-auth
  namespace: kube-system
spec:
  basicAuth:
    secret: dashboard-users
