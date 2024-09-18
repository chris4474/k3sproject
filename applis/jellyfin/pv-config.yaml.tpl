apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-jellyfin-config
spec:
  capacity:
    storage: 500Mi
  volumeMode: Filesystem
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  storageClassName: ""
  local:
    path: /jellyfin/config
  nodeAffinity:
    required:
      nodeSelectorTerms:
        - matchExpressions:
            - key: kubernetes.io/hostname
              operator: In
              values:
                - ${config_storage_node} 
  claimRef:
    namespace: ${namespace}
    name: jellyfin-config

