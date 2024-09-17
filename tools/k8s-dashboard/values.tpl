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
  env:
#   the following settings are for use on IPV4 only k8s clusters, they are not needed
#   on  an IPV6 enable cluster
#    proxy_listen: "0.0.0.0:8443 http2 ssl"
#    admin_listen: "127.0.0.1:8444 http2 ssl"
#    status_listen: "0.0.0.0:8100"
  proxy:
    annotations:
      traefik.ingress.kubernetes.io/service.serversscheme: https
      traefik.ingress.kubernetes.io/service.serverstransport: k8s-dashboard-skipverify@kubernetescrd
