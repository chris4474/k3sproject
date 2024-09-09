apiVersion: v1
kind: Service
metadata:
  labels:
    io.kompose.service: jellyfin
  name: jellyfin
  namespace: ${namespace}
spec:
  ports:
    - name: "8096"
      port: 8096
      targetPort: 8096
  selector:
    io.kompose.service: jellyfin
