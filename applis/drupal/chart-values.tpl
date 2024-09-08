# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

## @section Global parameters
## Global Docker image parameters
## Please, note that this will override the image parameters, including dependencies, configured to use the global value
## Current available global Docker image parameters: imageRegistry, imagePullSecrets and storageClass

## @param global.imageRegistry Global Docker image registry
## @param global.imagePullSecrets Global Docker registry secret names as an array
## @param global.defaultStorageClass Global default StorageClass for Persistent Volume(s)
## @param global.storageClass DEPRECATED: use global.defaultStorageClass instead
##
global:
  imageRegistry: ""
  ## E.g.
  ## imagePullSecrets:
  ##   - myRegistryKeySecretName
  ##
  imagePullSecrets: []
  defaultStorageClass: ""
  storageClass: ""
  ## Compatibility adaptations for Kubernetes platforms
  ##
  compatibility:
    ## Compatibility adaptations for Openshift
    ##
    openshift:
      ## @param global.compatibility.openshift.adaptSecurityContext Adapt the securityContext sections of the deployment to make them compatible with Openshift restricted-v2 SCC: remove runAsUser, runAsGroup and fsGroup and let the platform use their allowed default IDs. Possible values: auto (apply if the detected running cluster is Openshift), force (perform the adaptation always), disabled (do not perform adaptation)
      ##
      adaptSecurityContext: auto
## @section Common parameters

## @param kubeVersion Force target Kubernetes version (using Helm capabilities if not set)
##
kubeVersion: ""
## @param nameOverride String to partially override drupal.fullname template (will maintain the release name)
##
nameOverride: ""
## @param fullnameOverride String to fully override drupal.fullname template
##
fullnameOverride: ""
## @param namespaceOverride String to fully override common.names.namespace
##
namespaceOverride: ""
## @param commonAnnotations Common annotations to add to all Drupal resources (sub-charts are not considered). Evaluated as a template
##
commonAnnotations: {}
## @param commonLabels Common labels to add to all Drupal resources (sub-charts are not considered). Evaluated as a template
##
commonLabels: {}
## @param extraDeploy Array of extra objects to deploy with the release (evaluated as a template).
##
extraDeploy: []
## @section Drupal parameters

## Bitnami Drupal image version
## ref: https://hub.docker.com/r/bitnami/drupal/tags/
## @param image.registry [default: REGISTRY_NAME] Drupal image registry
## @param image.repository [default: REPOSITORY_NAME/drupal] Drupal Image name
## @skip image.tag Drupal Image tag
## @param image.digest Drupal image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag
## @param image.pullPolicy Drupal image pull policy
## @param image.pullSecrets Specify docker-registry secret names as an array
## @param image.debug Specify if debug logs should be enabled
##
image:
  registry: docker.io
  repository: bitnami/drupal
  tag: 11.0.2-debian-12-r0
  digest: ""
  ## Specify a imagePullPolicy
  ## Defaults to 'Always' if image tag is 'latest', else set to 'IfNotPresent'
  ## ref: https://kubernetes.io/docs/concepts/containers/images/#pre-pulled-images
  ##
  pullPolicy: IfNotPresent
  ## Optionally specify an array of imagePullSecrets.
  ## Secrets must be manually created in the namespace.
  ## ref: https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/
  ## e.g:
  ## pullSecrets:
  ##   - myRegistryKeySecretName
  ##
  pullSecrets: []
  ## Set to true if you would like to see extra information on logs
  ##
  debug: false
## @param replicaCount Number of Drupal Pods to run (requires ReadWriteMany PVC support)
##
replicaCount: 1
## @param drupalProfile Drupal installation profile
## ref: https://github.com/bitnami/containers/tree/main/bitnami/drupal#configuration
##
drupalProfile: standard
## @param drupalSkipInstall Skip Drupal installation wizard. Useful for migrations and restoring from SQL dump
## ref: https://github.com/bitnami/containers/tree/main/bitnami/drupal#configuration
##
drupalSkipInstall: false
## @param drupalUsername User of the application
## ref: https://github.com/bitnami/containers/tree/main/bitnami/drupal#configuration
##
drupalUsername: chris
## @param drupalPassword Application password
## Defaults to a random 10-character alphanumeric string if not set
## ref: https://github.com/bitnami/containers/tree/main/bitnami/drupal#configuration
##
drupalPassword: "drupal"
## @param drupalEmail Admin email
## ref: https://github.com/bitnami/containers/tree/main/bitnami/drupal#configuration
##
drupalEmail: user@example.com
## @param allowEmptyPassword Allow DB blank passwords
## ref: https://github.com/bitnami/containers/tree/main/bitnami/drupal#environment-variables
##
allowEmptyPassword: true
## @param command Override default container command (useful when using custom images)
##
command: []
## @param args Override default container args (useful when using custom images)
##
args: []
## @param updateStrategy.type Update strategy - only really applicable for deployments with RWO PVs attached
## If replicas = 1, an update can get "stuck", as the previous pod remains attached to the
## PV, and the "incoming" pod can never start. Changing the strategy to "Recreate" will
## terminate the single previous pod, so that the new, incoming pod can attach to the PV
##
updateStrategy:
  type: RollingUpdate
