apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-jellyfin-movies
spec:
  capacity:
    storage: 10Gi
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  storageClassName: ""
  nfs:
    path: /volume2/kubernetes/${cluster}/jellyfin-movies
    server: 192.168.1.11
  claimRef:
    namespace: ${namespace}
    name: jellyfin-movies
