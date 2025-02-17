apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: jellyfin-movies
  namespace: ${namespace}
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 10Gi
  storageClassName: ""
