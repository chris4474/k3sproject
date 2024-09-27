apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-mosquitto
spec:
  capacity:
    storage: 1Gi
  volumeMode: Filesystem
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  storageClassName: ""
  local:
    path: /persistent-volumes/mosquitto/data
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
    name: pvc-mosquitto

