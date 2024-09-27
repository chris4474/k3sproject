apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc-mosquitto
  namespace: ${namespace}
spec:
  storageClassName: ""
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
