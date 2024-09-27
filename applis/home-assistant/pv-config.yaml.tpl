apiVersion: v1
kind: PersistentVolume
metadata:
  name: home-assistant-config
spec:
  capacity:
    storage: 1Gi
  volumeMode: Filesystem
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  storageClassName: ""
  local:
    path: /home-assistant/config
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
    name: ha-home-assistant-ha-home-assistant-0