## @param priorityClassName Drupal pods' priorityClassName
##
priorityClassName: ""
## @param schedulerName Name of the k8s scheduler (other than default)
## ref: https://kubernetes.io/docs/tasks/administer-cluster/configure-multiple-schedulers/
##
schedulerName: ""
## @param topologySpreadConstraints Topology Spread Constraints for pod assignment
## https://kubernetes.io/docs/concepts/workloads/pods/pod-topology-spread-constraints/
## The value is evaluated as a template
##
topologySpreadConstraints: []
## @param automountServiceAccountToken Mount Service Account token in pod
##
automountServiceAccountToken: false
## @param hostAliases [array] Add deployment host aliases
## https://kubernetes.io/docs/concepts/services-networking/add-entries-to-pod-etc-hosts-with-host-aliases/
##
hostAliases:
  ## Necessary for apache-exporter to work
  ##
  - ip: "127.0.0.1"
    hostnames:
      - "status.localhost"
## @param extraEnvVars Extra environment variables
## For example:
##
extraEnvVars: []
#  - name: BEARER_AUTH
#    value: true
## @param extraEnvVarsCM ConfigMap containing extra env vars
##
extraEnvVarsCM: ""
## @param extraEnvVarsSecret Secret containing extra env vars (in case of sensitive data)
##
extraEnvVarsSecret: ""
## @param extraVolumes Array of extra volumes to be added to the deployment (evaluated as template). Requires setting `extraVolumeMounts`
##
extraVolumes: []
## @param extraVolumeMounts Array of extra volume mounts to be added to the container (evaluated as template). Normally used with `extraVolumes`.
##
extraVolumeMounts: []
## @param initContainers Add additional init containers to the pod (evaluated as a template)
##
initContainers: []
## Pod Disruption Budget configuration
## ref: https://kubernetes.io/docs/tasks/run-application/configure-pdb
## @param pdb.create Enable/disable a Pod Disruption Budget creation
## @param pdb.minAvailable Minimum number/percentage of pods that should remain scheduled
## @param pdb.maxUnavailable Maximum number/percentage of pods that may be made unavailable. Defaults to `1` if both `pdb.minAvailable` and `pdb.maxUnavailable` are empty.
##
pdb:
  create: true
  minAvailable: ""
  maxUnavailable: ""
## @param sidecars Attach additional containers to the pod (evaluated as a template)
##
sidecars: []
## @param tolerations Tolerations for pod assignment
## Ref: https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/
##
tolerations: []
serviceAccount:
  ## @param serviceAccount.create Specifies whether a service account should be created
  ##
  create: true
  ## @param serviceAccount.name The name of the service account to use. If not set and create is true, a name is generated using the fullname template
  ##
  name: ""
  ## @param serviceAccount.annotations Add annotations
  ##
  annotations: {}
  ## @param serviceAccount.automountServiceAccountToken Automount API credentials for a service account.
  ##
  automountServiceAccountToken: false
## @param existingSecret Name of a secret with the application password
##
existingSecret: ""
## SMTP mail delivery configuration
## ref: https://github.com/bitnami/containers/tree/main/bitnami/drupal/#smtp-configuration
## @param smtpHost SMTP host
## @param smtpPort SMTP port
## @param smtpUser SMTP user
## @param smtpPassword SMTP password
## @param smtpProtocol SMTP Protocol (options: ssl,tls, nil)
##
smtpHost: ""
smtpPort: ""
smtpUser: ""
smtpPassword: ""
smtpProtocol: ""
## @param containerPorts [object] Container ports
##
containerPorts:
  http: 8080
  https: 8443
## @param extraContainerPorts Optionally specify extra list of additional ports for Drupal container(s)
## e.g:
## extraContainerPorts:
##   - name: myservice
##     containerPort: 9090
##
extraContainerPorts: []
## @param sessionAffinity Control where client requests go, to the same pod or round-robin. Values: ClientIP or None
## ref: https://kubernetes.io/docs/concepts/services-networking/service/
##
sessionAffinity: "None"
## Enable persistence using Persistent Volume Claims
## ref: https://kubernetes.io/docs/concepts/storage/persistent-volumes/
##
persistence:
  ## @param persistence.enabled Enable persistence using PVC
  ##
  enabled: true
  ## @param persistence.storageClass PVC Storage Class for Drupal volume
  ## If defined, storageClassName: <storageClass>
  ## If set to "-", storageClassName: "", which disables dynamic provisioning
  ## If undefined (the default) or set to null, no storageClassName spec is
  ##   set, choosing the default provisioner.  (gp2 on AWS, standard on
  ##   GKE, AWS & OpenStack)
  ##
  storageClass: ""
  ## @param persistence.accessModes PVC Access Mode for Drupal volume
  ## Requires persistence.enabled: true
  ## If defined, PVC must be created manually before volume will be bound
  ##
  accessModes:
    - ReadWriteOnce
  ## @param persistence.size PVC Storage Request for Drupal volume
  ##
  size: 2Gi
  ## @param persistence.existingClaim A manually managed Persistent Volume Claim
  ## Requires persistence.enabled: true
  ## If defined, PVC must be created manually before volume will be bound
  ##
  existingClaim: ""
  ## @param persistence.hostPath If defined, the drupal-data volume will mount to the specified hostPath.
  ## Requires persistence.enabled: true
  ## Requires persistence.existingClaim: nil|false
  ## Default: nil.
  ##
  hostPath: ""
  ## @param persistence.annotations Persistent Volume Claim annotations
  ##
  annotations: {}
