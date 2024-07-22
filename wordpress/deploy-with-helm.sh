helm install wordpress \
  --set wordpressUsername=admin \
  --set wordpressPassword=password \
  --set mariadb.auth.rootPassword=secretpassword \
  --set service.type=ClusterIP \
    bitnami/wordpress --version 23.0.0
