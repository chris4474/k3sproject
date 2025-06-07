apiVersion: traefik.io/v1alpha1
kind: ServersTransport
metadata:
  name: skipverify
  namespace: ${namespace}
spec:
  insecureSkipVerify: true
  serverName: k8s-dashboard-kong-proxy
