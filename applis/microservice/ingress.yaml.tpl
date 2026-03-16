---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ${namespace}
  namespace: ${namespace}
spec:
  rules:
  - host: ${namespace}.${cluster}.symphorines.home
    http:
      paths:
      - backend:
          service:
            name: frontend
            port:
              number: 80
        path: /
        pathType: ImplementationSpecific
  tls:
  - hosts:
    - ${namespace}.${cluster}.symphorines.home
    secretName: apps-certificate