## @param podAffinityPreset Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`
## ref: https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#inter-pod-affinity-and-anti-affinity
##
podAffinityPreset: ""
## @param podAntiAffinityPreset Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`
## Ref: https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#inter-pod-affinity-and-anti-affinity
##
podAntiAffinityPreset: soft
## Node affinity preset
## Ref: https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity
## @param nodeAffinityPreset.type Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`
## @param nodeAffinityPreset.key Node label key to match Ignored if `affinity` is set.
## @param nodeAffinityPreset.values Node label values to match. Ignored if `affinity` is set.
##
nodeAffinityPreset:
  type: ""
  ## E.g.
  ## key: "kubernetes.io/e2e-az-name"
  ##
  key: ""
  ## E.g.
  ## values:
  ##   - e2e-az1
  ##   - e2e-az2
  ##
  values: []
## @param affinity Affinity for pod assignment
## Ref: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity
## Note: podAffinityPreset, podAntiAffinityPreset, and nodeAffinityPreset will be ignored when it's set
##
affinity: {}
## @param nodeSelector Node labels for pod assignment. Evaluated as a template.
## ref: https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/
##
nodeSelector: {}
## Drupal container's resource requests and limits
## ref: https://kubernetes.io/docs/concepts/configuration/manage-compute-resources-container/
## We usually recommend not to specify default resources and to leave this as a conscious
## choice for the user. This also increases chances charts run on environments with little
## resources, such as Minikube. If you do want to specify resources, uncomment the following
## lines, adjust them as necessary, and remove the curly braces after 'resources:'.
## @param resourcesPreset Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if resources is set (resources is recommended for production).
## More information: https://github.com/bitnami/charts/blob/main/bitnami/common/templates/_resources.tpl#L15
##
resourcesPreset: "medium"
## @param resources Set container requests and limits for different resources like CPU or memory (essential for production workloads)
## Example:
## resources:
##   requests:
##     cpu: 2
##     memory: 512Mi
##   limits:
##     cpu: 3
##     memory: 1024Mi
##
resources: {}
## Configure Pods Security Context
## ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod
## @param podSecurityContext.enabled Enable Drupal pods' Security Context
## @param podSecurityContext.fsGroupChangePolicy Set filesystem group change policy
## @param podSecurityContext.sysctls Set kernel settings using the sysctl interface
## @param podSecurityContext.supplementalGroups Set filesystem extra groups
## @param podSecurityContext.fsGroup Drupal pods' group ID
##
podSecurityContext:
  enabled: true
  fsGroupChangePolicy: Always
  sysctls: []
  supplementalGroups: []
  fsGroup: 1001
## Configure Container Security Context (only main container)
## ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-container
## @param containerSecurityContext.enabled Enabled Drupal containers' Security Context
## @param containerSecurityContext.seLinuxOptions [object,nullable] Set SELinux options in container
## @param containerSecurityContext.runAsUser Set Drupal containers' Security Context runAsUser
## @param containerSecurityContext.runAsGroup Set Drupal containers' Security Context runAsGroup
## @param containerSecurityContext.runAsNonRoot Set Controller container's Security Context runAsNonRoot
## @param containerSecurityContext.privileged Set Drupal container's Security Context privileged
## @param containerSecurityContext.allowPrivilegeEscalation Set Drupal container's Security Context allowPrivilegeEscalation
## @param containerSecurityContext.capabilities.drop List of capabilities to be dropped
## @param containerSecurityContext.seccompProfile.type Set container's Security Context seccomp profile
## @param containerSecurityContext.readOnlyRootFilesystem Set Drupal container's Security Context readOnlyRootFilesystem
##
containerSecurityContext:
  enabled: true
  seLinuxOptions: {}
  runAsUser: 1001
  runAsGroup: 1001
  runAsNonRoot: true
  privileged: false
  allowPrivilegeEscalation: false
  readOnlyRootFilesystem: true
  capabilities:
    drop: ["ALL"]
  seccompProfile:
    type: "RuntimeDefault"
## Configure extra options for startup probe
## Drupal core exposes /user/login to unauthenticated requests, making it a good
## default startup and readiness path. However, that may not always be the
## case. For example, if the image value is overridden to an image containing a
## module that alters that route, or an image that does not auto-install Drupal.
## ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-probes/#configure-probes
## @param startupProbe.enabled Enable startupProbe
## @param startupProbe.path Request path for startupProbe
## @param startupProbe.initialDelaySeconds Initial delay seconds for startupProbe
## @param startupProbe.periodSeconds Period seconds for startupProbe
## @param startupProbe.timeoutSeconds Timeout seconds for startupProbe
## @param startupProbe.failureThreshold Failure threshold for startupProbe
## @param startupProbe.successThreshold Success threshold for startupProbe
##
startupProbe:
  enabled: false
  path: /user/login
  initialDelaySeconds: 600
  periodSeconds: 10
  timeoutSeconds: 5
  failureThreshold: 5
  successThreshold: 1
