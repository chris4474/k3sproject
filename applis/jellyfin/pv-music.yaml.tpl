apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-jellyfin-music
spec:
  capacity:
    storage: 10Gi
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  storageClassName: manual
  nfs:
    path: /volume2/kubernetes/${cluster}/jellyfin-music
    server: 192.168.1.11
  claimRef:
    namespace: ${namespace}
    name: jellyfin-music
