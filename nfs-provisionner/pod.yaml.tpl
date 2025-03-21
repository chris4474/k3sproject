---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: storage-claim1
  namespace: ${namespace}
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: nfs-csi
  resources:
    requests:
      storage: 200Mi

---
apiVersion: v1
kind: Pod
metadata:
  name: pod1
  namespace: ${namespace} 
  labels:
    app: nfs-client
    mypod: "" 
spec:
#  nodeSelector:
#    mylabel: "yes"
  volumes:
  - name: pod-data1
    persistentVolumeClaim:
      claimName: storage-claim1
  terminationGracePeriodSeconds: 1
  containers:
  - name: storage-pod
    command:
    - sh
    - -c
    - while true; do sleep 1; done
    image: curlimages/curl:7.76.0
    #image: radial/busyboxplus:curl
    volumeMounts:
    - mountPath: /tmp/foo
      name: pod-data1