## Configure extra options for liveness probe
## ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-probes/#configure-probes
## @param livenessProbe.enabled Enable livenessProbe
## @param livenessProbe.initialDelaySeconds Initial delay seconds for livenessProbe
## @param livenessProbe.periodSeconds Period seconds for livenessProbe
## @param livenessProbe.timeoutSeconds Timeout seconds for livenessProbe
## @param livenessProbe.failureThreshold Failure threshold for livenessProbe
## @param livenessProbe.successThreshold Success threshold for livenessProbe
##
livenessProbe:
  enabled: true
  initialDelaySeconds: 600
  periodSeconds: 10
  timeoutSeconds: 5
  failureThreshold: 5
  successThreshold: 1
## Configure extra options for readiness probe
## Drupal core exposes /user/login to unauthenticated requests, making it a good
## default startup and readiness path. However, that may not always be the
## case. For example, if the image value is overridden to an image containing a
## module that alters that route, or an image that does not auto-install Drupal.
## ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-probes/#configure-probes
## @param readinessProbe.enabled Enable readinessProbe
## @param readinessProbe.path Request path for readinessProbe
## @param readinessProbe.initialDelaySeconds Initial delay seconds for readinessProbe
## @param readinessProbe.periodSeconds Period seconds for readinessProbe
## @param readinessProbe.timeoutSeconds Timeout seconds for readinessProbe
## @param readinessProbe.failureThreshold Failure threshold for readinessProbe
## @param readinessProbe.successThreshold Success threshold for readinessProbe
##
readinessProbe:
  enabled: true
  path: /user/login
  initialDelaySeconds: 30
  periodSeconds: 5
  timeoutSeconds: 1
  failureThreshold: 5
  successThreshold: 1
## @param customStartupProbe Override default startup probe
##
customStartupProbe: {}
## @param customLivenessProbe Override default liveness probe
##
customLivenessProbe: {}
## @param customReadinessProbe Override default readiness probe
##
customReadinessProbe: {}
## @param lifecycleHooks LifecycleHook to set additional configuration at startup Evaluated as a template
##
lifecycleHooks: {}
## @param podAnnotations Pod annotations
## ref: https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/
##
podAnnotations: {}
## @param podLabels Add additional labels to the pod (evaluated as a template)
## ref: https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/
##
podLabels: {}
## @section Traffic Exposure Parameters

## Kubernetes configuration. For minikube, set this to NodePort, elsewhere use LoadBalancer
##
service:
  ## @param service.type Kubernetes Service type
  ##
  type: ClusterIP
  ## @param service.ports.http Service HTTP port
  ## @param service.ports.https Service HTTPS port
  ##
  ports:
    http: 80
    https: 443
  ## @param service.loadBalancerSourceRanges Restricts access for LoadBalancer (only with `service.type: LoadBalancer`)
  ## e.g:
  ## loadBalancerSourceRanges:
  ##   - 0.0.0.0/0
  ##
  loadBalancerSourceRanges: []
  ## @param service.loadBalancerIP loadBalancerIP for the Drupal Service (optional, cloud specific)
  ## ref: https://kubernetes.io/docs/concepts/services-networking/service/#type-loadbalancer
  loadBalancerIP: ""
  ## @param service.nodePorts [object] Kubernetes node port
  ## nodePorts:
  ##   http: <to set explicitly, choose port between 30000-32767>
  ##   https: <to set explicitly, choose port between 30000-32767>
  ##
  nodePorts:
    http: ""
    https: ""
  ## @param service.externalTrafficPolicy Enable client source IP preservation
  ## ref https://kubernetes.io/docs/tasks/access-application-cluster/create-external-load-balancer/#preserving-the-client-source-ip
  ##
  externalTrafficPolicy: Cluster
  ## @param service.clusterIP %%MAIN_CONTAINER_NAME%% service Cluster IP
  ## e.g.:
  ## clusterIP: None
  ##
  clusterIP: ""
  ## @param service.extraPorts Extra ports to expose (normally used with the `sidecar` value)
  ##
  extraPorts: []
  ## @param service.annotations Additional custom annotations for %%MAIN_CONTAINER_NAME%% service
  ##
  annotations: {}
  ## @param service.sessionAffinity Session Affinity for Kubernetes service, can be "None" or "ClientIP"
  ## If "ClientIP", consecutive client requests will be directed to the same Pod
  ## ref: https://kubernetes.io/docs/concepts/services-networking/service/#virtual-ips-and-service-proxies
  ##
  sessionAffinity: None
  ## @param service.sessionAffinityConfig Additional settings for the sessionAffinity
  ## sessionAffinityConfig:
  ##   clientIP:
  ##     timeoutSeconds: 300
  ##
  sessionAffinityConfig: {}
