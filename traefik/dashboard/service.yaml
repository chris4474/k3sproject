apiVersion: v1
kind: Service
metadata:
  name: traefik-dashboard
  namespace: kube-system
spec:
  internalTrafficPolicy: Cluster
  ipFamilies:
  - IPv4
  ipFamilyPolicy: SingleStack
  ports:
  - port: 9000
    protocol: TCP
    targetPort: 9000
  selector:
    app.kubernetes.io/instance: traefik-kube-system
    app.kubernetes.io/name: traefik
  sessionAffinity: None
  type: ClusterIP
