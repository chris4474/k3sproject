apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: drupal
  namespace: ${namespace}
spec:
  ingressClassName: traefik
  rules:
  - host: drupal.${cluster}.symphorines.home
    http:
      paths:
      - backend:
          service:
            name: drupal
            port:
              name: http
        path: /
        pathType: ImplementationSpecific
  tls:
  - hosts:
    - drupal.${cluster}.symphorines.home
    secretName: apps-certificate