## Configure the ingress resource that allows you to access the
## Drupal installation. Set up the URL
## ref: https://kubernetes.io/docs/concepts/services-networking/ingress/
##
ingress:
  ## @param ingress.enabled Enable ingress controller resource
  ##
  enabled: false
  ## DEPRECATED: Use ingress.annotations instead of ingress.certManager
  ## certManager: false
  ##

  ## @param ingress.pathType Ingress Path type
  ##
  pathType: ImplementationSpecific
  ## @param ingress.apiVersion Override API Version (automatically detected if not set)
  ##
  apiVersion: ""
  ## @param ingress.ingressClassName IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)
  ## This is supported in Kubernetes 1.18+ and required if you have more than one IngressClass marked as the default for your cluster .
  ## ref: https://kubernetes.io/blog/2020/04/02/improvements-to-the-ingress-api-in-kubernetes-1.18/
  ##
  ingressClassName: ""
  ## @param ingress.hostname Default host for the ingress resource
  ##
  hostname: drupal.${cluster}.symphorines.home
  ## @param ingress.path The Path to Drupal. You may need to set this to '/*' in order to use this
  ## with ALB ingress controllers.
  ##
  path: /
  ## @param ingress.annotations Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations.
  ## For a full list of possible ingress annotations, please see
  ## ref: https://github.com/kubernetes/ingress-nginx/blob/main/docs/user-guide/nginx-configuration/annotations.md
  ## Use this parameter to set the required annotations for cert-manager, see
  ## ref: https://cert-manager.io/docs/usage/ingress/#supported-annotations
  ##
  ## e.g:
  ## annotations:
  ##   kubernetes.io/ingress.class: nginx
  ##   cert-manager.io/cluster-issuer: cluster-issuer-name
  ##
  annotations: {}
  ## @param ingress.tls Enable TLS configuration for the hostname defined at ingress.hostname parameter
  ## TLS certificates will be retrieved from a TLS secret with name: {{- printf "%s-tls" .Values.ingress.hostname }}
  ## You can use the ingress.secrets parameter to create this TLS secret or relay on cert-manager to create it
  ##
  tls: false
  ## @param ingress.tlsWwwPrefix Adds www subdomain to default cert
  ## Creates tls host with ingress.hostname: {{ print "www.%s" .Values.ingress.hostname }}
  ## Is enabled if "nginx.ingress.kubernetes.io/from-to-www-redirect" is "true"
  tlsWwwPrefix: false
  ## @param ingress.extraHosts The list of additional hostnames to be covered with this ingress record.
  ## Most likely the hostname above will be enough, but in the event more hosts are needed, this is an array
  ## extraHosts:
  ## - name: drupal.local
  ##   path: /
  extraHosts: []
  ## @param ingress.extraPaths Any additional arbitrary paths that may need to be added to the ingress under the main host.
  ## For example: The ALB ingress controller requires a special rule for handling SSL redirection.
  ## extraPaths:
  ## - path: /*
  ##   backend:
  ##     serviceName: ssl-redirect
  ##     servicePort: use-annotation
  extraPaths: []
  ## @param ingress.extraTls The tls configuration for additional hostnames to be covered with this ingress record.
  ## see: https://kubernetes.io/docs/concepts/services-networking/ingress/#tls
  ## extraTls:
  ## - hosts:
  ##     - drupal.local
  ##   secretName: drupal.local-tls
  extraTls: []
  ## @param ingress.secrets If you're providing your own certificates, please use this to add the certificates as secrets
  ## key and certificate should start with -----BEGIN CERTIFICATE----- or
  ## -----BEGIN RSA PRIVATE KEY-----
  ##
  ## name should line up with a tlsSecret set further up
  ## If you're using cert-manager, this is unneeded, as it will create the secret for you if it is not set
  ##
  ## It is also possible to create and manage the certificates outside of this helm chart
  ## Please see README.md for more information
  ## Example:
  ## - name: drupal.local-tls
  ##   key:
  ##   certificate:
  ##
  secrets: []
  ## @param ingress.extraRules Additional rules to be covered with this ingress record
  ## ref: https://kubernetes.io/docs/concepts/services-networking/ingress/#ingress-rules
  ## e.g:
  ## extraRules:
  ## - host: example.local
  ##     http:
  ##       path: /
  ##       backend:
  ##         service:
  ##           name: example-svc
  ##           port:
  ##             name: http
  ##
  extraRules: []
## @section Database parameters

