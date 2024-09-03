apiVersion: traefik.containo.us/v1alpha1
kind: Middleware
metadata:
  name: add-whoami
  namespace: ${namespace}
spec:
  addPrefix:
    prefix: /whoami
