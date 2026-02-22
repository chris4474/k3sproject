ingress:
  # -- Enable ingress controller resource
  enabled: true
  # -- Annotations for Ingress resource
  annotations:
    {}
    # kubernetes.io/tls-acme: "true"

  # -- Additional labels to add to the Ingress resource
  labels: {}
    # app.kubernetes.io/part-of: traefik
    # environment: prod

  # -- Ingress class name. replacement for the deprecated "kubernetes.io/ingress.class" annotation
  ingressClassName: ""

  # -- Hostname(s) for the Ingress resource
  # Please refer to https://kubernetes.io/docs/reference/kubernetes-api/service-resources/ingress-v1/#IngressSpec for more information.
  hosts:
    - host: headlamp.${cluster}.symphorines.home
      paths:
      - path: /
        type: ImplementationSpecific
  # -- Ingress TLS configuration
  tls:
    - secretName: apps-certificate
      hosts:
        - headlamp.${cluster}.symphorines.home