## MariaDB chart configuration
## https://github.com/bitnami/charts/blob/main/bitnami/mariadb/values.yaml
##
mariadb:
  ## @param mariadb.enabled Whether to deploy a mariadb server to satisfy the applications database requirements
  ## To use an external database set this to false and configure the externalDatabase parameters
  ##
  enabled: true
  ## @param mariadb.architecture MariaDB architecture (`standalone` or `replication`)
  ##
  architecture: standalone
  ## MariaDB Authentication parameters
  ## @param mariadb.auth.rootPassword Password for the MariaDB `root` user
  ## @param mariadb.auth.database Database name to create
  ## @param mariadb.auth.username Database user to create
  ## @param mariadb.auth.password Password for the database
  ##
  auth:
    ## ref: https://github.com/bitnami/containers/tree/main/bitnami/mariadb#setting-the-root-password-on-first-run
    ##
    rootPassword: "drupal1234"
    ## ref: https://github.com/bitnami/containers/blob/main/bitnami/mariadb/README.md#creating-a-database-on-first-run
    ##
    database: bitnami_drupal
    ## ref: https://github.com/bitnami/containers/blob/main/bitnami/mariadb/README.md#creating-a-database-user-on-first-run
    ##
    username: bn_drupal
    password: "drupal1234"
  primary:
    ## Enable persistence using Persistent Volume Claims
    ## ref: https://kubernetes.io/docs/concepts/storage/persistent-volumes/
    ## @param mariadb.primary.persistence.enabled Enable database persistence using PVC
    ## @param mariadb.primary.persistence.storageClass MariaDB primary persistent volume storage Class
    ## @param mariadb.primary.persistence.accessModes Database Persistent Volume Access Modes
    ## @param mariadb.primary.persistence.size Database Persistent Volume Size
    ## @param mariadb.primary.persistence.hostPath Set path in case you want to use local host path volumes (not recommended in production)
    ## @param mariadb.primary.persistence.existingClaim Name of an existing `PersistentVolumeClaim` for MariaDB primary replicas
    ##
    persistence:
      enabled: true
      ## mariadb data Persistent Volume Storage Class
      ## If defined, storageClassName: <storageClass>
      ## If set to "-", storageClassName: "", which disables dynamic provisioning
      ## If undefined (the default) or set to null, no storageClassName spec is
      ##   set, choosing the default provisioner.  (gp2 on AWS, standard on
      ##   GKE, AWS & OpenStack)
      ##
      storageClass: ""
      accessModes:
        - ReadWriteOnce
      size: 2Gi
      hostPath: ""
      existingClaim: ""
## External database configuration
## @param externalDatabase.host Host of the existing database
## @param externalDatabase.port Port of the existing database
## @param externalDatabase.user Existing username in the external db
## @param externalDatabase.password Password for the above username. Ignored if existing secret is provided
## @param externalDatabase.database Name of the existing database
## @param externalDatabase.existingSecret Name of a secret with the database password. (externalDatabase.password will be ignored and picked up from this secret). The secret has to contain the key db-password
##
externalDatabase:
  host: ""
  port: 3306
  user: bn_drupal
  password: ""
  database: bitnami_drupal
  existingSecret: ""
## @section Volume Permissions parameters

## Init containers parameters:
## volumePermissions: Change the owner and group of the persistent volume mountpoint to runAsUser:fsGroup values from the securityContext section.
##
volumePermissions:
  ## @param volumePermissions.enabled Enable init container that changes volume permissions in the data directory (for cases where the default k8s `runAsUser` and `fsUser` values do not work)
  ##
  enabled: false
  ## @param volumePermissions.image.registry [default: REGISTRY_NAME] Init container volume-permissions image registry
  ## @param volumePermissions.image.repository [default: REPOSITORY_NAME/os-shell] Init container volume-permissions image name
  ## @skip volumePermissions.image.tag Init container volume-permissions image tag
  ## @param volumePermissions.image.digest Init container volume-permissions image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag
  ## @param volumePermissions.image.pullPolicy Init container volume-permissions image pull policy
  ## @param volumePermissions.image.pullSecrets Specify docker-registry secret names as an array
  ##
  image:
    registry: docker.io
    repository: bitnami/os-shell
    tag: 12-debian-12-r29
    digest: ""
    pullPolicy: IfNotPresent
    ## Optionally specify an array of imagePullSecrets.
    ## Secrets must be manually created in the namespace.
    ## ref: https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/
    ## e.g:
    ## pullSecrets:
    ##   - myRegistryKeySecretName
    ##
    pullSecrets: []
  ## Init containers' resource requests and limits
  ## ref: https://kubernetes.io/docs/concepts/configuration/manage-compute-resources-container/
  ## We usually recommend not to specify default resources and to leave this as a conscious
  ## choice for the user. This also increases chances charts run on environments with little
  ## resources, such as Minikube. If you do want to specify resources, uncomment the following
  ## lines, adjust them as necessary, and remove the curly braces after 'resources:'.
  ## @param volumePermissions.resourcesPreset Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if volumePermissions.resources is set (volumePermissions.resources is recommended for production).
  ## More information: https://github.com/bitnami/charts/blob/main/bitnami/common/templates/_resources.tpl#L15
  ##
  resourcesPreset: "none"
  ## @param volumePermissions.resources Set container requests and limits for different resources like CPU or memory (essential for production workloads)
  ## Example:
  ## resources:
  ##   requests:
  ##     cpu: 2
  ##     memory: 512Mi
  ##   limits:
  ##     cpu: 3
  ##     memory: 1024Mi
  ##
  resources: {}
## @section Metrics parameters

