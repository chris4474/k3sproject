apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ingress
  namespace: traefik-whoami
  annotations:
    traefik.ingress.kubernetes.io/router.entrypoints: web

spec:
  rules:
    - host: whoami.${cluster}.symphorines.home
      http:
        paths:
          - path: /whoami
            pathType: Exact
            backend:
              service:
                name:  whoami
                port:
                  number: 80
