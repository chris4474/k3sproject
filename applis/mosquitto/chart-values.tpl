replicaCount: 1
strategyType: Recreate

image:
  repository: eclipse-mosquitto
  tag: 2.0.18-openssl
  pullPolicy: IfNotPresent

imagePullSecrets: []
nameOverride: ""
fullnameOverride: ""

serviceAccount:
  # --Specifies whether a service account should be created
  create: true
  # The name of the service account to use.
  # If not set and create is true, a name is generated using the fullname template
  name:

service:
  type: NodePort
  #externalTrafficPolicy: Cluster
  annotations: {}
    # metallb.universe.tf/allow-shared-ip: pi-hole

ports:
  mqtt:
    port: 8883
    # sets consistent nodePort, required to set service.type=NodePort
    nodePort: 31883
    protocol: TCP
  websocket:
    port: 9090
    protocol: TCP
    nodePort: 30090

persistence:
  enabled: true
  accessMode: ReadWriteOnce
  existingClaim: "pvc-mosquitto"
  mountPath: /mosquitto/data
  subPath: ""
  ## database data Persistent Volume Storage Class
  ## If defined, storageClassName: <storageClass>
  ## If set to "-", storageClassName: "", which disables dynamic provisioning
  ## If undefined (the default) or set to null, no storageClassName spec is
  ##   set, choosing the default provisioner.  (gp2 on AWS, standard on
  ##   GKE, AWS & OpenStack)
  ##
  storageClass: "-"
  size: 1Gi

resources: {}
  # We usually recommend not to specify default resources and to leave this as a conscious
  # choice for the user. This also increases chances charts run on environments with little
  # resources, such as Minikube. If you do want to specify resources, uncomment the following
  # lines, adjust them as necessary, and remove the curly braces after 'resources:'.
  # limits:
  #   cpu: 100m
  #   memory: 128Mi
  # requests:
  #   cpu: 100m
  #   memory: 128Mi

podSecurityContext:
  runAsUser: 1002
  fsGroup: 1002

securityContext:
  runAsUser: 1002
  fsGroup: 1002

nodeSelector: {}

tolerations: []

affinity: {}

authentication:
  passwordEntries: ""
  # To use authentication with mosquitto, you can set a list of password entries to be used.
  # reference https://mosquitto.org/man/mosquitto_passwd-1.html to generate these entries.
  # For example:
  # passwordEntries: |-
  #   user1:$6$BKzw0RKerxV4Esbj$Uz5slWGB1TiOtYIEokEl0eR1YSEQAdKpcdRYMsLYbwjktlVzdLyGk41YCPGyMLnBePtdwPhkcm8kjGI0R9s57w==
  #   user2:$6$b5vYuHrSLj48Ii32$NjlbnatIaUQSsNvxxTpawpav6NPyZ8QhGrdEVGtyU1rgEGjNzVGKlstRg29FV6MFTPs/ugPA8D5I5+qRcIMXSg==
  passwordFilePath: "/etc/mosquitto/passwordfile"

authorization:
  acls: ""
  # To use authorizations with mosquitto, you can set a list of per user or pattern-based rules.
  # reference https://mosquitto.org/man/mosquitto-conf-5.html for further information.
  # For example:
  # acls: |-
      # zigbee2mqtt ACLs
      # user zigbee2mqtt
      # topic readwrite zigbee2mqtt/#
      # topic readwrite homeassistant/#
      # Tasmota-compatible ACLs
      # pattern read cmnd/%u/#
      # pattern write stat/%u/#
      # pattern write tele/%u/#
  aclfilePath: "/etc/mosquitto/aclfile"

existingConfigMap: ""
config: |
  persistence true
  persistence_location /mosquitto/data/
  log_dest stdout
  listener 8883
  require_certificate true
  certfile /mosquitto/data/cert/cert-plus-intca.pem
  keyfile /mosquitto/data/cert/apps.key
  cafile /mosquitto/data/cert/ca.crt
  use_identity_as_username true
  allow_anonymous true
  listener 9090
  protocol websockets
  require_certificate true
  certfile /mosquitto/data/cert/cert-plus-intca.pem
  keyfile /mosquitto/data/cert/apps.key
  cafile /mosquitto/data/cert/ca.crt

## Additional volumes.
extraVolumes: []
  # - name: tls
  #   secret:
  #     secretName: mosquitto-certs

## Additional volumeMounts to the main container.
extraVolumeMounts: []
  # - name: tls
  #   mountPath: /certs
  #   subPath: cafile

monitoring:
  podMonitor:
    enabled: false
  sidecar:
    enabled: false
    port: 9234
    # nodePort: 32234
    image:
      repository: nolte/mosquitto-exporter
      tag: v0.6.3
      pullPolicy: IfNotPresent
    resources:
      limits:
        cpu: 300m
        memory: 128Mi
      requests:
        cpu: 100m
        memory: 64Mi