## Prometheus Exporter / Metrics
##
metrics:
  ## @param metrics.enabled Start a exporter side-car
  ##
  enabled: false
  ## @param metrics.image.registry [default: REGISTRY_NAME] Apache exporter image registry
  ## @param metrics.image.repository [default: REPOSITORY_NAME/apache-exporter] Apache exporter image repository
  ## @skip metrics.image.tag Apache exporter image tag
  ## @param metrics.image.digest Apache exporter image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag
  ## @param metrics.image.pullPolicy Image pull policy
  ## @param metrics.image.pullSecrets Specify docker-registry secret names as an array
  ##
  image:
    registry: docker.io
    repository: bitnami/apache-exporter
    tag: 1.0.8-debian-12-r8
    digest: ""
    pullPolicy: IfNotPresent
    ## Optionally specify an array of imagePullSecrets.
    ## Secrets must be manually created in the namespace.
    ## ref: https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/
    ## e.g:
    ## pullSecrets:
    ##   - myRegistryKeySecretName
    ##
    pullSecrets: []
  ## @param metrics.resourcesPreset Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if metrics.resources is set (metrics.resources is recommended for production).
  ## More information: https://github.com/bitnami/charts/blob/main/bitnami/common/templates/_resources.tpl#L15
  ##
  resourcesPreset: "none"
  ## @param metrics.resources Set container requests and limits for different resources like CPU or memory (essential for production workloads)
  ## Example:
  ## resources:
  ##   requests:
  ##     cpu: 2
  ##     memory: 512Mi
  ##   limits:
  ##     cpu: 3
  ##     memory: 1024Mi
  ## ref: https://kubernetes.io/docs/concepts/configuration/manage-compute-resources-container/
  ##
  resources: {}
  ##
  ## @param metrics.podAnnotations [object] Additional annotations for Metrics exporter pod
  ##
  podAnnotations:
    prometheus.io/scrape: "true"
    prometheus.io/port: "9117"
  ## Drupal exporter service parameters
  ##
  service:
    ## @param metrics.service.type Drupal exporter service type
    ##
    type: ClusterIP
    ## @param metrics.service.ports.metrics Drupal exporter service port
    ##
    ports:
      metrics: 9117
    ## @param metrics.service.externalTrafficPolicy Drupal exporter service external traffic policy
    ## ref: https://kubernetes.io/docs/tasks/access-application-cluster/create-external-load-balancer/#preserving-the-client-source-ip
    ##
    externalTrafficPolicy: Cluster
    ## @param metrics.service.extraPorts Extra ports to expose (normally used with the `sidecar` value)
    ##
    extraPorts: []
    ## @param metrics.service.loadBalancerIP Drupal exporter service Load Balancer IP
    ## ref: https://kubernetes.io/docs/concepts/services-networking/service/#internal-load-balancer
    ##
    loadBalancerIP: ""
    ## @param metrics.service.loadBalancerSourceRanges Drupal exporter service Load Balancer sources
    ## https://kubernetes.io/docs/tasks/access-application-cluster/configure-cloud-provider-firewall/#restrict-access-for-loadbalancer-service
    ## e.g.
    ## loadBalancerSourceRanges:
    ##   - 10.10.10.0/24
    ##
    loadBalancerSourceRanges: []
    ## @param metrics.service.annotations Additional custom annotations for Drupal exporter service
    ##
    annotations: {}
  ## Prometheus Service Monitor
  ## ref: https://github.com/coreos/prometheus-operator
  ##      https://github.com/coreos/prometheus-operator/blob/master/Documentation/api.md#endpoint
  ##
  serviceMonitor:
    ## @param metrics.serviceMonitor.enabled Create ServiceMonitor resource(s) for scraping metrics using PrometheusOperator
    ##
    enabled: false
    ## @param metrics.serviceMonitor.namespace The namespace in which the ServiceMonitor will be created
    ##
    namespace: ""
    ## @param metrics.serviceMonitor.interval The interval at which metrics should be scraped
    ##
    interval: 30s
    ## @param metrics.serviceMonitor.scrapeTimeout The timeout after which the scrape is ended
    ##
    scrapeTimeout: ""
    ## @param metrics.serviceMonitor.relabellings Metrics RelabelConfigs to apply to samples before scraping.
    ##
    relabellings: []
    ## @param metrics.serviceMonitor.metricRelabelings Metrics RelabelConfigs to apply to samples before ingestion.
    ##
    metricRelabelings: []
    ## @param metrics.serviceMonitor.honorLabels Specify honorLabels parameter to add the scrape endpoint
    ##
    honorLabels: false
    ## @param metrics.serviceMonitor.additionalLabels Additional labels that can be used so ServiceMonitor resource(s) can be discovered by Prometheus
    ##
    additionalLabels: {}
  ## Custom PrometheusRule to be defined
  ## ref: https://github.com/coreos/prometheus-operator#customresourcedefinitions
  ##
  prometheusRule:
    ## @param metrics.prometheusRule.enabled Create a custom prometheusRule Resource for scraping metrics using PrometheusOperator
    ##
    enabled: false
    ## @param metrics.prometheusRule.namespace The namespace in which the prometheusRule will be created
    ##
    namespace: ""
    ## @param metrics.prometheusRule.additionalLabels Additional labels for the prometheusRule
    ##
    additionalLabels: {}
    ## @param metrics.prometheusRule.rules Custom Prometheus rules
    ## e.g:
    ## rules:
    ##   - alert: ApacheDown
    ##     expr: apache_up{service="{{ template "common.names.fullname" . }}-metrics"} == 0
    ##     for: 2m
    ##     labels:
    ##       severity: error
    ##     annotations:
    ##       summary: Drupal instance {{ "{{ $labels.instance }}" }} down
    ##       description: Drupal instance {{ "{{ $labels.instance }}" }} is down
    ##
    rules: []
