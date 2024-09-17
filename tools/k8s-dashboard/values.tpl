app:
  image:
    pullPolicy: Always
  ingress:
    enabled: true
    hosts:
      - k8s-dashboard.${cluster}.symphorines.home
    ingressClassName: traefik
    useDefaultAnnotations: false
    tls:
      enabled: true
      secretName: apps-certificate

kong:
  proxy:
    annotations:
      traefik.ingress.kubernetes.io/service.serversscheme: https
      traefik.ingress.kubernetes.io/service.serverstransport: k8s-dashboard-skipverify@kubernetescrd

