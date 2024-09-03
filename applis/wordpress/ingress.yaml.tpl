---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: wordpress
  namespace: wordpress
spec:
  rules:
  - host: wordpress.${cluster}.symphorines.home
    http:
      paths:
      - backend:
          service:
            name: wordpress
            port:
              number: 80
        path: /
        pathType: ImplementationSpecific
  tls:
  - hosts:
    - wordpress.${cluster}.symphorines.home
    secretName: apps-certificate

