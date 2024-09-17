apiVersion: traefik.containo.us/v1alpha1
kind: ServersTransport
metadata:
  name: skipverify
  namespace: ${namespace}
spec:
  insecureSkipVerify: true
  serverName: k8s-dashboard-kong-proxy