## @section Certificate injection parameters

## Add custom certificates and certificate authorities to drupal container
##
certificates:
  ## @param certificates.customCertificate.certificateSecret Secret containing the certificate and key to add
  ## @param certificates.customCertificate.chainSecret.name Name of the secret containing the certificate chain
  ## @param certificates.customCertificate.chainSecret.key Key of the certificate chain file inside the secret
  ## @param certificates.customCertificate.certificateLocation Location in the container to store the certificate
  ## @param certificates.customCertificate.keyLocation Location in the container to store the private key
  ## @param certificates.customCertificate.chainLocation Location in the container to store the certificate chain
  ##
  customCertificate:
    certificateSecret: ""
    chainSecret:
      name: secret-name
      key: secret-key
    certificateLocation: /etc/ssl/certs/ssl-cert-snakeoil.pem
    keyLocation: /etc/ssl/private/ssl-cert-snakeoil.key
    chainLocation: /etc/ssl/certs/mychain.pem
  ## @param certificates.customCAs Defines a list of secrets to import into the container trust store
  ##
  customCAs: []
  ## @param certificates.command Override default container command (useful when using custom images)
  ##
  command: []
  ## @param certificates.args Override default container args (useful when using custom images)
  ##
  args: []
  ## @param certificates.extraEnvVars Container sidecar extra environment variables (eg proxy)
  ##
  extraEnvVars: []
  ## @param certificates.extraEnvVarsCM ConfigMap containing extra env vars
  ##
  extraEnvVarsCM: ""
  ## @param certificates.extraEnvVarsSecret Secret containing extra env vars (in case of sensitive data)
  ##
  extraEnvVarsSecret: ""
  ## @param certificates.image.registry [default: REGISTRY_NAME] Container sidecar registry
  ## @param certificates.image.repository [default: REPOSITORY_NAME/os-shell] Container sidecar image
  ## @skip certificates.image.tag Container sidecar image tag
  ## @param certificates.image.digest Container sidecar image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag
  ## @param certificates.image.pullPolicy Container sidecar image pull policy
  ## @param certificates.image.pullSecrets Container sidecar image pull secrets
  ##
  image:
    registry: docker.io
    repository: bitnami/os-shell
    tag: 12-debian-12-r29
    digest: ""
    ## Specify a imagePullPolicy
    ## Defaults to 'Always' if image tag is 'latest', else set to 'IfNotPresent'
    ## ref: https://kubernetes.io/docs/concepts/containers/images/#pre-pulled-images
    ##
    pullPolicy: IfNotPresent
    ## e.g:
    ## pullSecrets:
    ##   - myRegistryKeySecretName
    ##
    pullSecrets: []
## @section NetworkPolicy parameters

## Network Policy configuration
## ref: https://kubernetes.io/docs/concepts/services-networking/network-policies/
##
networkPolicy:
  ## @param networkPolicy.enabled Specifies whether a NetworkPolicy should be created
  ##
  enabled: true
  ## @param networkPolicy.allowExternal Don't require server label for connections
  ## The Policy model to apply. When set to false, only pods with the correct
  ## server label will have network access to the ports server is listening
  ## on. When true, server will accept connections from any source
  ## (with the correct destination port).
  ##
  allowExternal: true
  ## @param networkPolicy.allowExternalEgress Allow the pod to access any range of port and all destinations.
  ##
  allowExternalEgress: true
  ## @param networkPolicy.extraIngress [array] Add extra ingress rules to the NetworkPolicy
  ## e.g:
  ## extraIngress:
  ##   - ports:
  ##       - port: 1234
  ##     from:
  ##       - podSelector:
  ##           - matchLabels:
  ##               - role: frontend
  ##       - podSelector:
  ##           - matchExpressions:
  ##               - key: role
  ##                 operator: In
  ##                 values:
  ##                   - frontend
  extraIngress: []
  ## @param networkPolicy.extraEgress [array] Add extra ingress rules to the NetworkPolicy
  ## e.g:
  ## extraEgress:
  ##   - ports:
  ##       - port: 1234
  ##     to:
  ##       - podSelector:
  ##           - matchLabels:
  ##               - role: frontend
  ##       - podSelector:
  ##           - matchExpressions:
  ##               - key: role
  ##                 operator: In
  ##                 values:
  ##                   - frontend
  ##
  extraEgress: []
  ## @param networkPolicy.ingressNSMatchLabels [object] Labels to match to allow traffic from other namespaces
  ## @param networkPolicy.ingressNSPodMatchLabels [object] Pod labels to match to allow traffic from other namespaces
  ##
  ingressNSMatchLabels: {}
  ingressNSPodMatchLabels: {}

